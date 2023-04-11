//
//  TaskHistory+CoreDataProperties.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 10/04/23.
//
//

import Foundation
import CoreData


extension TaskHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskHistory> {
        return NSFetchRequest<TaskHistory>(entityName: "TaskHistory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskID: UUID?
    @NSManaged public var changeType: String?
    @NSManaged public var changeDate: Date?
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskDeadline: Date?

}

extension TaskHistory : Identifiable {

}


extension TaskHistory {
    @nonobjc public class func create(context: NSManagedObjectContext, task: Task, changeType: String) -> TaskHistory {
        let taskHistory = TaskHistory(context: context)
        taskHistory.id = UUID()
       // taskHistory.taskID = task.id
        taskHistory.changeType = changeType
        taskHistory.changeDate = Date()
        taskHistory.taskTitle = task.title ?? ""
       // taskHistory.taskDescription = task.taskDescription ?? ""
        taskHistory.taskDeadline = task.deadline

        return taskHistory
    }
}
