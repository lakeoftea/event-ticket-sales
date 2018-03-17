package event.ticket.sales

import grails.util.Environment
import org.apache.commons.io.IOUtils

import java.time.LocalDateTime
import java.time.ZoneId


class BootStrap {

    def init = { servletContext ->

        DateService dateService = new DateService()

        def resourcePath = "${System.properties['user.dir']}/src/test/resources"
        byte[] titleBackground = IOUtils.toByteArray(new FileInputStream("${resourcePath}/ticketBackground.png"))
        byte[] titleBackground2 = IOUtils.toByteArray(new FileInputStream("${resourcePath}/ticketBackground2.jpg"))
        byte[] ticketLogo = IOUtils.toByteArray(new FileInputStream("${resourcePath}/ticketLogo.gif"))
        byte[] ticketLogo2 = IOUtils.toByteArray(new FileInputStream("${resourcePath}/ticketLogo2.jpg"))
        byte[] poster = IOUtils.toByteArray(new FileInputStream("${resourcePath}/poster.jpg"))
        byte[] poster2 = IOUtils.toByteArray(new FileInputStream("${resourcePath}/poster2.jpg"))
        byte[] poster3 = IOUtils.toByteArray(new FileInputStream("${resourcePath}/poster3.jpg"))

        switch(Environment.current){
            case(Environment.DEVELOPMENT):
                new Ticket(quantity: 75, name: "General Admission", description: "Stadium Seating", price: "30.00",
                        ticketImageName: "titleBackground.png", ticketImageBytes: titleBackground, ticketImageContentType: "image/png",
                        ticketLogoName: "ticketLogo.gif", ticketLogoContentType: "image/gif", ticketLogoBytes: ticketLogo).save()
                new Ticket(quantity: 60, name: "Cage Seating", description: "Tables around the cage", price: "60.00",
                                    ticketImageName: "titleBackground2.jpg", ticketImageBytes: titleBackground2, ticketImageContentType: "image/jpg",
                                    ticketLogoName: "ticketLogo2.jpg", ticketLogoContentType: "image/jpg", ticketLogoBytes: ticketLogo2).save()
                new Ticket(quantity: 9, name: "Table Seats", description: "Tables outside the ring", price: "45.00",
                        ticketImageName: "titleBackground.png", ticketImageBytes: titleBackground, ticketImageContentType: "image/png",
                        ticketLogoName: "ticketLogo2.jpg", ticketLogoContentType: "image/jpg", ticketLogoBytes: ticketLogo2).save()
                new Ticket(quantity: 30, name: "Director Seat", description: "View the fights from 50 feet in the air on the safety of a cherrypicker.  Waiver required.", price: "120.00",
                        ticketImageName: "titleBackground2.jpg", ticketImageBytes: titleBackground2, ticketImageContentType: "image/jpg",
                        ticketLogoName: "ticketLogo.gif", ticketLogoContentType: "image/gif", ticketLogoBytes: ticketLogo).save()

                new Event(name: "Battle on the Boat", shortURL: "battle-on-the-boat", description: "12 fights and 2 championship fights for a full night of entertainment!",
                        address: "313 E. Scott, Kirksville MO, 63501", posterContentType: "image/jpg", posterBytes: poster, posterName: "poster.jpg",
                        doorsOpen: dateService.getDate(2018, 6, 21, 19, 0), eventStarts: dateService.getDate(2018, 6, 21, 20, 0),
                        stopTicketSalesAt: dateService.getDate(2018, 6, 21, 20, 30), enabled: true, tickets: Ticket.findAll()[0]).save()

                new Event(name: "Rumble at the Ridge", shortURL: "rumble-at-the-ridge", description: "16 Fights for over 6 hours of fights.  Featuring the MU Golden Girls.",
                        address: "2345 Winchester Dr., Columbia, MO 65201", posterContentType: "image/jpg", posterBytes: poster2, posterName: "poster2.jpg",
                        doorsOpen: dateService.getDate(2018, 4, 16, 16, 0), eventStarts: dateService.getDate(2018, 4, 16, 17, 0),
                        stopTicketSalesAt: dateService.getDate(2018, 4, 16, 17, 0), enabled: true, tickets: [Ticket.findAll()[0], Ticket.findAll()[2], Ticket.findAll()[3]]).save()

                new Event(name: "Fight at the Farm", shortURL: "fight-at-the-farm", description: "4 Championship Fights at Noon for the Golden Belt.  A day you will never forget!",
                        address: "433 Skylake Ave., Chicago, Illinios 45678", posterContentType: "image/jpg", posterBytes: poster3, posterName: "poster3.jpg",
                        doorsOpen: dateService.getDate(2018, 5, 30, 20, 00), eventStarts: dateService.getDate(2018, 5, 30, 21, 00),
                        stopTicketSalesAt: dateService.getDate(2018, 5, 30, 21, 0), enabled: false, tickets: [Ticket.findAll()[1], Ticket.findAll()[2], Ticket.findAll()[3]]).save()


                break
            case(Environment.PRODUCTION):
                break
        }
    }
    def destroy = {
    }
}
