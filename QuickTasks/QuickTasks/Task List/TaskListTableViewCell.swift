//
//  TaskListTableViewCell.swift
//  QuickTasks
//
//  Created by Kruti Boghara on 31/01/24.
//

import UIKit

protocol TaskListTableViewCellDelegate: AnyObject {
    func taskCompleted(_ task: String)
    func taskUncompleted(_ task: String)
}


class TaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    weak var delegate: TaskListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        if checkImage.image == UIImage(systemName: "circle") {
            
            checkImage.image = UIImage(systemName: "checkmark.circle.fill")
            delegate?.taskCompleted(taskLabel.text ?? "")

        } else if checkImage.image == UIImage(systemName: "checkmark.circle.fill") {
            
            checkImage.image = UIImage(systemName: "circle")
            delegate?.taskUncompleted(taskLabel.text ?? "")

            
        }
    }
}
