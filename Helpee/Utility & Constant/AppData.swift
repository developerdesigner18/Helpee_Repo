//
//  AppData.swift
//  Property
//
//  Created by macbook on 06/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppData: NSObject {
    
    var arrCardDetail = NSMutableArray()
    var arrRentDetail = NSMutableArray()
    var appLanguage = String()
    var changeLangManual = false
    var fcm_token = String()
    
    class var sharedInstance : AppData {
        
        struct Static {
            static let instance : AppData = AppData()
        }
        return Static.instance
    }
    
    func getLocalizeString(str:String) -> String {
        let string = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "appLanguage"), ofType: "lproj")
        let myBundle = Bundle(path: string!)
        return (myBundle?.localizedString(forKey: str, value: "", table: nil))!
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidatePresence(string: String) -> Bool {
        let trimmed: String = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    func isValidPhoneNumber(string: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func isValidPhoneNumber1(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        
        return result
    }
    
    func isOnlyNumber(string: String) -> Bool {
        let PHONE_REGEX = "^[0-9]*"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func isValidPhoneNumberWithCode(string: String) -> Bool {
        let PHONE_REGEX = "^\\+?91?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func showAlert(title: String, message: String, viewController : UIViewController)->Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
        }
        alert.addAction(action1)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK:-
    
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    func dismissLoader() {
        if(SVProgressHUD.isVisible()) {
            SVProgressHUD.dismiss()
        }
    }

    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension String {
    func localized(_ lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}
