//
//  SignInModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//

import UIKit
import CoreData

class SignInModel {
    
    func checkForMatch(gmail: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gmail = %@ AND password = %@", gmail, password)

        do {
            let results = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            completion(results.count > 0)
            
        } catch {
            print("Error fetching user: \(error)")
            completion(false)
        }
    }
}

