//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , SideBarDelegate{

    var sideBar: SideBar = SideBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideBar = SideBar(sourceView: self.view, menuItems: Constants.menuItems)
        sideBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func sideBarDidSelectButtonAtIndex(index: Int) {
        NavigationUtils.navigate(index: index, viewController: self)
    }

}
