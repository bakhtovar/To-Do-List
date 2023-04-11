//
//  SignInViewController.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 06/04/23.
//


import UIKit
import SnapKit
import CoreData


class SignInViewController: UIViewController {
    
    // MARK: - UI
    
    private let viewModel = SignInViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.layer.borderColor = UIColor.white.cgColor
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor.white
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor.white
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check sign-in status
        //checkSignInStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        makeConstraints()
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
    }
    
    private func makeConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(-50)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    // MARK: - Actions
    
    @objc private func signInButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        saveUser(gmail: email, password: password)
        
    }
    
    
    private func showAlert(withTitle title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }


    // MARK: - Core Data
    
     private func saveUser(gmail: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gmail = %@", gmail)
         
         let accountVC = ToDoViewController()
         navigationController?.setViewControllers([accountVC], animated: true)

        do {
            let results = try managedContext.fetch(fetchRequest)
            if let user = results.first, user.gmail == gmail {
                UserDefaults.standard.set(gmail, forKey: "loggedInUserEmail")
//                let accountVC = ToDoViewController()
//                navigationController?.setViewControllers([accountVC], animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Incorrect email or password. Try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            showAlert(withTitle: "Error", message: "An error occurred. Please try again later.")
        }
    }
    
//        func checkSignInStatus() -> Bool {
//            return viewModel.checkSignInStatus()
//        }
//
}
