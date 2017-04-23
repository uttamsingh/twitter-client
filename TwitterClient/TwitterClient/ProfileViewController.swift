//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , SideBarDelegate, UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handlerLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!

    private let kTableHeaderHight: CGFloat! =  300.0
    
    var screenName:String!
    var isCurrentUserProfile: Bool = true
    var profileUser: User!
    var sideBar: SideBar = SideBar()
    var tweets: [Tweet]!
//    var headerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup the slide bar
        sideBar = SideBar(sourceView: self.view, menuItems: Constants.menuItems)
        sideBar.delegate = self
        self.view.backgroundColor = UIColor.white
        
        addRefreshControl()
        populateUserProfileData()
        
    }

    
    func tableViewHeaderEdgeInsetConfig() {
        //        self.headerView = tableView.tableHeaderView
        //        self.tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHight, 0, 0, 0)
        //        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHight)
        //        updateHeaderView()
    }
    
    func addRefreshControl() {
        // initialize refreshControl
        //        let refreshControl = UIRefreshControl()
        //        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        //
        //        // Add refreshControl to tableView
        //        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func populateUserProfileData() {
        
        if isCurrentUserProfile {
            // retrieve user info
            if let decodeData = UserDefaults.standard.data(forKey: Constants.currentUserKey),
                let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
                populateDataFromUser(currUser: currUser)
            }
        } else {
            populateDataFromUser(currUser: profileUser)
        }
    }
    
    func populateDataFromUser(currUser: User) {
        self.userNameLabel.text = currUser.name!
        self.screenName = currUser.name!
        self.handlerLabel.text = "@" + currUser.screenname!
        
        self.profileImage.setImageWith(currUser.profileUrl!)
        self.tweetLabel.text = String(currUser.tweetCount!)
        self.followingLabel.text = String(currUser.following_count!)
        self.followersLabel.text = String(currUser.followers_count!)
        self.headerImage?.setImageWith(currUser.headerURL!)
        self.profileImage?.layer.cornerRadius = 5
        self.profileImage?.clipsToBounds = true
        
        // fetch tweets
        TwitterClient.sharedInstance?.userTimeline(currUser.screenname!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

//    func updateHeaderView() {
//        var headreRect = CGRect(x: 0, y: -kTableHeaderHight, width: self.tableView.bounds.width, height: kTableHeaderHight)
//        if self.tableView.contentOffset.y < -kTableHeaderHight {
//            headreRect.origin.y = self.tableView.contentOffset.y
//            headreRect.size.height = -self.tableView.contentOffset.y
//        }
//        headerView.frame = headreRect
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        updateHeaderView()
//    }
    
    func refreshControlAction (refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.userTimeline(self.screenName , success: { (tweets: [Tweet]) in
            for newTweet in tweets {
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
