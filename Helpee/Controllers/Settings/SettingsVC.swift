//
//  SettingsVC.swift
//  Helpee
//
//  Created by iMac on 29/12/20.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblUpdateDetails: UILabel!
    @IBOutlet weak var lblUpdateDetails2: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLanguageSelection: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var btnLanguageChange: UIButton!
    @IBOutlet weak var updateDetailsView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if let appLanguage = UserDefaults.standard.value(forKey: "appLanguage") as? String
        {
            if appLanguage == "en"
            {
                self.btnLanguageChange.setTitle(AppData.sharedInstance.getLocalizeString(str: "English"), for: .normal)
            }
            else{
                self.btnLanguageChange.setTitle(AppData.sharedInstance.getLocalizeString(str: "French"), for: .normal)
            }
        }
        else{
            self.btnLanguageChange.setTitle(AppData.sharedInstance.getLocalizeString(str: "English"), for: .normal)
        }
        self.btnSave.setTitle(AppData.sharedInstance.getLocalizeString(str: "Save"), for: .normal)
        self.lblUpdateDetails.text = AppData.sharedInstance.getLocalizeString(str: "Update Details")
        
        self.lblHeaderTitle.text = AppData.sharedInstance.getLocalizeString(str: "Settings")
        self.lblFirstName.text = AppData.sharedInstance.getLocalizeString(str: "First Name")
        self.lblLastName.text = AppData.sharedInstance.getLocalizeString(str: "Last Name")
        self.lblPassword.text = AppData.sharedInstance.getLocalizeString(str: "Password")
        
        self.lblLocation.text = AppData.sharedInstance.getLocalizeString(str: "Location")
        
        self.lblUpdateDetails2.text = AppData.sharedInstance.getLocalizeString(str: "Update Details")
        self.lblNotification.text = AppData.sharedInstance.getLocalizeString(str: "Notification")
        self.lblLanguageSelection.text = AppData.sharedInstance.getLocalizeString(str: "Language Selection")
        
        self.txtFName.text = UserManager.shared.firstname
        self.txtLName.text = UserManager.shared.lastname
        if UserManager.shared.email != ""
        {
            self.lblEmail.text = AppData.sharedInstance.getLocalizeString(str: "Email Address")
            self.txtEmail.text = UserManager.shared.email
        }
        else{
            self.lblEmail.text = AppData.sharedInstance.getLocalizeString(str: "Mobile Number")
            self.txtEmail.text = UserManager.shared.mobile
        }
        self.txtLocation.text = UserManager.shared.location
    }
    
    func callLogoutAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["":""] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + LOGOUT  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        UserManager.removeModel()
                        UserManager.getUserData()
                        UserManager.shared.userid = ""
                        UserManager.shared.token = ""
                        print(UserManager.shared.userid)
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        UIApplication.shared.windows.first?.rootViewController = redViewController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
    
    //MARK:- check validation empty
    func validate() -> Bool {
        if (!AppData.sharedInstance.isValidatePresence(string: self.txtFName.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter first name", viewController: self)
            return false
        }
        else if (!AppData.sharedInstance.isValidatePresence(string: self.txtLName.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter last name", viewController: self)
            return false
        }
        else if (!AppData.sharedInstance.isValidatePresence(string: self.txtLocation.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter middle name", viewController: self)
            return false
        }
        else {
            return true
        }
    }
    
    func callUpdateUserAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["id":UserManager.shared.userid,
                      "first_name":self.txtFName.text ?? "",
                      "last_name":self.txtLName.text ?? "",
                      "email":self.txtEmail.text ?? "",
                      "location":self.txtLocation.text ?? ""] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + UPDATE_DATA  , param: params) { (response, error) in
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
                            UserManager.getUserData()
                            
                            self.txtFName.text = UserManager.shared.firstname
                            self.txtLName.text = UserManager.shared.lastname
                            self.txtLocation.text = UserManager.shared.location
                            
                            self.updateDetailsView.isHidden = true
                            self.btnSave.isHidden = true
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
    
    func callLanguageAPI(language : String)
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["id":UserManager.shared.userid,
                      "language":language] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + LANGUAGE  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        print("Done Language :=> ",res)
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
    @IBAction func btnUpdateDetails(_ sender: Any) {
        self.updateDetailsView.isHidden = false
        self.btnSave.isHidden = false
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if self.validate()
        {
            self.view.endEditing(true)
            self.callUpdateUserAPI()
        }
    }
    
    @IBAction func btnLanguageChange(_ sender: Any) {
        let actionSheet = UIAlertController(title: AppData.sharedInstance.getLocalizeString(str: "Choose Language"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let take = UIAlertAction(title: AppData.sharedInstance.getLocalizeString(str: "English"), style: UIAlertAction.Style.default) { (action) in
            UserDefaults.standard.setValue("en", forKey: "appLanguage")
            AppData.sharedInstance.changeLangManual = true
            AppData.sharedInstance.appLanguage = "en"
            
            self.callLanguageAPI(language: "en")
            
            self.btnLanguageChange.setTitle(AppData.sharedInstance.getLocalizeString(str: "English"), for: .normal)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
            
        }
        let pick = UIAlertAction(title: AppData.sharedInstance.getLocalizeString(str: "French"), style: UIAlertAction.Style.default) { (action) in
            UserDefaults.standard.setValue("fr", forKey: "appLanguage")
            AppData.sharedInstance.changeLangManual = true
            AppData.sharedInstance.appLanguage = "fr"
            
            self.callLanguageAPI(language: "fr")
            
            self.btnLanguageChange.setTitle(AppData.sharedInstance.getLocalizeString(str: "French"), for: .normal)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        
        
        actionSheet.addAction(take)
        actionSheet.addAction(pick)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
