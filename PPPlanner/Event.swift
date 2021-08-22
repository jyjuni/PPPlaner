//
//  Event.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import Foundation
import UIKit


var eventsList = [Event]()

class Event
{
    var id: Int!
    var name: String!
    var date: Date!
    
    

   
    func eventsforDate(date:Date) -> [Event]
    {
        var daysEvent = [Event]()
        for event in eventsList
        {
            if(Calendar.current.isDate(event.date, inSameDayAs:date))
            {
                daysEvent.append(event)
            }
        }
        return daysEvent
    }
}
