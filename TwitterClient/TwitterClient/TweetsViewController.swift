//
//  TableViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // initialize tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    // fetch tweets
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
    
    // initialize refreshControl
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
    
    // Add refreshControl to tableView
    tableView.insertSubview(refreshControl, at: 0)
  }
  
  
  @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
    TwitterClient.sharedInstance?.logout()
    self.performSegue(withIdentifier: Constants.tweetsToLoginVCSegue, sender: nil)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.tweetsToDetailSegue {
      let cell = sender! as! UITableViewCell
      let indexPath = tableView.indexPath(for: cell)
      let tweet = self.tweets[indexPath!.row]
      
      let detailVC = segue.destination as! DetailViewController
      detailVC.tweet = tweet
      
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tweetCellIdentifier, for: indexPath) as! TweetCell
    cell.tweet = tweets[indexPath.row]
    
    return cell
  }
  
  
  func refreshControlAction (refreshControl: UIRefreshControl) {
    
    // Re-request hometimeline data
    TwitterClient.sharedInstance?.homeTimeline(success: { (moreTweets: [Tweet]) in
      for newTweet in moreTweets {
        self.tweets.insert(newTweet, at: 0)
        self.tableView.reloadData()
      }
    }, failure: { (error: Error) in
      print(error.localizedDescription)
      
    })
    self.tableView.reloadData()
    
    // Tell refreshControl to stop spinning
    refreshControl.endRefreshing()
  }
  
  
  // Disable grey selection effect
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
    @IBAction func onNewButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.newTweetsSegue, sender: nil)
    }
    
}


