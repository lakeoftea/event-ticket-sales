package event.ticket.sales

import grails.gorm.transactions.Transactional
import groovy.xml.MarkupBuilder

@Transactional
class SaleService {

    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)
    TicketService ticketService = new TicketService()

    def generateTicketXml(def sale) {
        def logoList = []
        def advertList = []
        def logo
        def advert
        Random random = new Random()

        ticketService.rawRecordToRawRecordItemMap(sale.rawRecord).each{
            if(Ticket.findByName(it.name)) {
                advertList << [Bytes: Ticket.findByName(it.name).ticketImageBytes, ContentType: Ticket.findByName(it.name).ticketImageContentType]
            }
            if(Ticket.findByName(it.name)) {
                logoList << [Bytes: Ticket.findByName(it.name).ticketLogoBytes, ContentType: Ticket.findByName(it.name).ticketLogoContentType]
            }
        }

        logo = logoList.get(random.nextInt(logoList.size()))
        advert = advertList.get(random.nextInt(advertList.size()))

        xml.Sale(){
            Images{
                Poster(Bytes:new String(Base64.getEncoder().encode(sale.event.posterBytes)), ContentType:sale.event.posterContentType)
                Logo(Bytes:new String(Base64.getEncoder().encode(logo.Bytes)), ContentType:logo.ContentType)
                Advert(Bytes:new String(Base64.getEncoder().encode(advert.Bytes)), ContentType:advert.ContentType)
            }
            UUID(sale.uuid)
            Event(Name:sale.event.name, Description: sale.event.description,
                    DoorsOpen:sale.event.doorsOpen, EventStarts: sale.event.eventStarts,
                    Address:sale.event.address)
            Tickets {
                ticketService.rawRecordToRawRecordItemMap(sale.rawRecord).each {
                    Ticket(Name:it.name, Description:it.description, Price:it.price, Quantity:it.quantity)
                }
            }
            Totals(TotalAfterFeesAndTaxes:sale.totalAfterFeesAndTaxes, FeesAndTaxes:sale.taxes + sale.totalSurcharge)
            Customer(Name:sale.customerName, PhoneNumer:sale.phoneNumber, EmailAddress: sale.emailAddress)
        }
        writer.close()
        return writer.toString()
    }
}
