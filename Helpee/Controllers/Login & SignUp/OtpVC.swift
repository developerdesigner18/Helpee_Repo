//
//  OtpVC.swift
//  Helpee
//
//  Created by iMac on 28/12/20.
//

import UIKit
import SVPinView

class OtpVC: UIViewController {

    @IBOutlet weak var lblVerification: UILabel!
    @IBOutlet weak var lblSentTo: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var btnSubmit: UIButton!
    var code = String()
    var email = String()
    var location = String()
    var type = String()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callGetEmergencyAPI()
        self.configurePinView()
    }
    
    //MARK:- API Call
    func callGetEmergencyAPI()
    {
        let params = ["country":self.location] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + GET_EMERGENCY  , param: params) { (response, error) in
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        if let message = res.value(forKey: "number") as? NSDictionary
                        {
                            let model = emergencyModel(dict: message)
                            AppData.sharedInstance.appLanguage = model.language
                            self.lblVerification.text = AppData.sharedInstance.getLocalizeString(str: "Verification Code")
                            self.lblSentTo.text = "\(AppData.sharedInstance.getLocalizeString(str: "Sent to")) \(self.email)"
                            self.btnResend.setTitle(AppData.sharedInstance.getLocalizeString(str: "RESEND OTP"), for: .normal)
                            self.btnSubmit.setTitle(AppData.sharedInstance.getLocalizeString(str: "SUBMIT"), for: .normal)
                        }
                    }
                    else{
                        if let message = res.value(forKey: "message") as? String
                        {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- config OTP View
    func configurePinView() {
        
        let nextStyle = 1
        let style = SVPinViewStyle(rawValue: nextStyle)!
        
        pinView.activeBorderLineThickness = 4
        pinView.fieldBackgroundColor = UIColor.clear
        pinView.activeFieldBackgroundColor = UIColor.clear
        pinView.fieldCornerRadius = 0
        pinView.activeFieldCornerRadius = 0
        pinView.style = style
        
        pinView.pinLength = 4
        //pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        /*pinView.textColor = AppData.sharedInstance.appBackGroundYellowColor
        pinView.borderLineColor = AppData.sharedInstance.appBackGroundYellowColor
        pinView.activeBorderLineColor = AppData.sharedInstance.appBackGroundYellowColor*/
        pinView.activeFieldBackgroundColor = UIColor.clear
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.isContentTypeOneTimeCode = true
        //pinView.placeholder = "******"
        //pinView.becomeFirstResponderAtIndex = 0
        
        pinView.font = UIFont(name: "AvenirNext-Medium", size: 18)!
        pinView.keyboardType = .phonePad
        pinView.didChangeCallback = { pin in
            if pin.count != 4
            {
                //self.btnSubmit.isHidden = true
            }else{
                self.pinView.backgroundColor = UIColor.clear
                //self.btnNext.isHidden = false
                //self.btnSubmit.isHidden = false
            }
        }
    }
    
    //MARK:- Call API
    func callVerifyOTPAPI()
    {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        if self.type == "1"
        {
            params = [
                "type": self.type,
                "email": self.email,
                "code": self.pinView.getPin()
            ]
        }
        else{
            params = [
                "type": self.type,
                "mobile": self.email,
                "code": self.pinView.getPin()
            ]
        }
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + VERIFY_CODE, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        if let resp = res.value(forKey: "data") as? NSDictionary
                        {
                            print(resp)
                            
                            let model = UserModel()
                            model.initModel(attributeDict: resp)
                            UserManager.shared = model
                            UserManager.saveUserData()
                            
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as! RAMAnimatedTabBarController
                            UIApplication.shared.windows.first?.rootViewController = redViewController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
                    else{
                        if let message = res.value(forKey: "message") as? String
                        {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK:- btn actions
    @IBAction func btnResend(_ sender: Any) {
        
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.callVerifyOTPAPI()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
