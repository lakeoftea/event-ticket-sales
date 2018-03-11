// TODO maxSize is config variable

package event.ticket.sales

class Ticket {
    String name
    String description
    Double price
    String ticketImageName
    String ticketImageContentType
    byte[] ticketImageBytes
    String ticketLogoName
    String ticketLogoContentType
    byte[] ticketLogoBytes

    static constraints = {
        name blank: false
        description blank: false
        price blank: false
        ticketImageName blank:false
        ticketImageBytes blank: false, maxSize: 1024 * 1024 * 10
        ticketImageContentType blank: false
        ticketLogoName blank: false
        ticketLogoContentType blank: false
        ticketLogoBytes blank: false, maxSize: 1024 * 1024 * 10
    }

}