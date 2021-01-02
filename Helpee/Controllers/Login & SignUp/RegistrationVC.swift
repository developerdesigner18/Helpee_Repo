//
//  RegistrationVC.swift
//  Helpee
//
//  Created by iMac on 26/12/20.
//

import UIKit
import XLPagerTabStrip
import AnimatedField

class RegistrationVC: UIViewController,IndicatorInfoProvider,UITextFieldDelegate {

    @IBOutlet weak var txtFirstName: AnimatedField!
    @IBOutlet weak var txtLastName: AnimatedField!
    @IBOutlet weak var txtPass: AnimatedField!
    @IBOutlet weak var txtEmail: AnimatedField!
    @IBOutlet weak var txtLocation: AnimatedField!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhoneNo: UIButton!
    
    var itemInfo: IndicatorInfo = "View"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "RegistrationVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFieldsValidation()
    }
    
    func configureFieldsValidation()
    {
        // validation part configuration of email and password
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        format.textFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        format.alertColor = .red
        format.alertFieldActive = true
        format.titleAlwaysVisible = true
        format.alertFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        
        txtFirstName.format = format
        txtFirstName.placeholder = "Enter first name"
        txtFirstName.dataSource = self
        txtFirstName.delegate = self    
        txtFirstName.tag = 0
        
        txtLastName.format = format
        txtLastName.placeholder = "Enter last name"
        txtLastName.dataSource = self
        txtLastName.delegate = self
        txtLastName.tag = 1
        
        txtPass.format = format
        txtPass.placeholder = "Enter password"
        txtPass.dataSource = self
        txtPass.delegate = self
        //txtPass.type = .password(6, 10)
        txtPass.isSecure = true
        txtPass.showVisibleButton = true
        txtPass.tag = 2
        
        txtEmail.format = format
        txtEmail.placeholder = "Enter email"
        txtEmail.dataSource = self
        txtEmail.delegate = self
        txtEmail.type = .email
        txtEmail.tag = 3
        
        txtLocation.format = format
        txtLocation.placeholder = "Enter location"
        txtLocation.dataSource = self
        txtLocation.delegate = self
        txtLocation.tag = 4
        
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
    
    @IBAction func btnRegistration(_ sender: Any) {
        if let OtpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
        {
            navigationController?.pushViewController(OtpVC, animated: true)
        }
        else{
            print("not push")
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension RegistrationVC: AnimatedFieldDelegate {
    
    func animatedFieldDidBeginEditing(_ animatedField: AnimatedField) {
        /*let offset = animatedField.frame.origin.y + animatedField.frame.size.height - (view.frame.height - 350)
        scrollView.setContentOffset(CGPoint(x: 0, y: offset < 0 ? 0 : offset), animated: true)*/
    }
    
    func animatedFieldDidEndEditing(_ animatedField: AnimatedField) {
        if animatedField == txtFirstName
        {
            if animatedField.text == ""
            {
                txtFirstName.showAlert("Please enter first name")
            }
        }
        if animatedField == txtLastName
        {
            if animatedField.text == ""
            {
                txtLastName.showAlert("Please enter last name")
            }
        }
        if animatedField == txtPass
        {
            if animatedField.text == ""
            {
                txtPass.showAlert("Please enter password")
            }
        }
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
        if animatedField == txtLocation
        {
            if animatedField.text == ""
            {
                txtLocation.showAlert("Please enter location")
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
extension RegistrationVC: AnimatedFieldDataSource {
    
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
