//
//  ProfileViewController.swift
//  twitterClient
//
//  Created by Tunscopi on 3/3/17.
//  Copyright © 2017 Ayo Odejayi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var followerCount: UILabel!
  @IBOutlet weak var followingCount: UILabel!
  @IBOutlet weak var headerPic: UIImageView!
  @IBOutlet weak var tweetCountLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]!
  var screenname: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    // retrieve user
    if let decodeData = UserDefaults.standard.data(forKey: "user"), let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
      self.screenname = currUser.screenname!
      self.userNameLabel.text = currUser.name!
      self.followerCount.text = "\(currUser.followers_count!)"
      self.followingCount.text = "\(currUser.following_count!)"
      self.handleLabel.text = "@" + currUser.screenname!

      self.profilePic.setImageWith(currUser.profileUrl!)
      if (currUser.headerURL != nil) {
        self.headerPic.setImageWith(currUser.headerURL!)

      } else {
        print ("no header available")
      }
      self.tweetCountLabel.text = "\(currUser.tweetCount!)"
    }
    
    // Get userTimeline
    TwitterClient.sharedInstance?.userTimeline(self.screenname!, success: {(tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
    
    
    // blur header
    addBlurArea(area: headerPic.bounds)
    
    // rounded corner pics
    profilePic.layer.cornerRadius = 5
    profilePic.clipsToBounds = true
    
  }
  
  
  func addBlurArea(area: CGRect) {
    let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurView = UIVisualEffectView(effect: effect)
    blurView.frame = CGRect(x: 0, y: 0, width: area.width+40, height: area.height+65)
    
    let container = UIView(frame: area)
    container.alpha = 0.8
    container.addSubview(blurView)
    
    self.view.insertSubview(container, at: 1)
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "userTweetCell", for: indexPath) as! userTweetCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
}



