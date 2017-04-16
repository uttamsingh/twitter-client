//
//  TableViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/16/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
  
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "HdOAF1OAk8rioZ93zqrRiX43j", consumerSecret: "VD61h6G3Zbpfe9oFHi8Vez6ColgUgoG4ToWHnxvGAPsDvVtTM4")
    

  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance?.deauthorize()
    TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterClient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
      print("Request Token received")
      
      let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token!)!)")!
      self.open(_url: url)
      
    }) { (error:Error?) -> Void in
      print ("error: \(error!.localizedDescription)")
      self.loginFailure?(error!)
    }
  }
  
  
  func logout() {
    UserDefaults.standard.removeObject(forKey: Constants.currentUserKey)
    
     if UserDefaults.standard.data(forKey: Constants.currentUserKey) == nil {
        print ("Succesfully cleared user info")
     }
    deauthorize()
  }
  
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
      print("Access Token received!")
      
      self.currentAccount(success: { (user: User) in
        // Using computed property
         //User.currentUser = user
        
        // Saving to userDefaults
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodeData, forKey: Constants.currentUserKey)
        
        self.loginSuccess?()
      }, failure: { (error: Error) in
        self.loginFailure?(error)
      })
      self.loginSuccess?()
      
    }) {(error: Error?) -> Void in
      print("error: \(error!.localizedDescription)")
      self.loginFailure!(error!)
    }
  }

  
  func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(_: URLSessionDataTask, response:
      Any?) -> Void in
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      
      success(tweets)
      
      }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
      failure(error)
    })
    
  }
  
  
  func userTimeline(_ settings: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    let params = "?screen_name=" + settings
    
    get("1.1/statuses/user_timeline.json"+params, parameters: nil, progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      success(tweets)
      
    }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
      failure(error)
    })
  }
  
  
  
  func POST(tweetText: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    post("/1.1/statuses/update.json", parameters: ["status": tweetText], progress: nil, success: { (_: URLSessionDataTask, resp) -> Void in
        success()
    }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
        print(error.localizedDescription)
    })
  }
  
    func postReplyTweet (postText: NSString, inReplyToString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json", parameters: ["status": postText, "in_reply_to_status_id": inReplyToString], progress: nil, success: { (_: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    

  func retweet (tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("/1.1/statuses/retweet/" + tweet.id_str! + ".json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) -> Void in
      let dictionary = response as? NSDictionary
      let tweet = Tweet(dictionary: dictionary!)
      success(tweet)
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
    
    func unretweet (tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/unretweet/" + tweet.id_str! + ".json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
 
  
  func favorite (tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    post("1.1/favorites/create.json", parameters: ["id": tweet.id_str!], progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
      let dictionary = response as? NSDictionary
      let tweet = Tweet(dictionary: dictionary!)
      success(tweet)
    }, failure: { (_: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
    func unfavorite (tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweet.id_str!], progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
  
  
  func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(_: URLSessionDataTask, response: Any?) -> Void in
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)
      
      success(user)
      
    }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
      failure(error)
    })
  }
  
  
  // helper function: url open
  func open(_url: URL) {
    if #available(iOS 10, *) {
      UIApplication.shared.open(_url, options: [:], completionHandler: {(success) in
        print("Open url: \(success)")
      })
    }
    else {
      _ = UIApplication.shared.openURL(_url)
    }
  }
}


