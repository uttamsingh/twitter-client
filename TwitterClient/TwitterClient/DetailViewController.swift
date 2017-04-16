//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profpicView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favCountStrLabel: UILabel!
    @IBOutlet weak var rtCountStrLabel: UILabel!
    @IBOutlet weak var rtLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = tweet.user?.name!
        handleLabel.text = "@" + (tweet.user?.screenname)!
        tweetTextLabel.text = tweet.text!
        profpicView.setImageWith((tweet.user?.profileUrl)!)
        timestampLabel.text = tweet.detailTimeStamp?.description
        
        if (tweet.rtCountStr == "") {
            rtCountStrLabel.isHidden = true
            rtLabel.isHidden = true
        } else {
            rtCountStrLabel.isHidden = false
            rtCountStrLabel.text = tweet.rtCountStr
        }
        
        if (tweet.favCountStr == "") {
            favCountStrLabel.isHidden = true
            favLabel.isHidden = true
        } else {
            favCountStrLabel.isHidden = false
            favCountStrLabel.text = tweet.favCountStr
        }
        
        // rounded corner pics
        profpicView.layer.cornerRadius = 5
        profpicView.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! ReplyViewController
        detailVC.tweet = tweet
    }
    
    @IBAction func onReplyTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.replySegue, sender: sender)
    }
    
}
