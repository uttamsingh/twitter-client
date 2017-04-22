//
//  NavigationUtils.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class NavigationUtils: NSObject {

    static func navigate(index:Int, viewController:UIViewController){
        var logo:UIImage?

        switch Constants.menuItems[index] {
        case Constants.home:
             logo = UIImage(named: Constants.homeIcon)
             guard let tweetVC = UIStoryboard(name:Constants.mainStoryBoard, bundle:nil).instantiateViewController(withIdentifier: Constants.tweetsViewController) as? TweetsViewController else {
                print("Could not instantiate view controller with identifier of type" + Constants.tweetsViewController)
                return
             }
             self.changeHeaderImage(logo: logo!, viewController: tweetVC)
             viewController.navigationController?.pushViewController(tweetVC, animated:true)
        case Constants.profile:
             logo = UIImage(named: Constants.profileIcon)
             guard let profileVC = UIStoryboard(name:Constants.mainStoryBoard, bundle:nil).instantiateViewController(withIdentifier: Constants.profileViewController) as? ProfileViewController else {
                print("Could not instantiate view controller with identifier of type" + Constants.profileViewController)
                return
             }
             self.changeHeaderImage(logo: logo!, viewController: profileVC)
             viewController.navigationController?.pushViewController(profileVC, animated:true)
        case Constants.mentions:
             logo = UIImage(named: Constants.mentionsIcon)
             guard let mentionsVC = UIStoryboard(name:Constants.mainStoryBoard, bundle:nil).instantiateViewController(withIdentifier: Constants.mentionseViewController) as? MentionsViewController else {
                print("Could not instantiate view controller with identifier of type" + Constants.mentionseViewController)
                return
             }
             self.changeHeaderImage(logo: logo!, viewController: mentionsVC)
             viewController.navigationController?.pushViewController(mentionsVC, animated:true)
        case Constants.account:
             logo = UIImage(named: Constants.accountIcon)
             guard let accountVC = UIStoryboard(name:Constants.mainStoryBoard, bundle:nil).instantiateViewController(withIdentifier: Constants.accountViewController) as? AccountViewController else {
                print("Could not instantiate view controller with identifier of type" + Constants.accountViewController)
                return
             }
             self.changeHeaderImage(logo: logo!, viewController: accountVC)
             viewController.navigationController?.pushViewController(accountVC, animated:true)
        default:
            break
        }
        
    }

    // set the navigation tittle view with image
    static func changeHeaderImage(logo:UIImage, viewController:UIViewController)  {
        
        let imageView = UIImageView(image:logo)
        imageView.backgroundColor = UIColor.clear
        viewController.navigationItem.titleView = imageView
    }
}
