//
//  TaskCollectionViewCellViewModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 10/04/23.
//

import UIKit

class TaskCollectionViewCellViewModel {

    private let task: Task

    init(task: Task) {
        self.task = task
    }

    var title: String {
        return task.title ?? ""
    }

    var dueDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        if let deadline = task.deadline {
            return "Due Date: \(dateFormatter.string(from: deadline))"
        } else {
            return "No Deadline"
        }
    }

    var performer: String {
        if let performer = task.performer, !performer.isEmpty {
            return "Performer: \(performer)"
        } else {
            return "No Performer"
        }
    }

    var commentsText: String {
        if let commentsSet = task.comments as? Set<Comment>, !commentsSet.isEmpty {
            return commentsSet.map { "\($0.author ?? ""): \($0.text ?? "")" }.joined(separator: "\n\n")
        } else {
            return "No Comments"
        }
    }
}
