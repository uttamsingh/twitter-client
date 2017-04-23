//
//  AccountViewCell.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/23/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class AccountViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var handlerLabel: UILabel!
    
    var currentUser: User! {
        didSet{
            self.profileImageView?.setImageWith((currentUser?.profileUrl!)!)
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView?.layer.cornerRadius = 5
            self.profileImageView?.clipsToBounds = true
            
            self.profileName.text = currentUser.name!
            self.handlerLabel.text = "@" + currentUser.screenname!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
