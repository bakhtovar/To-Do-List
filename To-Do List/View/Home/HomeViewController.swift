//
//  HomeViewController.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 06/04/23.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // MARK: - UI
    private let homeViewModel = HomeViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()

    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        setupNavigation()
        view.backgroundColor = .black
        
    }

    // MARK: - Private
    
    private func setupNavigation() {
        // Initialize navigation controller
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationItem.largeTitleDisplayMode = .always

            // Set up navigation controller
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.barTintColor = .clear
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            // Set the navigation controller as the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }

        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(240)
            make.height.equalTo(60)
        }

        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.equalTo(240)
            make.height.equalTo(60)
        }
    }

    @objc private func signInButtonTapped() {
        let signInVC = homeViewModel.signInButtonTapped()
        navigationController?.pushViewController(signInVC, animated: true)
       }
    
    @objc private func signUpButtonTapped() {
            let signUpVC = homeViewModel.signUpButtonTapped()
            navigationController?.pushViewController(signUpVC, animated: true)
        }

}
