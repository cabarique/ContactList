//
//  ViewController.swift
//  AppStore
//
//  Created by luis cabarique on 1/26/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import UIKit
import Material
import FontAwesome_swift
import ReachabilitySwift

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let limit = 20
    
    var detailView : ContactDetailViewController!
    
    @IBOutlet weak var appsTAble: UITableView!
    
    var api: ContactsListClient!
    
    var contacts: [ContactModel] = []{
        didSet{
            appsTAble.reloadData()
        }
    }
    
    var appDAO: AppsDAO?
    
    var reachability: Reachability?
    
    var noNetWorkView: UILabel!
    
    var selectedCategory:Int?
    
    var navigationBarView: NavigationBarView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "StoreView", bundle: NSBundle.mainBundle())
        api = ContactsListClientImp.sharedInstance
        detailView = ContactDetailViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "filterAppsByCategory:", name: "filterAppsByCategory", object: nil)
        
        appsTAble.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        noNetWorkView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        noNetWorkView.translatesAutoresizingMaskIntoConstraints = false
        noNetWorkView.text = "No internet Conection"
        noNetWorkView.textAlignment = .Center
        noNetWorkView.textColor = UIColor.whiteColor()
        noNetWorkView.backgroundColor = MaterialColor.grey.darken1
        noNetWorkView.hidden = true
        
        navigationBarView = NavigationBarView()
        navigationBarView!.backgroundColor = MaterialColor.blue.darken3

        /*
        To lighten the status bar - add the
        "View controller-based status bar appearance = NO"
        to your info.plist file and set the following property.
        */
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Contacts"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView!.titleLabel = titleLabel
        navigationBarView!.titleLabelInset.left = 64
        
        // Menu button.
        //let img1: UIImage? = UIImage(named: "ic_menu_white")
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.white
        btn1.pulseFill = true
        btn1.pulseScale = false
        btn1.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        btn1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn1.setTitle(String.fontAwesomeIconWithName(.Bars), forState: .Normal)
        btn1.addTarget(self, action: "toggleCategories", forControlEvents: .TouchUpInside)

        // Add buttons to left side.
        navigationBarView!.leftButtons = [btn1]
        
        
        // To support orientation changes, use MaterialLayout.
        view.addSubview(navigationBarView!)
        view.insertSubview(noNetWorkView, belowSubview: navigationBarView!)
        
        navigationBarView!.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView!)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView!)
        MaterialLayout.height(view, child: navigationBarView!, height: 70)
        
        MaterialLayout.alignFromTop(view, child: noNetWorkView, top: 70)
        MaterialLayout.alignFromRight(view, child: noNetWorkView)
        MaterialLayout.alignFromLeft(view, child: noNetWorkView)
        
        //MaterialLayout.alignToParent(view, child: appsTAble, top: 70)
        
        let alignTableConstraint = NSLayoutConstraint(item: appsTAble, attribute: .Top, relatedBy: .Equal, toItem: navigationBarView, attribute: .Bottom, multiplier: 1, constant: 0)
        alignTableConstraint.priority = 750
        view.addConstraint(alignTableConstraint)
        
        let alignTableToNoNetWorktConstraint = NSLayoutConstraint(item: appsTAble, attribute: .Top, relatedBy: .Equal, toItem: noNetWorkView, attribute: .Bottom, multiplier: 1, constant: 10)
        alignTableToNoNetWorktConstraint.priority = 500
        view.addConstraint(alignTableToNoNetWorktConstraint)
        
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification,
                object: reachability)
            try! reachability!.startNotifier()
        } catch {
            print("Unable to create Reachability")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigator.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContacts(){
        api.getContacts().subscribeNext({ (response) -> Void in
            self.contacts = response as! [ContactModel]
            }, error: { (error) -> Void in
                
            }) { () -> Void in
                
        }
    }
    
    
    // MARK: Tableview Magement
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell =  appsTAble.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = contact.name
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(named: "no-icon")
        cell.imageView?.layer.cornerRadius = cell.imageView!.frame.size.width / 2
        cell.imageView?.layer.borderColor = MaterialColor.grey.lighten1.CGColor
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.clipsToBounds = true
        
        if let data = contact.encodedImage{
            cell.imageView?.image = UIImage(data: data)
        }else{
            if contact.image != ""{
                let url = contact.image
                getDataFromUrl(url!) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        contact.encodedImage = data!
                        if let cellToUpdate = self.appsTAble?.cellForRowAtIndexPath(indexPath){
                            cellToUpdate.imageView?.image = UIImage(data: data!)
                            cellToUpdate.imageView?.layer.cornerRadius = cellToUpdate.imageView!.frame.size.width / 2
                            cellToUpdate.setNeedsDisplay()
                            self.appsTAble.reloadData()
                        }
                        
                    }
                }
            }
        }
        
        
        return cell
    }
    
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        detailView.contact = contacts[indexPath.row]
        navigator.pushViewController(detailView, animated: true)
        //detailView.showInView(self.view, withApp: contacts[indexPath.row], animated: true)
    }
    

    func toggleCategories(){
        NSNotificationCenter.defaultCenter().postNotificationName("updateCategories", object: nil)
        sideNavigationViewController?.toggle()
    }
    
    func filterAppsByCategory(notification: NSNotification){
        let userInfo = notification.userInfo as! [String:AnyObject]
        if let category = userInfo["category"] {
            selectedCategory = category as? Int
            navigationBarView?.detailLabel?.text = categories[selectedCategory!]
            self.appsTAble.reloadData()
        }else{
            selectedCategory = nil
            navigationBarView?.detailLabel?.text = "All Categories"
        }
        sideNavigationViewController?.close()
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            noNetWorkView.hidden = true
        } else {
            print("UnReachable")
            noNetWorkView.hidden = false
        }
        
        getContacts()
    }
}

