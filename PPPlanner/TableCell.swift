//
//  TableCell.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/24/21.
//

import UIKit

class TableCell: UITableViewCell{
    
    @IBOutlet weak var timeTF: UILabel!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var colorLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //gets called every time isSelected is set.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
