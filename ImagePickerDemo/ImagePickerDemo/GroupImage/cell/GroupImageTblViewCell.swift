//
//  GroupImageTblViewCell.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import UIKit

class GroupImageTblViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
