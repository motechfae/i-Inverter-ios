//
//  inv_TableViewCell.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/23.
//

import UIKit

class inv_TableViewCell: UITableViewCell {

    @IBOutlet weak var inv_check: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
