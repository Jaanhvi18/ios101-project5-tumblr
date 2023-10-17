//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Jaanhvi Agarwal on 10/17/23.
//

import UIKit

class PostCell: UITableViewCell {


    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var postSummary: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
