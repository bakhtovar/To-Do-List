//
//  ToDoViewController.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 08/04/23.
//

import UIKit
import SnapKit
import CoreData
import UserNotifications
import RxSwift
import RxCocoa

class ToDoViewController: UIViewController {
    
    //MARK: - Data Layeer
    private var models = [Task]()
    var currentUser: UserInfo?
    
    //MARK: - Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - RxSwift
    private let disposeBag = DisposeBag()
  //  private let viewModel = ToDoViewModel()
    
    //MARK: - UI
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
        return layout
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.nameOfClass)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do list"
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.addSubview(logoutButton)
        getAllItems()
        setupBag()
        makeConstraints()
    
        fetchCurrentUser()
        requestNotificationPermissions()
        
    }
    
    // MARK: - Private
    private func makeConstraints() {
        logoutButton.snp.makeConstraints { make in
               make.width.equalTo(90)
               make.height.equalTo(50)
               make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
               make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-36)
           }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBag() {
        logoutButton.rx.tap
                   .subscribe(onNext: { [weak self] in
                       self?.didTapLogout()
                   })
                   .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
                navigationItem.rightBarButtonItem?.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.didTapAdd()
                    })
                    .disposed(by: disposeBag)
    }
    
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }
    
    private func sendCompletionNotification(taskTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Task Completed"
        content.body = "The task '\(taskTitle)' has been completed."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    
    private func fetchCurrentUser() {
        // Fetch the user's email from UserDefaults
        guard let userEmail = UserDefaults.standard.string(forKey: "loggedInUserEmail") else {
            print("Error: User email not found in UserDefaults")
            return
        }

        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gmail == %@", userEmail)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                currentUser = user
                getAllItems()
            } else {
                print("Error: User not found in Core Data")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    
    private func scheduleOverdueTaskNotification(task: Task) {
        guard let taskTitle = task.title, let deadline = task.deadline else { return }

        let content = UNMutableNotificationContent()
        content.title = "Overdue Task"
        content.body = "The task '\(taskTitle)' is overdue."
        content.sound = .default

        let timeInterval = deadline.timeIntervalSinceNow
        if timeInterval <= 0 {
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling overdue task notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func clearUserData() {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         do {
             try context.execute(deleteRequest)
             try context.save()
         } catch {
             print("Error clearing user data: \(error)")
         }
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Title"
        })

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Performer"
        })

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Deadline (dd.MM.yyyy)"
        })

        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let titleField = alert.textFields?[0], let title = titleField.text, !title.isEmpty,
                  let performerField = alert.textFields?[1], let performer = performerField.text, !performer.isEmpty,
                  let deadlineField = alert.textFields?[2], let deadlineString = deadlineField.text, !deadlineString.isEmpty,
                  let deadline = self?.dateFromString(dateString: deadlineString)
            else {
                return
            }

            self?.createItem(name: title, performer: performer, deadline: deadline)
        }))
        present(alert, animated: true)
        
        
        guard let deadlineTextField = alert.textFields?[2] else { return }
                deadlineTextField.rx.text
                    .map { text -> Bool in
                        return text?.isEmpty == false
                    }
                    .bind(to: alert.actions[0].rx.isEnabled)
                    .disposed(by: disposeBag)
    }

    private func dateFromString(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: dateString)
    }

    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }
    
    @objc private func didTapLogout() {
        clearUserData()

        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func getAllItems() {
        do {
            models = try context.fetch(Task.fetchRequest())
            for task in models {
                scheduleOverdueTaskNotification(task: task)
                if let commentsSet = task.comments as? Set<Comment>, !commentsSet.isEmpty {
                    let commentsText = commentsSet.map { "\($0.author ?? ""): \($0.text ?? "")" }.joined(separator: "\n\n")
                    print("Task: \(task.title ?? "") - Comments: \(commentsText)")
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            // Error handling
        }
    }

    private func addComment(to task: Task, author: String, text: String) {
        let newComment = Comment(context: context)
        newComment.author = author
        newComment.text = text
        newComment.task = task

        task.addToComments(newComment)

        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error saving new comment: \(error)")
        }
    }
    
   
    
    private func createItem(name: String, performer: String, deadline: Date) {
        let newItem = Task(context: context)
        newItem.title = name
        newItem.performer = performer
        newItem.deadline = deadline

        do {
            try context.save()
            print("Item added successfully")
            getAllItems()
        } catch {
            print("Error saving new item: \(error)")
        }
    }
 
    private func deleteItem(item: Task) {
        let taskTitle = item.title ?? ""
        context.delete(item)
        do {
            try context.save()
            getAllItems()
            sendCompletionNotification(taskTitle: taskTitle)
            
        } catch {
            
        }
    }
    
    private func updateItem(item: Task, newName: String) {
        item.title = newName
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
}


extension ToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            models.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.nameOfClass, for: indexPath) as! TaskCollectionViewCell
    
        let viewModel = TaskCollectionViewCellViewModel(task: model)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           collectionView.deselectItem(at: indexPath, animated: true)
           
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName )
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self ] _ in
            
        self?.deleteItem(item: item)
        }))
        
        
        sheet.addAction(UIAlertAction(title: "Add Comment", style: .default, handler: { [weak self] _ in
                let alert = UIAlertController(title: "Add Comment", message: "Add your comment", preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Author"
                })

                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Comment"
                })

                alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
                    guard let authorField = alert.textFields?[0], let author = authorField.text, !author.isEmpty,
                          let textField = alert.textFields?[1], let text = textField.text, !text.isEmpty
                    else {
                        return
                    }

                    self?.addComment(to: item, author: author, text: text)
                }))
                self?.present(alert, animated: true)
            }))
        
        present(sheet, animated: true)
    }
}


extension NSObject {

    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
