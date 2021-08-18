//
//  deleteTaskCell.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-07-26.
//

import Foundation
import UIKit

class deleteTaskCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        accessoryType = selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        }
    
}
