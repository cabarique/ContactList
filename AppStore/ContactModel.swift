//
//  ContactModel.swift
//  ContactsList
//
//  Created by luis cabarique on 2/8/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import Foundation

class ContactModel: NSObject {
    var image: String?
    var encodedImage: NSData?
    var homePage:String?
    var emails: [EmailModel] = []
    var name: String?
    var position: String?
    var age: Int?
    var phone: [PhoneModel] = []
    var address: [AddressModel] = []
}