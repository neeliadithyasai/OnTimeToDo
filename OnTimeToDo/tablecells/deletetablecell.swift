//
//  deletetablecell.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-07-15.
//

import Foundation
import UIKit

class deletetablecell: UITableViewCell {
    
    @IBOutlet weak var deleteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        accessoryType = selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        }
}
