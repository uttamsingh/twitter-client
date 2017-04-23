//
//  AccountViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController , SideBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var accounts: Array <User> = []
    var sideBar: SideBar = SideBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setting up side bar
        sideBar = SideBar(sourceView: self.view, menuItems: Constants.menuItems)
        sideBar.delegate = self
        self.view.backgroundColor = UIColor.white
        
        // Setup users account
        accountSetup()
    }
    
    func accountSetup() {
        // retrieve user info
        if let decodeData = UserDefaults.standard.data(forKey: Constants.currentUserKey),
            let currUser = NSKeyedUnarchiver.unarchiveObject(with: decodeData) as? User {
            accounts.append(currUser)
        }
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        NavigationUtils.navigate(index: index, viewController: self)
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
        self.performSegue(withIdentifier: Constants.tweetsToLoginVCSegue, sender: nil)
    }
}

extension AccountViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.accountCellIdentifier, for: indexPath) as! AccountViewCell
        cell.currentUser = accounts[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
