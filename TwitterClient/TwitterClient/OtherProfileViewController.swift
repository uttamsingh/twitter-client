//
//  OtherProfileViewController.swift
//  twitterClient
//
//  Created by Tunscopi on 3/5/17.
//  Copyright © 2017 Ayo Odejayi. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var profPicView: UIImageView!
  @IBOutlet weak var headerView: UIImageView!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetCountLabel: UILabel!
  @IBOutlet weak var ffwrCountLabel: UILabel!
  @IBOutlet weak var ffingCountLabel: UILabel!
  @IBOutlet weak var followButton: UIButton!
  
  @IBOutlet weak var tableView: UITableView!
  
  
  var tweet: Tweet?
  var user: User?
  var tweets: [Tweet]!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    // get user
    self.user = tweet?.user
    
    // assign user details
    self.usernameLabel.text = self.user?.name
    self.handleLabel.text = "@" + (self.user?.screenname)!
    self.profPicView.setImageWith((self.user?.profileUrl)!)
    self.headerView.setImageWith((self.user?.headerURL)!)
    self.tweetCountLabel.text = "\((self.user?.tweetCount!)!)"
    self.ffwrCountLabel.text = "\((self.user?.followers_count!)!)"
    self.ffingCountLabel.text = "\((self.user?.following_count!)!)"
    
    // Get userTimeline
    TwitterClient.sharedInstance?.userTimeline(self.handleLabel.text!, success: {(tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
    
    
    // add blur to header
    addBlurArea(area: headerView.bounds)
    
    // follow Button appearance
    self.followButton.setTitle("Following", for: .normal)
    self.followButton.layer.cornerRadius = 5.0;
    self.followButton.layer.borderColor = UIColor.lightGray.cgColor
    self.followButton.layer.borderWidth = 0.5
    self.followButton.backgroundColor = UIColor.init(red: 0, green: 191/255, blue: 1, alpha: 1)
    self.followButton.setTitleColor(UIColor.white, for: .normal)
  }
  
  
  @IBAction func onFollowTap(_ sender: UIButton) {
    self.user?.following = !(self.user?.following)!
    
    let ffButton = sender
    
    if (self.user?.following)! {
      ffButton.setTitle("Following", for: .normal)
      ffButton.backgroundColor = UIColor.init(red: 0, green: 191/255, blue: 1, alpha: 1)
      ffButton.setTitleColor(UIColor.white, for: .normal)
      
    } else {
      ffButton.setTitle("Follow", for: .normal)
      self.followButton.setTitleColor(UIColor.init(red: 0, green: 191/255, blue: 1, alpha: 1), for: .normal)
      ffButton.backgroundColor = UIColor.white
    }
    
    // TODO: Actually ff on twitter
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "otherUserTweetCell") as! otherUserTweetCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  
  // Disable grey selection effect
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
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

}



