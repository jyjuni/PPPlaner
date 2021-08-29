//
//  HisCell.swift
//  PPPlanner
//
//  Created by Yijia Jin on 2021/8/29.
//

import UIKit

class HisCell: UITableViewCell{
    
    @IBOutlet weak var timeTF: UILabel!
    @IBOutlet weak var dateTF: UILabel!
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
