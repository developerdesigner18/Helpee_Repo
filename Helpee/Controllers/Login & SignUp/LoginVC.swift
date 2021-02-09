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
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: AnimatedField!
    @IBOutlet weak var txtPass: AnimatedField!
    var type = "1"
    var email = ""
    var name = ""
    var img = ""
    
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
        
        self.type = "1"
        
        self.localization()
        
        // validation part configuration of email and password
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        format.textFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        format.alertColor = .red
        format.alertFieldActive = true
        format.titleAlwaysVisible = true
        format.alertFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        
        txtEmail.format = format
        txtEmail.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter email")
        txtEmail.dataSource = self
        txtEmail.delegate = self
        txtEmail.type = .email
        txtEmail.tag = 0
        
        txtPass.format = format
        txtPass.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter password")
        txtPass.dataSource = self
        txtPass.delegate = self
        //txtPass.type = .password(6, 10)
        txtPass.isSecure = true
        txtPass.showVisibleButton = true
        txtPass.tag = 1
        
    }
    
    //MARK:- localization string
    func localization()
    {
        self.btnEmail.setTitle(AppData.sharedInstance.getLocalizeString(str: "Email"), for: .normal)
        self.btnPhoneNo.setTitle(AppData.sharedInstance.getLocalizeString(str: "Phone Number"), for: .normal)
        self.btnLogin.setTitle(AppData.sharedInstance.getLocalizeString(str: "LOG IN"), for: .normal)
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
                            self.img = url
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
                    self.email = email
                    print("EMAIL :=> \(email)")
                }
                if let first_name = resposne.value(forKey: "first_name") as? String
                {
                    self.name = first_name
                    print("FIRST_NAME :=> \(first_name)")
                }
                if let last_name = resposne.value(forKey: "last_name") as? String
                {
                    self.name += last_name
                    print("LAST_NAME :=> \(last_name)")
                }
                self.type = "3"
                self.callSocialLoginAPI()
            }
            else{
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    
    //MARK:- API CAll
    func callSocialLoginAPI()
    {
        AppData.sharedInstance.showLoader()
        let params = [
            "type": self.type,
            "email": self.email,
            "name": self.name,
            "image": self.img
        ] as NSDictionary
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SOCIAL_LOGIN, param: params) { (response, error) in
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
                            let model = UserModel()
                            model.initModel(attributeDict: resp)
                            UserManager.shared = model
                            UserManager.saveUserData()
                            
                            print(resp)
                            
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
    
    func callLoginAPI()
    {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        if txtEmail.placeholder == AppData.sharedInstance.getLocalizeString(str: "Enter email")
        {
            params = [
                "type": "1",
                "email": self.txtEmail.text ?? "",
                "password": self.txtPass.text ?? ""
            ]
        }
        else{
            params = [
                "type": "2",
                "mobile": self.txtEmail.text ?? "",
                "password": self.txtPass.text ?? ""
            ]
        }
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + LOGIN, param: params) { (response, error) in
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
                            let model = UserModel()
                            model.initModel(attributeDict: resp)
                            UserManager.shared = model
                            UserManager.saveUserData()
                            
                            print(resp)
                            
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
    
    func validation() -> Bool
    {
        if txtEmail.text == ""
        {
            if txtEmail.placeholder == AppData.sharedInstance.getLocalizeString(str: "Enter email")
            {
                txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter email"))
            }
            else{
                txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter phone number"))
            }
        }
        else if txtPass.text == ""
        {
            txtPass.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter password"))
        }
        else{
            return true
        }
        return false
    }
    
    //MARK:- btn actions
    @IBAction func btnEmail(_ sender: Any) {
        self.type = "1"
        self.btnEmail.setImage(UIImage(named: "radio_select"), for: .normal)
        self.btnPhoneNo.setImage(UIImage(named: "radio_unselect"), for: .normal)
        txtEmail.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter email")
        txtEmail.type = .email
        txtEmail.keyboardType = .emailAddress
    }
    
    @IBAction func btnPhoneNo(_ sender: Any) {
        txtEmail.keyboardType = .phonePad
        self.type = "2"
        self.btnPhoneNo.setImage(UIImage(named: "radio_select"), for: .normal)
        self.btnEmail.setImage(UIImage(named: "radio_unselect"), for: .normal)
        txtEmail.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter phone number")
        txtEmail.type = .none
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if self.validation()
        {
            self.callLoginAPI()
        }
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
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().delegate = self
        
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
                if animatedField.placeholder == AppData.sharedInstance.getLocalizeString(str: "Enter email")
                {
                    txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter email"))
                }
                else{
                    txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter phone number"))
                }
            }
        }
        if animatedField == txtPass
        {
            if animatedField.text == ""
            {
                txtPass.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter password"))
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
            return AppData.sharedInstance.getLocalizeString(str: "Email invalid! Please check again..")
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
            
            self.name = name ?? ""
            self.email = email ?? ""
            self.img = userImageURL?.absoluteString ?? ""
            
            
            self.type = "4"
            self.callSocialLoginAPI()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error)
    }
}
