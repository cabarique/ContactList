//
//  ContactsVO.swift
//  ContactsList
//
//  Created by luis cabarique on 2/8/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactMapper: Mappable {
    
    var contact: ContactModel
    
    required init?(_ map: Map) {
        contact = ContactModel()
    }
    
    func mapping(map: Map) {
        contact.image <- map["imageUrl"]
        contact.name <- map["name"]
        contact.homePage <- map["homePage"]
        contact.position <- map["position"]
        contact.age <- map["age"]
        var emails: [AnyObject] = []; emails <- map["emails"]
        var i = 0
        for email in emails{
            let emailModel = EmailModel()
            emailModel.email <- map["emails.\(i).email"]
            emailModel.label <- map["emails.\(i).label"]
            contact.emails.append(emailModel)
            i++
        }
        var addresses: [AnyObject] = []; emails <- map["address"]
        i = 0
        for address in addresses{
            let addressModel = AddressModel()
            addressModel.address1 <- map["address.\(i).address1"]
            addressModel.address2 <- map["address.\(i).address2"]
            addressModel.address3 <- map["address.\(i).address3"]
            addressModel.zipCode <- map["address.\(i).zipcode"]
            addressModel.country <- map["address.\(i).country"]
            addressModel.city <- map["address.\(i).city"]
            addressModel.state <- map["address.\(i).state"]
            contact.address.append(addressModel)
            i++
        }
        var phones: [AnyObject] = []; phones <- map["phone"]
        i = 0
        for phone in phones{
            let phoneModel = PhoneModel()
            phoneModel.number <- map["phone.\(i).number"]
            phoneModel.type <- map["phone.\(i).type"]
            contact.phone.append(phoneModel)
            i++
        }
    }
    
}
