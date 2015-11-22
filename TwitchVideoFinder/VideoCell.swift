//
//  VideoCell.swift
//  TwitchVideoFinder
//
//  Created by Sunshine Yang on 11/21/15.
//  Copyright © 2015 SunshineYang. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

	@IBOutlet var videoChannel: UILabel!
	@IBOutlet var videoViews: UILabel!
	@IBOutlet var videoDescription: UILabel!
	@IBOutlet var videoTitle: UILabel!
	@IBOutlet var thumbnailImage: UIImageView!
	@IBOutlet var previewImage: UIImageView!
	
	@IBOutlet var length: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
