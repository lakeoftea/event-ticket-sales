package event.ticket.sales

class Sale {
    Event event
    SaleStatus salesStatus
    String uuid
    String rawRecord
    Double totalBeforeFeesAndTaxes
    Double totalAfterFeesAndTaxes
    Double taxes
    Double totalSurcharge
    Double primaryAllocation
    Double secondaryAllocation
    Double primaryPercentage
    boolean allocationEnabled
    String customerName
    String phoneNumber
    String emailAddress
    byte[] ticketPDF
    boolean consumed
    Date dateCreated
    Date lastUpdated

    static constraints = {
        uuid blank:false
        event blank:false
        salesStatus blank:false
        rawRecord blank:false
        totalBeforeFeesAndTaxes blank:false
        totalAfterFeesAndTaxes blank:false
        taxes blank:false
        totalSurcharge blank:false
        primaryAllocation blank:false
        secondaryAllocation blank:false
        primaryPercentage blank:false
        allocationEnabled blank:false
        customerName blank:false
        phoneNumber blank:false
        emailAddress blank:false
        ticketPDF blank: false, maxSize: 1024 * 1024 * 10
        consumed default:false
    }
}
