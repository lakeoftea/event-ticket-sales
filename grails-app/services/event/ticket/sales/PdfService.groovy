package event.ticket.sales

import grails.gorm.transactions.Transactional
import groovy.xml.XmlUtil
import org.apache.commons.io.FileUtils
import org.apache.commons.io.IOUtils
import org.apache.fop.apps.FOUserAgent
import org.apache.fop.apps.Fop
import org.apache.fop.apps.FopFactory
import org.apache.fop.apps.MimeConstants

import javax.xml.transform.Result
import javax.xml.transform.Source
import javax.xml.transform.Transformer
import javax.xml.transform.TransformerFactory
import javax.xml.transform.sax.SAXResult
import javax.xml.transform.stream.StreamSource
import java.rmi.server.ExportException

@Transactional
class PdfService {

    final FopFactory fopFactory = FopFactory.newInstance(new File('.').toURI())
    FOUserAgent foUserAgent = fopFactory.newFOUserAgent()
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()

    File ticketPdfXSLT = new File(this.class.classLoader.getResource("xslt/ticket.xsl").toURI())

    ByteArrayOutputStream createTicketPdf(Sale sale) {
        SaleService saleService = new SaleService()
        try {
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, byteArrayOutputStream)
            TransformerFactory factory = TransformerFactory.newInstance()
            Transformer transformer = factory.newTransformer(new StreamSource(ticketPdfXSLT))
            Source src = new StreamSource(IOUtils.toInputStream(saleService.generateTicketXml(sale)))
            Result res = new SAXResult(fop.getDefaultHandler())
            transformer.transform(src, res)
        } catch(Exception ex) {
            log.error ex.printStackTrace()
        }
        byteArrayOutputStream
    }
}
