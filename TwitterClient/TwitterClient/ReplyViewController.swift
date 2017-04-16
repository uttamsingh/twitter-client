//
//  ReplyViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var countDownText: UITextField!
    
    let maxTweetCount = Constants.maxTweetCount
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // resign first responder if pressed done from keyboard
        if text == "\n" {
            replyTextView.resignFirstResponder()
        }
        
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        self.countDownText.text = String(maxTweetCount - numberOfChars)
        return numberOfChars < maxTweetCount;

    }
    
    @IBAction func onClearTextButtonTap(_ sender: Any) {
        replyTextView.text = Constants.emptyString
        countDownText.text = String(maxTweetCount)
    }
    
    @IBAction func onSendReplyTap(_ sender: Any) {
        if replyTextView.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != "" {
            TwitterClient.sharedInstance?.POST(tweetText: replyTextView.text, success: {
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
    
}
