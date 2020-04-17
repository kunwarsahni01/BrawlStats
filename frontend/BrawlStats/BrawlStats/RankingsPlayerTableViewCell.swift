//
//  RankingsPlayerTableViewCell.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/16/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class RankingsPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
