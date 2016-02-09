
//
//  ContactsListAPI.swift
//  Contacts List
//
//  Created by luis cabarique on 1/26/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import Foundation
import Moya
import Alamofire

import ReactiveCocoa

// MARK: - Provider setup
let ContactsListAPI = ReactiveCocoaMoyaProvider<ContactsListPoints>() //Should be CustomReactiveCocoaMoyaProvider

// MARK: - Provider support

public enum ContactsListPoints {
    case getContacts
}


extension ContactsListPoints : TargetType {
    public var baseURL: NSURL { return NSURL(string: "http://beta.json-generator.com")! }
    public var path: String {
        switch self {
            
        case .getContacts():
            return "/api/json/get/4yLVmeGYe"
        }
    }
    public var method: Moya.Method {
        return .GET
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        default:
            return [:]
        }
    }
    
    public var sampleData: NSData {
        switch self {
        default:
            return "user status".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}


