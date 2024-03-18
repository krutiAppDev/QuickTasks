//
//  CompletedTaskTableViewCell.swift
//  QuickTasks
//
//  Created by Kruti Boghara on 31/01/24.
//

import UIKit

class CompletedTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var completedTaskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        if checkImage.image == UIImage(systemName: "checkmark.circle.fill") {
            
            checkImage.image = UIImage(systemName: "circle")
            
        } else if checkImage.image == UIImage(systemName: "circle") {
            
            checkImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
    }
}
