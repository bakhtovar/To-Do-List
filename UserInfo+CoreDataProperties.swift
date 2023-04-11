//
//  UserInfo+CoreDataProperties.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var gmail: String?
    @NSManaged public var password: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension UserInfo {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension UserInfo : Identifiable {

}
