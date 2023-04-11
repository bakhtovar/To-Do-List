//
//  SignUpViewModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//


import UIKit
import CoreData

class SignUpViewModel {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(false, "Please enter both email and password")
            return
        }
        if isUserExists(email: email) {
            completion(false, "This user already exists")
        } else {
            let newUser = UserInfo(context: context)
            newUser.gmail = email
            newUser.password = password
            
            do {
                try context.save()
                completion(true, "You have been signed up successfully")
            } catch {
                print("Error saving user data: \(error.localizedDescription)")
                completion(false, "This user is already exists. Try again")
            }
        }
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
}
