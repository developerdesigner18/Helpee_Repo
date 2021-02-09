//
//  RegistrationVC.swift
//  Helpee
//
//  Created by iMac on 26/12/20.
//

import UIKit
import XLPagerTabStrip
import AnimatedField

class RegistrationVC: UIViewController,IndicatorInfoProvider,UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var popup = KLCPopup()
    var arrCountry = NSMutableArray()
    var arrSearchResult = NSArray()
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var txtFirstName: AnimatedField!
    @IBOutlet weak var txtLastName: AnimatedField!
    @IBOutlet weak var txtPass: AnimatedField!
    @IBOutlet weak var txtEmail: AnimatedField!
    @IBOutlet weak var txtLocation: AnimatedField!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhoneNo: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    var isValida = false
    var type = "1"
    var isSearch = 0
    
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
        
        self.searchBar.delegate = self
        
        self.lblTopTitle.text = AppData.sharedInstance.getLocalizeString(str: "Select Country")
        self.btnDone.setTitle(AppData.sharedInstance.getLocalizeString(str: "Done"), for: .normal)
        self.btnCancel.setTitle(AppData.sharedInstance.getLocalizeString(str: "Cancel"), for: .normal)
        
        self.callGetEmergencyAPI()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
        
        self.alertView.isHidden = true
        
        self.configureFieldsValidation()
        self.localization()
    }
    
    //MARK:- localization string
    func localization()
    {
        self.btnEmail.setTitle(AppData.sharedInstance.getLocalizeString(str: "Email"), for: .normal)
        self.btnPhoneNo.setTitle(AppData.sharedInstance.getLocalizeString(str: "Phone Number"), for: .normal)
        self.btnRegistration.setTitle(AppData.sharedInstance.getLocalizeString(str: "REGISTRATION"), for: .normal)
        if #available(iOS 13.0, *) {
            self.searchBar.searchTextField.placeholder = AppData.sharedInstance.getLocalizeString(str: "Country")
        } else {
            // Fallback on earlier versions
        }
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
        txtFirstName.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter first name")
        txtFirstName.dataSource = self
        txtFirstName.delegate = self
        txtFirstName.tag = 0
        
        txtLastName.format = format
        txtLastName.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter last name")
        txtLastName.dataSource = self
        txtLastName.delegate = self
        txtLastName.tag = 1
        
        txtPass.format = format
        txtPass.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter password")
        txtPass.dataSource = self
        txtPass.delegate = self
        //txtPass.type = .password(6, 10)
        txtPass.isSecure = true
        txtPass.showVisibleButton = true
        txtPass.tag = 2
        
        txtEmail.format = format
        txtEmail.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter email")
        txtEmail.dataSource = self
        txtEmail.delegate = self
        txtEmail.type = .email
        txtEmail.tag = 3
        
        txtLocation.format = format
        txtLocation.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter country")
        txtLocation.dataSource = self
        txtLocation.delegate = self
        txtLocation.tag = 4
        
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearch = 0
            self.tblView.reloadData()
        }else {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind:Int,text:String) {
//        filter({ (mod) -> Bool in
//            return mod.imageName.lowercased().contains(text.lowercased())
//        })
        self.arrSearchResult = NSArray()
        self.arrSearchResult = self.arrCountry.filter { (model) -> Bool in
            return (model as! emergencyModel).english_name.contains(text)
        } as NSArray
        
        print(self.arrSearchResult)
        self.isSearch = 1
        self.tblView.reloadData()
    }
    
    //MARK:- API Call
    func callGetEmergencyAPI()
    {
        //AppData.sharedInstance.showLoader()
        
        let params = ["country":""] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + GET_EMERGENCY  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        if let message = res.value(forKey: "number") as? NSArray
                        {
                            for dict in message
                            {
                                let model = emergencyModel(dict: dict as! NSDictionary)
                                self.arrCountry.add(model)
                            }
                            self.tblView.reloadData()
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
    
    func callRegistrationAPI()
    {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        if txtEmail.placeholder == AppData.sharedInstance.getLocalizeString(str: "Enter email")
        {
            params = [
                "type": "1",
                "firstname": self.txtFirstName.text ?? "",
                "lastname": self.txtLastName.text ?? "",
                "password": self.txtPass.text ?? "",
                "location": self.txtLocation.text ?? "",
                "email": self.txtEmail.text ?? ""
            ]
        }
        else{
            params = [
                "type": "2",
                "firstname": self.txtFirstName.text ?? "",
                "lastname": self.txtLastName.text ?? "",
                "password": self.txtPass.text ?? "",
                "location": self.txtLocation.text ?? "",
                "mobile": self.txtEmail.text ?? ""
            ]
        }
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + REGISTER, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
//                        let model = UserModel()
//                        model.initModel(attributeDict: resp)
//                        UserManager.shared = model
//                        UserManager.saveUserData()
                        if let message = res.value(forKey: "message") as? Int
                        {
                            print(message)
                            
                            if let OtpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                            {
                                OtpVC.code = (message as NSNumber).stringValue
                                OtpVC.email = self.txtEmail.text ?? ""
                                OtpVC.location = self.txtLocation.text ?? ""
                                OtpVC.type = self.type
                                self.navigationController?.pushViewController(OtpVC, animated: true)
                            }
                            else{
                                print("not push")
                            }
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
        if self.txtFirstName.text == ""
        {
            txtFirstName.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter first name"))
        }
        else if self.txtLastName.text == ""
        {
                txtLastName.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter last name"))
        }
        else if self.txtPass.text == ""
        {
                txtPass.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter password"))
        }
        else if self.txtEmail.text == ""
        {
            if self.txtEmail.placeholder == AppData.sharedInstance.getLocalizeString(str: "Enter email")
            {
                txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter email"))
            }
            else{
                txtEmail.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter phone number"))
            }
        }
        else if self.txtLocation.text == ""
        {
            txtLocation.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter country"))
        }
        else{
            return true
        }
        return false
    }
    
    //MARK:- btn actions
    @IBAction func btnCountry(_ sender: Any) {
        self.alertView.isHidden = false
        popup = KLCPopup(contentView: self.alertView, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        popup.show()
        popup.didFinishDismissingCompletion = {
           // self.ListNoteWebService()
        }
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.txtLocation.text = self.arrCountry[0] as! String
        self.popup.dismiss(true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.popup.dismiss(true)
    }
    
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
        txtEmail.type = .none
        self.type = "2"
        self.btnPhoneNo.setImage(UIImage(named: "radio_select"), for: .normal)
        self.btnEmail.setImage(UIImage(named: "radio_unselect"), for: .normal)
        txtEmail.placeholder = AppData.sharedInstance.getLocalizeString(str: "Enter phone number")
    }
    
    @IBAction func btnRegistration(_ sender: Any) {
        if self.validation()
        {
            let txt = self.txtEmail.text ?? ""
            if self.type == "2"
            {
                if txt.contains("+")
                {
                    self.callRegistrationAPI()
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: AppData.sharedInstance.getLocalizeString(str: "Please enter country code"), viewController: self)
                }
            }
            else{
                self.callRegistrationAPI()
            }
        }
        else{
            
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
                txtFirstName.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter first name"))
            }
        }
        else if animatedField == txtLastName
        {
            if animatedField.text == ""
            {
                txtLastName.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter last name"))
            }
        }
        else if animatedField == txtPass
        {
            if animatedField.text == ""
            {
                txtPass.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter password"))
            }
        }
        else if animatedField == txtEmail
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
        else if animatedField == txtLocation
        {
            if animatedField.text == ""
            {
                txtLocation.showAlert(AppData.sharedInstance.getLocalizeString(str: "Please enter country"))
            }
        }
        else{
            self.isValida = true
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
            return AppData.sharedInstance.getLocalizeString(str: "Email invalid! Please check again..")
        }
        return nil
    }
}
extension RegistrationVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch == 1
        {
            return self.arrSearchResult.count
        }
        else{
            return self.arrCountry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        var model = emergencyModel()
        if self.isSearch == 1
        {
            model = self.arrSearchResult[indexPath.row] as! emergencyModel
        }
        else{
            model = self.arrCountry[indexPath.row] as! emergencyModel
        }
        
        if AppData.sharedInstance.appLanguage == "en"
        {
            cell.textLabel?.text = model.english_name
        }
        else{
            cell.textLabel?.text = model.french_name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = emergencyModel()
        if self.isSearch == 1
        {
            model = self.arrSearchResult[indexPath.row] as! emergencyModel
        }
        else{
            model = self.arrCountry[indexPath.row] as! emergencyModel
        }
        
        if AppData.sharedInstance.appLanguage == "en"
        {
            self.txtLocation.text = model.english_name
        }
        else{
            self.txtLocation.text = model.french_name
        }
        
        self.popup.dismiss(true)
    }
}
