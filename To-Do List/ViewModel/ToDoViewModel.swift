//
//  ToDoViewModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 10/04/23.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class ToDoViewModel {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let disposeBag = DisposeBag()
    
    let tasks = BehaviorRelay<[Task]>(value: [])
    
    init() {
        fetchAllItems()
    }

    private func fetchAllItems() {
        do {
            let fetchedTasks = try context.fetch(Task.fetchRequest()) as? [Task]
            tasks.accept(fetchedTasks ?? [])
        } catch {
            // Error handling
        }
    }

    func createItem(name: String, performer: String, deadline: Date) {
        let newItem = Task(context: context)
        newItem.title = name
        newItem.performer = performer
        newItem.deadline = deadline

        do {
            try context.save()
            fetchAllItems()
        } catch {
            print("Error saving new item: \(error)")
        }
    }
    
    func deleteItem(item: Task) {
        context.delete(item)
        do {
            try context.save()
            fetchAllItems()
        } catch {
            print("Error deleting item: \(error)")
        }
    }

    func updateItem(item: Task, newName: String) {
        item.title = newName

        do {
            try context.save()
            fetchAllItems()
        } catch {
            print("Error updating item: \(error)")
        }
    }

    func addComment(to task: Task, author: String, text: String) {
        let newComment = Comment(context: context)
        newComment.author = author
        newComment.text = text
        newComment.task = task

        task.addToComments(newComment)

        do {
            try context.save()
            fetchAllItems()
        } catch {
            print("Error saving new comment: \(error)")
        }
    }
}
