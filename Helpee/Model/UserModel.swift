//
//  UserModel.swift
//  GoPot
//
//  Created by macbook on 23/11/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static var shared = UserModel()
    
    class func saveUserData() {
        print(UserManager.shared)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: UserManager.shared)
        UserDefaults.standard.set(data, forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    class func getUserData() {
        if let data = UserDefaults.standard.object(forKey: "UserModel") as? Data {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data)
            UserManager.shared = model as! UserModel
        }
    }
    
    class func removeModel() {
        UserDefaults.standard.removeObject(forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
}
class UserModel: NSObject, NSCoding {
    
    var email = String()
    var firstname = String()
    var lastname = String()
    var location = String()
    var token = String()
    var userid = String()
    var mobile = String()
    
    override init() {
        
    }
    
    func initModel(attributeDict:NSDictionary) {
        print(attributeDict)
        if let val = attributeDict.value(forKey: "email") as? String {
            self.email = val
        }
        if let val = attributeDict.value(forKey: "first_name") as? String {
            self.firstname = val
        }
        if let val = attributeDict.value(forKey: "last_name") as? String {
            self.lastname = val
        }
        if let val = attributeDict.value(forKey: "location") as? String {
            self.location = val
        }
        if let val = attributeDict.value(forKey: "token") as? String {
            self.token = val
        }
        if let val = attributeDict.value(forKey: "id") as? NSNumber {
            self.userid = val.stringValue
        }
        if let val = attributeDict.value(forKey: "mobile") as? String {
            self.mobile = val
        }
    }
    
    init(email : String,firstname : String,lastname : String,location : String,token : String,userid : String,mobile : String) {
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.location = location
        self.token = token
        self.userid = userid
        self.mobile = mobile
    }
    
    required convenience init?(coder decoder: NSCoder) {
        
        var Email = String()
        var Firstname = String()
        var Lastname = String()
        var Location = String()
        var Token = String()
        var Userid = String()
        var Mobile = String()
        
        if let email = decoder.decodeObject(forKey: "email") as? String
        {
            Email = email
        }
        if let firstname = decoder.decodeObject(forKey: "first_name") as? String
        {
            Firstname = firstname
        }
        if let lastname = decoder.decodeObject(forKey: "last_name") as? String
        {
            Lastname = lastname
        }
        if let location = decoder.decodeObject(forKey: "location") as? String
        {
            Location = location
        }
        if let token = decoder.decodeObject(forKey: "token") as? String
        {
            Token = token
        }
        if let userid = decoder.decodeObject(forKey: "id") as? String
        {
            Userid = userid
        }
        if let mobile = decoder.decodeObject(forKey: "mobile") as? String
        {
            Mobile = mobile
        }
        self.init(
            email: Email,
            firstname: Firstname,
            lastname: Lastname,
            location: Location,
            token: Token,
            userid: Userid,
            mobile: Mobile
        )
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.firstname, forKey: "first_name")
        aCoder.encode(self.lastname, forKey: "last_name")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.userid, forKey: "id")
        aCoder.encode(self.mobile, forKey: "mobile")
    }
}
