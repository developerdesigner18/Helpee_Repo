//
//  ProfileVC.swift
//  Helpee
//
//  Created by iMac on 29/12/20.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnDeleteAcc: UIButton!
    
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblHeaderTitle.text = AppData.sharedInstance.getLocalizeString(str: "Profile")
        self.lblFirstName.text = AppData.sharedInstance.getLocalizeString(str: "First Name")
        self.lblLastName.text = AppData.sharedInstance.getLocalizeString(str: "Last Name")
        self.lblPassword.text = AppData.sharedInstance.getLocalizeString(str: "Password")
        self.lblLocation.text = AppData.sharedInstance.getLocalizeString(str: "Location")
        
        self.btnTerms.setTitle(AppData.sharedInstance.getLocalizeString(str: "Terms and Conditions"), for: .normal)
        self.btnLogout.setTitle(AppData.sharedInstance.getLocalizeString(str: "Logout"), for: .normal)
        self.btnDeleteAcc.setTitle(AppData.sharedInstance.getLocalizeString(str: "Delete Account"), for: .normal)
        
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
    
    func callDeleteAccAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["userid":UserManager.shared.userid] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + DELETE_ACC  , param: params) { (response, error) in
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
    
    //MARK:- btn actions
    @IBAction func btnLogout(_ sender: Any) {
        self.callLogoutAPI()
    }
    
    @IBAction func btnDeleteAcc(_ sender: Any) {
        self.callDeleteAccAPI()
    }
}
