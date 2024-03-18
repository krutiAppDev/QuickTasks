//
//  CompletedViewController.swift
//  QuickTasks
//
//  Created by Kruti Boghara on 31/01/24.
//

import UIKit

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewControllerDelegate {
    
    @IBOutlet weak var completedTableView: UITableView!
    
    var completeTaskArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "completeTaskArray") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "completeTaskArray")
        }
    }
    
    // Declare the delegate property
    weak var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completedTableView.delegate = self
        completedTableView.dataSource = self
        
        guard completedTableView != nil else {
            fatalError("completedTableView outlet not connected")
        }
        
        if let completedTasks = UserDefaults.standard.stringArray(forKey: "completeTaskArray") {
            completeTaskArray = completedTasks
        }
    }
    
    func taskCompleted(_ task: String) {
        print("Task completed in CompletedViewController: \(task)")
        completeTaskArray.append(task)
        print("Complete Task Array: \(completeTaskArray)")
        // The didSet block will save completed tasks to UserDefaults
    }
    
    func taskUncompleted(_ task: String) {
        if let index = completeTaskArray.firstIndex(of: task) {
            completeTaskArray.remove(at: index)
            completedTableView.reloadData()
            // Notify the delegate (TaskViewController) about the uncompleted task
            delegate?.taskUncompleted(task)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completeTaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaskTableViewCell", for: indexPath) as? CompletedTaskTableViewCell {
            
            cell.completedTaskLabel.text = completeTaskArray[indexPath.row]
            cell.checkImage.image = UIImage(systemName: "checkmark.circle.fill")
            return cell
        }
        
        return UITableViewCell()
    }
}
