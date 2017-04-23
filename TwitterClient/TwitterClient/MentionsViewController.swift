//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , SideBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var sideBar: SideBar = SideBar()
    var tweets: [Tweet]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // initialize refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // Add refreshControl to tableView
        tableView.insertSubview(refreshControl, at: 0)

        
        
        // fetch tweets
        TwitterClient.sharedInstance?.mentionsTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        sideBar = SideBar(sourceView: self.view, menuItems: Constants.menuItems)
        sideBar.delegate = self
        self.view.backgroundColor = UIColor.white
    }
    
    func refreshControlAction (refreshControl: UIRefreshControl) {
        
        // Re-request hometimeline data
        TwitterClient.sharedInstance?.mentionsTimeLine(success: { (moreTweets: [Tweet]) in
            for newTweet in moreTweets {
                self.tweets.insert(newTweet, at: 0)
                self.tweets.remove(at: (self.tweets.count - 1))
                self.tableView.reloadData()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            
        })
        self.tableView.reloadData()
        
        // Tell refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tweetCellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    // Disable grey selection effect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        NavigationUtils.navigate(index: index, viewController: self)
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
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
        self.performSegue(withIdentifier: Constants.tweetsToLoginVCSegue, sender: nil)
    }
}
