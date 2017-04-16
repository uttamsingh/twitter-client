//
//  userTweetCell.swift
//  twitterClient
//
//  Created by Tunscopi on 3/4/17.
//  Copyright © 2017 Ayo Odejayi. All rights reserved.
//

import UIKit

class userTweetCell: UITableViewCell {

  @IBOutlet weak var userTweetTextLabel: UILabel!
  
  
  
  // Observer to update whenever Tweet changes
  var tweet: Tweet! {
    didSet{
        userTweetTextLabel.text = tweet.text!
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
