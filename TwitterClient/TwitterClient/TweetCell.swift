//
//  TableViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//
import UIKit

class tweetCell: UITableViewCell {
  
  @IBOutlet weak var profPicView: UIImageView!
  @IBOutlet weak var profPicButton: UIButton!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestamp: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var rtButton: UIButton!
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var rtCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  
  
  // Observer to update whenever Tweet changes
  var tweet: Tweet! {
    didSet{
      tweetTextLabel.text = tweet.text!
      timestamp.text = "\(tweet.timeAgo!)"
      usernameLabel.text = tweet.user?.name!
      handleLabel.text = "@\((tweet.user?.screenname)!)"
      profPicView.setImageWith((tweet.user?.profileUrl)!)
      //profPicButton.setImageFor(.normal, with: (tweet.user?.profileUrl)!)
      
      rtCountLabel.text = tweet.rtCountStr
      favCountLabel.text = tweet.favCountStr
      
      if (!self.tweet.retweeted!) {
       rtButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
      } else {
       rtButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
      }
      if (!self.tweet.faved!) {
        favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
      } else {
        favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
      }
    }
  }
  
  
  @IBAction func onRtButton(_ sender: UIButton) {
    tweet.retweeted! = !tweet.retweeted!
    
    if (self.tweet.retweeted!) {
      self.tweet.rtCount += 1
      rtButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
    } else {
      self.tweet.rtCount -= 1
      rtButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
    }
    
    // update rtcount display
    self.tweet.rtCountStr = (self.tweet.rtCount > 0) ? "\(self.tweet.rtCount)" : ""
    rtCountLabel.text = self.tweet.rtCountStr
    
    // post to twitter
    
  }
  
  
  @IBAction func onFavButton(_ sender: UIButton) {
    self.tweet.faved = !self.tweet.faved!
    
    if (self.tweet.faved!) {
      self.tweet.favCount += 1
      favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
    } else {
      self.tweet.favCount -= 1
      favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
    }
    
    // update favCount
    self.tweet.favCountStr = (self.tweet.favCount > 0) ? "\(self.tweet.favCount)" : ""
    favCountLabel.text = self.tweet.favCountStr
    
    // post to twitter
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profPicView.layer.cornerRadius = 5
    profPicView.clipsToBounds = true
  }

  
}






