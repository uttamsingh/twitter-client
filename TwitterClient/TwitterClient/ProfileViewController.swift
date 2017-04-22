//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , SideBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handlerLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!

    var sideBar: SideBar = SideBar()
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
        
        sideBar = SideBar(sourceView: self.view, menuItems: Constants.menuItems)
        sideBar.delegate = self
        self.view.backgroundColor = UIColor.white
        
        // retrieve user info
        if let decodeData = UserDefaults.standard.data(forKey: Constants.currentUserKey), let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
            self.userNameLabel.text = currUser.name!
            self.handlerLabel.text = "@" + currUser.screenname!
            
            self.profileImage.setImageWith(currUser.profileUrl!)
            self.tweetLabel.text = String(currUser.tweetCount!)
            self.followingLabel.text = String(currUser.following_count!)
            self.followersLabel.text = String(currUser.followers_count!)
        }
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
