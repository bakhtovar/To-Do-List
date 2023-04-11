//
//  Task+CoreDataProperties.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 10/04/23.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var deadline: Date?
    @NSManaged public var performer: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var comments: NSSet?
    @NSManaged public var user: NSSet?
    @NSManaged public var history: NSSet?

}

// MARK: Generated accessors for comments
extension Task {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for user
extension Task {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: UserInfo)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: UserInfo)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

// MARK: Generated accessors for history
extension Task {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: TaskHistory)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: TaskHistory)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

extension Task : Identifiable {

}
