//
//  HomeViewModel.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//

import UIKit

class HomeViewModel {
    func signInButtonTapped() -> SignInViewController {
        return SignInViewController()
    }
    
    func signUpButtonTapped() -> SignUpViewController {
        return SignUpViewController()
    }
}
