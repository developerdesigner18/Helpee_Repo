//
//  AllModel.swift
//  Helpee
//
//  Created by iMac on 25/01/21.
//

import UIKit

class nearByAlertModel: NSObject {
    
    var alert_name = String()
    var alert_img = String()
    var location = String()
    var created_at = String()
    
    override init() {
        
    }
    
    init(dict:NSDictionary)
    {
        if let alert_type_id = dict.value(forKey: "alert_type_id") as? NSNumber
        {
            if alert_type_id == 1
            {
                self.alert_name = AppData.sharedInstance.getLocalizeString(str: "SEXUAL ASSAULT")
                self.alert_img = "rape"
            }
            else if alert_type_id == 2
            {
                self.alert_name = AppData.sharedInstance.getLocalizeString(str: "ACCIDENT")
                self.alert_img = "accident"
            }
            else if alert_type_id == 3
            {
                self.alert_name = AppData.sharedInstance.getLocalizeString(str: "KIDNAPPING")
                self.alert_img = "rape"
            }
            else if alert_type_id == 4
            {
                self.alert_img = "assault"
                self.alert_name = AppData.sharedInstance.getLocalizeString(str: "PHYSICAL ASSAULT")
            }
        }
        if let location = dict.value(forKey: "location") as? String
        {
            self.location = location
        }
        if let created_at = dict.value(forKey: "created_at") as? String
        {
            self.created_at = created_at
        }
    }
}
class emergencyModel: NSObject {
    
    var police_no = String()
    var rescue_no = String()
    
    override init() {
        
    }
    
    init(dict:NSDictionary)
    {
        if let location = dict.value(forKey: "police_no") as? String
        {
            self.police_no = location
        }
        if let created_at = dict.value(forKey: "rescue_no") as? String
        {
            self.rescue_no = created_at
        }
    }
}
