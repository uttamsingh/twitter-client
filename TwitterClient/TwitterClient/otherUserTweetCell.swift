//
//  otherUserTweetCell.swift
//  twitterClient
//
//  Created by Tunscopi on 3/6/17.
//  Copyright © 2017 Ayo Odejayi. All rights reserved.
//

import UIKit

class otherUserTweetCell: UITableViewCell {
  
  @IBOutlet weak var otherUserTweetTextLabel: UILabel!
  
  
  // Observer to update whenever Tweet changes
  var tweet: Tweet! {
    didSet {
      otherUserTweetTextLabel.text = tweet.text!
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
