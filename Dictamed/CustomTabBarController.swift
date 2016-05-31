//
//  CustomTabBarController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBar.translucent = false
        self.tabBar.tintColor = UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)
        self.tabBar.backgroundImage = UIImage(named: "bg_tabs")
        self.tabBar.shadowImage = UIImage()
        
        self.tabBar.items?.forEach {
            $0.setTitleTextAttributes(
                [NSForegroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.35)],
                forState: UIControlState.Normal)
            $0.setTitleTextAttributes(
                [NSForegroundColorAttributeName: UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)],
                forState: UIControlState.Selected)
        }
        
        self.tabBar.items?[2].setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.whiteColor()],
            forState: UIControlState.Selected)
    }
    
    func setTranslucidBackground() {
        self.tabBar.backgroundImage = UIImage(named: "bg_tabs")
        tabBar.translucent = false
    }
    
    func setTransparentBackground() {
        self.tabBar.backgroundImage = UIImage()
        tabBar.translucent = true
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if tabBar.items?.indexOf(item) == 2 {
            setTransparentBackground()
        } else {
            setTranslucidBackground()
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            if self.selectedIndex == 2 {
                setTransparentBackground()
            } else {
                setTranslucidBackground()
            }
        }
    }
    
}
