//
//  CategoriesViewController.swift
//  Contacts List
//
//  Created by luis cabarique on 1/26/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import UIKit
import Material

class SideViewController: UIViewController {
    
    @IBOutlet weak var logout: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "SideView", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.layer.masksToBounds = true
    }
    
    @IBAction func logout(sender: AnyObject) {
        navigator.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
