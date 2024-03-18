//
//  ViewController.swift
//  QuickTasks
//
//  Created by Kruti Boghara on 30/01/24.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func taskCompleted(_ task: String)
    func taskUncompleted(_ task: String)
}

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, TaskViewControllerDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    weak var delegate: TaskViewControllerDelegate?
    
    var taskArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "taskArray") ?? ["Shopping", "Fruits", "Meeting at 7 PM", "House cleaning", "Hairwashing day"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "taskArray")
        }
    }
    
    var completeTaskArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "completeTaskArray") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completeTaskArray")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        if let completedVC = tabBarController?.viewControllers?[1] as? TaskViewControllerDelegate {
            delegate = completedVC
        }
        if let completedTasks = UserDefaults.standard.stringArray(forKey: "completeTaskArray") {
            completeTaskArray = completedTasks
        }
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Add task here"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let newTask = textField.text, !newTask.isEmpty else {
                return
            }
            
            self?.taskArray.insert(newTask, at: 0)
            self?.taskArray = self?.taskArray ?? []
            
            // Save the updated taskArray
            UserDefaults.standard.set(self?.taskArray, forKey: "taskArray")
            self?.taskTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        UserDefaults.standard.set(taskArray, forKey: "taskArray")
                taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as? TaskListTableViewCell {
            
            cell.checkImage.image = UIImage(systemName: "circle")
            cell.checkImage.tintColor = UIColor(named: "Tint Color")
            cell.taskLabel.text = taskArray[indexPath.row]
            cell.delegate = self
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    //MARK: - TabBarController Transition
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTabBarTransitionAnimator()
    }
    
    class MyTabBarTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5 // Set the duration of your animation
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromVC = transitionContext.viewController(forKey: .from)!
            let toVC = transitionContext.viewController(forKey: .to)!
            let containerView = transitionContext.containerView
            
            toVC.view.alpha = 0.0
            containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.alpha = 0.0
                toVC.view.alpha = 1.0
            }) { (finished) in
                fromVC.view.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

extension TaskViewController: TaskListTableViewCellDelegate {
    func taskCompleted(_ task: String) {
        if let index = taskArray.firstIndex(of: task) {
            taskArray.remove(at: index)
            delegate?.taskCompleted(task)
        }
        
        UserDefaults.standard.set(taskArray, forKey: "taskArray")
        taskTableView.reloadData()
    }
    
    func taskUncompleted(_ task: String) {
        taskArray.insert(task, at: 0)
        delegate?.taskUncompleted(task)
        
        UserDefaults.standard.set(taskArray, forKey: "taskArray")
        taskTableView.reloadData()
    }
}
