//
//  EventsListItem+CoreDataProperties.swift
//  
//
//  Created by JIN YIJIA on 8/21/21.
//
//

import Foundation
import CoreData


extension EventsListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventsListItem> {
        return NSFetchRequest<EventsListItem>(entityName: "EventsListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var date: Date?

}
