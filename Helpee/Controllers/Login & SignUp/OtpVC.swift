//
//  OtpVC.swift
//  Helpee
//
//  Created by iMac on 28/12/20.
//

import UIKit
import SVPinView

class OtpVC: UIViewController {

    @IBOutlet weak var pinView: SVPinView!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePinView()
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
    
    //MARK:- btn actions
    @IBAction func btnResend(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as! RAMAnimatedTabBarController
        UIApplication.shared.windows.first?.rootViewController = redViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

        
        /*let RAMAnimatedTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as! RAMAnimatedTabBarController
        self.navigationController?.pushViewController(RAMAnimatedTabBarController, animated: true)*/
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
