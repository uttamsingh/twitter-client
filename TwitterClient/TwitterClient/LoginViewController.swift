//
//  TableViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  
  @IBAction func onLogin(_ sender: UIButton) {

    TwitterClient.sharedInstance?.login(success: {
      print ("You've Successfully logged in!")
      
      self.performSegue(withIdentifier: Constants.loginSegue, sender: nil)
      
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })

  }
  
  
}
