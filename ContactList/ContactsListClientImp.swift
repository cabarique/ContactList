//
//  ContactsListClientImp.swift
//  Contacts List
//
//  Created by luis cabarique on 1/26/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa
import ObjectMapper

public class ContactsListClientImp: NSObject, ContactsListClient {
    static let sharedInstance = ContactsListClientImp()
    
    public func getContacts() -> RACSignal{
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            
            ContactsListAPI.request(.getContacts).filterSuccessfulStatusCodes().mapJSON().subscribeNext({ (response) -> Void in
                let responseArray = response as! [AnyObject]
                var contacts = [ContactModel]()
                for var i = 0; i < responseArray.count; ++i{
                    let mapResponse = Mapper<ContactMapper>().map(responseArray[i])
                    contacts.append(mapResponse!.contact)
                }
                
                
                subscriber.sendNext(contacts)
                subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    subscriber.sendError(error)
                    subscriber.sendCompleted()
            })
            return nil
        }
        
        return signal
        
    }
}
