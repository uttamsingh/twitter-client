//
//  SideBar.swift
//  
//
//  Created by Singh, Uttam on 4/19/17.
//
//

import UIKit

@objc protocol SideBarDelegate {
    func sideBarDidSelectButtonAtIndex(index:Int)
    @objc optional func sideBarWillClose()
    @objc optional func sideBarWillOpen()
}


class SideBar: NSObject, SideBarTableViewControllerDelegate {
    let barWidth:CGFloat = 150.0
    var sideBarTableViewTopInsert:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideBarTableViewController:SideBarTableViewController = SideBarTableViewController ()
    var originView:UIView!
    
    var animator:UIDynamicAnimator!
    var delegate:SideBarDelegate?
    var isSideBarOpen:Bool = false
    
    override init() {
        super.init()
    }

    init(sourceView:UIView, menuItems: Array<String>) {
        super.init()
        originView = sourceView
        originView.backgroundColor = UIColor.clear
        sideBarTableViewController.tableData = menuItems
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let gestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SideBar.handleSwipe(_:)))
        originView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupSideBar() {
        sideBarContainerView.frame = CGRect(x: -(barWidth + 1.0), y: (originView?.frame.origin.y)!, width: barWidth, height: (originView?.frame.size.height)!)
        sideBarContainerView.backgroundColor = UIColor.clear
        sideBarContainerView.clipsToBounds = false
        
        originView?.addSubview(sideBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
        blurView.frame = sideBarContainerView.bounds
        blurView.backgroundColor = UIColor.white
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        sideBarTableViewController.tableView.backgroundColor = UIColor.clear
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInsert, 0, 0, 0)

        sideBarTableViewController.tableView.reloadData()
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }

    func handleSwipe(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            if sender.velocity(in: self.originView).x < 0 {
                showSideBar(shouldOpen: false)
                delegate?.sideBarWillClose?()
            } else {
                showSideBar(shouldOpen: true)
                delegate?.sideBarWillOpen?()
            }
        default :
            break
        }
    }
    
    func showSideBar(shouldOpen: Bool) {
        if animator == nil {
            animator = UIDynamicAnimator(referenceView: originView)
        }
        animator?.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude: CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehaviour: UIGravityBehavior  = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehaviour.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator?.addBehavior(gravityBehaviour)
        
        let collisionBehaviour: UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehaviour.addBoundary(withIdentifier: Constants.sideBarBoundary  as NSCopying, from: CGPoint.init(x: boundaryX, y: 20), to: CGPoint.init(x: boundaryX, y: (originView?.frame.size.height)!))
        animator?.addBehavior(collisionBehaviour)
        
        let pushBehaiour: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehaiour.magnitude = magnitude
        animator?.addBehavior(pushBehaiour)
        
        let sideBarBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehaviour.elasticity = 0.3
        animator?.addBehavior(sideBarBehaviour)
    }
    
    func sideBarControlDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideBarDidSelectButtonAtIndex(index: indexPath.row)
    }
}
