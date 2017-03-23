//
//  ListTableViewCell.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photoUI: UIImageView!
    @IBOutlet weak var titleUI: UILabel!
     @IBOutlet weak var descriptionUI: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        photoUI.image = nil
        titleUI.text = nil
        descriptionUI.text = nil
    }

    
}
