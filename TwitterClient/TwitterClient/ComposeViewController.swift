//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handlerLabel: UILabel!
    @IBOutlet weak var countDownText: UITextField!
    
    let maxTweetCount = Constants.maxTweetCount
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // rounded corner pics
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        tweetText.delegate = self
        
        // assign by default value to countDowntext
        countDownText.text = String(maxTweetCount)
        
        
        // set the editable property to false for countdown text
        countDownText.isUserInteractionEnabled = false
        
        // retrieve user info
        if let decodeData = UserDefaults.standard.data(forKey: Constants.currentUserKey), let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
            self.userNameLabel.text = currUser.name!
            self.handlerLabel.text = "@" + currUser.screenname!
            
            self.profileImage.setImageWith(currUser.profileUrl!)
        }
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // resign first responder if pressed done from keyboard
        if text == "\n" {
            tweetText.resignFirstResponder()
        }
        
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        self.countDownText.text = String(maxTweetCount - numberOfChars)
        return numberOfChars < maxTweetCount;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        if tweetText.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != "" {
            TwitterClient.sharedInstance?.POST(tweetText: tweetText.text, success: {
                print("Tweet posted to timeline!")
                self.dismiss(animated: true, completion: nil)
                
            }) { (error) in
                print (error)
                print ("unable to post tweet!")
            }
        } else {
            print("Nothing to tweet")
        }
    }
    
    
    @IBAction func onCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTextClearTap(_ sender: Any) {
        self.tweetText.text = Constants.emptyString
        self.countDownText.text = String(maxTweetCount)
    }
    
}
