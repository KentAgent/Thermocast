//
//  CustomTableViewCell.swift
//  Thermocast
//
//  Created by Georgios on 2018-03-12.
//  Copyright © 2018 Georgios. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var weatherAsset: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    var wind : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
