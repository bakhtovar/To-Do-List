//
//  SignInViewModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//

import UIKit
import CoreData

class SignInViewModel {
    
    private let model = SignInModel()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func checkSignInStatus() -> Bool {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
            }
            let managedContext = appDelegate.persistentContainer.viewContext
    
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
    
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    return true
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
    
            return false
        }
        
    func isUserExists(email: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        fetchRequest.predicate = NSPredicate(format: "gmail == %@", email)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            return false
        }
    }

        func signIn(gmail: String, password: String, completion: @escaping (Bool) -> Void) {
            model.checkForMatch(gmail: gmail, password: password) { (isMatch) in
                completion(isMatch)
                UserDefaults.standard.string(forKey: "loggedInUserEmail")
            }
        }
}
