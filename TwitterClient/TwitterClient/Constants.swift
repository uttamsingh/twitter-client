//
//  Constants.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

struct Constants {
    
    static let loginSegue = "loginSegue"
    static let currentUserKey = "currentUser"
    
    
    // View Controllers
    static let tweetsNavigationController = "TweetsNavigationController"
    static let detailViewController = "DetailViewController"
    static let tweetsViewController = "TweetsViewController"
    static let profileViewController = "ProfileViewController"
    static let mentionseViewController = "MentionsViewController"
    static let accountViewController = "AccountViewController"
    
    // Storyboard
    static let mainStoryBoard = "Main"
 
    // Tableview Cell
    static let replySegueFromTableViewCell = "replySegueFromTableViewCell"
    static let tweetCellIdentifier = "TweetCell"
    static let accountCellIdentifier = "AccountCell"
 
    static let maxTweetCount = 140
    static let emptyString = ""
    static let sideBarBoundary = "sideBarBoundary"
    
    // Segue
    static let replySegue = "replySegue"
    static let tweetsToDetailSegue = "tweetsToDetailSegue"
    static let tweetsToLoginVCSegue = "TweetsToLoginVCSegue"
    static let newTweetsSegue = "NewTweetsSegue"
    static let profileViewSegue = "profileViewSegue"

    
    // Icon and navigation constants
    static let home:String = "TimeLine"
    static let profile:String = "Profile"
    static let mentions:String = "Mentions"
    static let account:String = "Account"

    static let homeIcon:String = "home-icon"
    static let profileIcon:String = "profile-icon"
    static let mentionsIcon:String = "mentions-icon"
    static let accountIcon:String = "account-icon"
    
    static let menuItems:Array<String> = [String](arrayLiteral: Constants.profile, Constants.home,  Constants.mentions, Constants.account)
}
