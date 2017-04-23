//
//  TableViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//
import UIKit

class TweetCell: UITableViewCell {
  
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
  
    @IBOutlet weak var rtImage: UIImageView!
    @IBOutlet weak var rtTextLabel: UILabel!
    @IBOutlet weak var rtHolderView: UIView!
    
  // Observer to update whenever Tweet changes
  var tweet: Tweet! {
    didSet{
      tweetTextLabel.text = tweet.text!
      timestamp.text = "\(tweet.timeAgo!)"
      usernameLabel.text = tweet.user?.name!
      handleLabel.text = "@\((tweet.user?.screenname)!)"
      profPicView.setImageWith((tweet.user?.profileUrl)!)
      rtCountLabel.text = tweet.rtCountStr
      favCountLabel.text = tweet.favCountStr
      profPicView.isUserInteractionEnabled = true
      
        if tweet.rtCount > 0 {
            rtHolderView.isHidden = false
        } else {
            rtHolderView.isHidden = true
        }
        
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
    if (self.tweet.retweeted!) {
        TwitterClient.sharedInstance?.retweet(tweet: tweet, success: { (retweet) in
            print("retweeted successfully")
        }, failure: { (error) in
           print("Error: \(error.localizedDescription)")
        })
    } else {
        TwitterClient.sharedInstance?.unretweet(tweet: tweet, success: { (retweet) in
            print("unretweeted successfully")
        }, failure: { (error) in
            print("Error: \(error.localizedDescription)")
        })
    }
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
   if (self.tweet.faved!) {
        TwitterClient.sharedInstance?.favorite(tweet: tweet, success: { (tweet) in
            print("favorite successfully")
        }, failure: { (error) in
            print("Error: \(error.localizedDescription)")
        })
   } else {
        TwitterClient.sharedInstance?.unfavorite(tweet: tweet, success: { (tweet) in
            print("unfavorite successfully")
        }, failure: { (error) in
            print("Error: \(error.localizedDescription)")
        })
    }
  }
  
    @IBAction func onReplyTap(_ sender: Any) {
     
    }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profPicView.layer.cornerRadius = 5
    profPicView.clipsToBounds = true
  }
}






