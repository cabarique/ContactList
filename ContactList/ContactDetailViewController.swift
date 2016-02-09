//
//  AppDetailViewController.swift
//  Contacts List
//
//  Created by luis cabarique on 1/30/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import UIKit
import Material

class ContactDetailViewController: UIViewController {
    
    var contact: ContactModel?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var headerView: UIStackView!
    
    var constraintView: [String: AnyObject] = [:]
    var verticalContraint: String = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "DetailView", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.width / 2
        imageBackgroundView.clipsToBounds = true
        imageBackgroundView.layer.borderWidth = 1
        imageBackgroundView.layer.borderColor = MaterialColor.grey.lighten1.CGColor
        appImage.image = UIImage(named: "no-icon")
        headerView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigator.navigationBarHidden = false
        
        constraintView["headerView"] = headerView
        verticalContraint = "V:[headerView]"
        
        if let data = contact!.encodedImage{
            appImage.image = UIImage(data: data)
        }
        name.text = contact!.name
        position.text = contact!.position
        addAge(withAge: contact!.age!)
        addPhone(withPhone: contact!.phone)
        addEmails(withEmail: contact!.emails)
        if let homePage = contact?.homePage {
            addHomePage(withHomePage: homePage)
        }
        addContraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigator.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPhone(withPhone phones: [PhoneModel]){
        var i = 1
        addSeparator(withID: "phoneSeparator")
        for phone in phones{
            let textField: TextField = TextField(frame: CGRectMake(57, 250, 300, 24))
            textField.font = RobotoFont.regularWithSize(20)
            textField.textColor = MaterialColor.black
            textField.text = phone.number!
            textField.enabled = false
            
            textField.titleLabel = UILabel()
            textField.titleLabel?.text = phone.type!
            textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
            textField.titleLabelColor = MaterialColor.blue.accent3
            textField.bottomBorderLayer.backgroundColor = UIColor.clearColor().CGColor
            
            // Add textField to UIViewController.
            textField.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(textField)
            
            constraintView["phone\(i)"] = textField
            verticalContraint += "-40-[phone\(i)]"
            
            i++
        }
    }
    
    func addAge(withAge age: Int){
        let textField: TextField = TextField(frame: CGRectMake(57, 250, 300, 24))
        textField.font = RobotoFont.regularWithSize(20)
        textField.textColor = MaterialColor.black
        textField.text = String(age)
        textField.enabled = false
        
        textField.titleLabel = UILabel()
        textField.titleLabel?.text = "Age"
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = MaterialColor.blue.accent3
        textField.bottomBorderLayer.backgroundColor = UIColor.clearColor().CGColor
        
        // Add textField to UIViewController.
        textField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textField)
        
        constraintView["age"] = textField
        verticalContraint += "-20-[age]"

    }
    
    func addEmails(withEmail emails: [EmailModel]){
        var i = 1
        addSeparator(withID: "emailSeparator")
        
        for email in emails{
            let textField: TextField = TextField(frame: CGRectMake(57, 250, 300, 24))
            textField.font = RobotoFont.regularWithSize(20)
            textField.textColor = MaterialColor.black
            textField.text = email.email
            textField.enabled = false
            
            textField.titleLabel = UILabel()
            textField.titleLabel?.text = email.label
            textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
            textField.titleLabelColor = MaterialColor.blue.accent3
            textField.bottomBorderLayer.backgroundColor = UIColor.clearColor().CGColor
            
            // Add textField to UIViewController.
            textField.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(textField)
            
            constraintView["email\(i)"] = textField
            verticalContraint += "-40-[email\(i)]"
            
            i++
        }
    }
    
    func addHomePage(withHomePage homePage: String){
        addSeparator(withID: "homePageSeparator")
        let textField: TextField = TextField(frame: CGRectMake(57, 250, 300, 24))
        textField.font = RobotoFont.regularWithSize(20)
        textField.textColor = MaterialColor.black
        textField.text = homePage
        textField.enabled = false
        
        textField.titleLabel = UILabel()
        textField.titleLabel?.text = "Home page"
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = MaterialColor.blue.accent3
        textField.bottomBorderLayer.backgroundColor = UIColor.clearColor().CGColor
        
        // Add textField to UIViewController.
        textField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textField)
        
        constraintView["homePage"] = textField
        verticalContraint += "-40-[homePage]"
    }
    
    func addSeparator(withID id: String, withSpacing spacing: Int = 10){
        let separator = UIView(frame: CGRectMake(10, 10, view.frame.size.width, 1))
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = MaterialColor.grey.lighten1
        scrollView.addSubview(separator)
        MaterialLayout.alignFromRight(scrollView, child: separator, right: 0)
        
        let height = NSLayoutConstraint.constraintsWithVisualFormat("V:[separator(\(1))]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["separator": separator])
        separator.addConstraints(height)
        
        
        constraintView[id] = separator
        verticalContraint += "-\(spacing)-[\(id)]"
    }
    
    func addContraints(){
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(verticalContraint, options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: constraintView)
        scrollView.addConstraints(verticalConstraint)
    }
    
}
