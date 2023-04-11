//
//  Comment+CoreDataProperties.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 07/04/23.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var author: String?
    @NSManaged public var text: String?
    @NSManaged public var task: Task?

}

extension Comment : Identifiable {

}
