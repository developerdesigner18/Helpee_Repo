//
//  LoginVC.swift
//  Helpee
//
//  Created by iMac on 25/12/20.
//

import UIKit
import XLPagerTabStrip
import AnimatedField
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LoginVC: UIViewController,IndicatorInfoProvider,UITextFieldDelegate {

    @IBOutlet weak var btnPhoneNo: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var txtEmail: AnimatedField!
    @IBOutlet weak var txtPass: AnimatedField!
    
    var itemInfo: IndicatorInfo = "View"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "LoginVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().delegate = self
        
        // validation part configuration of email and password
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        format.textFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        format.alertColor = .red
        format.alertFieldActive = true
        format.titleAlwaysVisible = true
        format.alertFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        
        txtEmail.format = format
        txtEmail.placeholder = "Enter email"
        txtEmail.dataSource = self
        txtEmail.delegate = self
        txtEmail.type = .email
        txtEmail.tag = 0
        
        txtPass.format = format
        txtPass.placeholder = "Enter password"
        txtPass.dataSource = self
        txtPass.delegate = self
        //txtPass.type = .password(6, 10)
        txtPass.isSecure = true
        txtPass.showVisibleButton = true
        txtPass.tag = 1
        
    }
    
    //MARK:- get Facebook Info
    func getUserProfile () {
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name, picture.type(large),birthday, location{location{country, country_code}}"])) { (httpResponse, result, error) in
            print("result == ", result)
            print("httpResponse == ", httpResponse)
            let resposne = result as! NSDictionary
            if error == nil
            {
                if let picture = resposne.value(forKey: "picture") as? NSDictionary
                {
                    if let data = picture.value(forKey: "data") as? NSDictionary
                    {
                        if let url = data.value(forKey: "url") as? String
                        {
                            print("URL :=> \(url)")
                        }
                    }
                }
                if let id = resposne.value(forKey: "id") as? String
                {
                    print("ID :=> \(id)")
                }
                if let email = resposne.value(forKey: "email") as? String
                {
                    self.txtEmail.text = email
                    print("EMAIL :=> \(email)")
                }
                if let first_name = resposne.value(forKey: "first_name") as? String
                {
                    print("FIRST_NAME :=> \(first_name)")
                }
                if let last_name = resposne.value(forKey: "last_name") as? String
                {
                    print("LAST_NAME :=> \(last_name)")
                }
                //self.signUpWebService()
            }
            else{
                print("Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
    //MARK:- btn actions
    @IBAction func btnEmail(_ sender: Any) {
        self.btnEmail.setImage(UIImage(named: "radio_select"), for: .normal)
        self.btnPhoneNo.setImage(UIImage(named: "radio_unselect"), for: .normal)
        txtEmail.placeholder = "Enter email"
        txtEmail.type = .email
    }
    
    @IBAction func btnPhoneNo(_ sender: Any) {
        self.btnPhoneNo.setImage(UIImage(named: "radio_select"), for: .normal)
        self.btnEmail.setImage(UIImage(named: "radio_unselect"), for: .normal)
        txtEmail.placeholder = "Enter phone number"
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
    }
    
    @IBAction func btnFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                let token = accessToken
                print("Logged in!", token)
                //self.strLogin = "2"
                self.getUserProfile()
            }
        }
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
extension LoginVC: AnimatedFieldDelegate {
    
    func animatedFieldDidBeginEditing(_ animatedField: AnimatedField) {
        /*let offset = animatedField.frame.origin.y + animatedField.frame.size.height - (view.frame.height - 350)
        scrollView.setContentOffset(CGPoint(x: 0, y: offset < 0 ? 0 : offset), animated: true)*/
    }
    
    func animatedFieldDidEndEditing(_ animatedField: AnimatedField) {
        if animatedField == txtEmail
        {
            if animatedField.text == ""
            {
                if animatedField.placeholder == "Enter email"
                {
                    txtEmail.showAlert("Please enter email")
                }
                else{
                    txtEmail.showAlert("Please enter phone number")
                }
            }
        }
        if animatedField == txtPass
        {
            if animatedField.text == ""
            {
                txtPass.showAlert("Please enter password")
            }
        }
        /*var _: CGFloat = 0
        if animatedField.frame.origin.y + animatedField.frame.size.height > scrollView.frame.height {
            offset = animatedField.frame.origin.y + animatedField.frame.size.height - scrollView.frame.height + 10
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        
        let validEmailUser = emailAnimatedField.isValid && usernameAnimatedField.isValid
        continueButton.isEnabled = validEmailUser
        continueButton.alpha = validEmailUser ? 1.0 : 0.3*/
    }
    
    func animatedField(_ animatedField: AnimatedField, didResizeHeight height: CGFloat) {
        //multilineHeightConstraint.constant = height
        view.layoutIfNeeded()
        
        //let offset = animatedField.frame.origin.y + height - (view.frame.height - 350)
        //scrollView.setContentOffset(CGPoint(x: 0, y: offset < 0 ? 0 : offset), animated: false)
    }
    
    func animatedField(_ animatedField: AnimatedField, didSecureText secure: Bool) {
        /*if animatedField == passwordAnimatedField {
            password2AnimatedField.secureField(secure)
        }*/
    }
    
    func animatedField(_ animatedField: AnimatedField, didChangePickerValue value: String) {
        //numberAnimatedField.text = value
    }
    
    func animatedFieldDidChange(_ animatedField: AnimatedField) {
        print("text: \(animatedField.text ?? "")")
    }
}
extension LoginVC: AnimatedFieldDataSource {
    
    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        switch animatedField.tag {
        case 1: return 10
        case 8: return 30
        default: return nil
        }
    }
    
    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        if animatedField == txtEmail {
            return "Email invalid! Please check again ;)"
        }
        return nil
    }
}
//MARK:- Google SignIn Delegates
extension LoginVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            
            print("Gmail login success")
            print(user)
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            let userImageURL = user.profile.imageURL(withDimension: 200)
            // ...
            print(userImageURL)
            print(userId)
            print(idToken)
            print(name)
            print(email)
            self.txtEmail.text = email
            //self.signUpWebService()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error)
    }
}
