//
//  EmergencyVC.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit
import CoreLocation
import XLPagerTabStrip

class EmergencyVC: UIViewController,IndicatorInfoProvider,CLLocationManagerDelegate {

    @IBOutlet weak var btnPolice: UIButton!
    @IBOutlet weak var btnRescue: UIButton!
    @IBOutlet weak var lblPolice: UILabel!
    @IBOutlet weak var lblRescue: UILabel!
    var itemInfo: IndicatorInfo = "View"
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var btnCountry: UIButton!
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "EmergencyVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnCountry.setTitle(UserManager.shared.location, for: .normal)
        
        self.btnCountry.setImage(UIImage(named: self.locale(for: UserManager.shared.location)), for: .normal)
        
        self.callGetEmergencyAPI()
        
        self.lblPolice.text = AppData.sharedInstance.getLocalizeString(str: "Police")
        self.lblRescue.text = AppData.sharedInstance.getLocalizeString(str: "Rescue")
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locale(for fullCountryName : String) -> String {
        var locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode as! String
            }
        }
        return locales
    }
    
    //MARK:- btn actions
    @IBAction func btnPolice(_ sender: Any) {
        if let url = URL(string: "tel://\(self.btnPolice.titleLabel?.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnRescue(_ sender: Any) {
        if let url = URL(string: "tel://\(self.btnRescue.titleLabel?.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- API Call
    func callGetEmergencyAPI()
    {
        //AppData.sharedInstance.showLoader()
        
        let params = ["country":self.btnCountry.titleLabel?.text ?? ""] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + GET_EMERGENCY  , param: params) { (response, error) in
            //AppData.sharedInstance.dismissLoader()
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
                            self.btnPolice.setTitle(model.police_no, for: .normal)
                            self.btnRescue.setTitle(model.rescue_no, for: .normal)
                            
                            self.callLanguageAPI()
                            
                            if let appLanguage = UserDefaults.standard.value(forKey: "appLanguage") as? String
                            {
                                if appLanguage == "en"
                                {
                                    AppData.sharedInstance.appLanguage = "en"
                                }
                                else{
                                    AppData.sharedInstance.appLanguage = "fr"
                                }
                            }
                            else{
                                if model.language != AppData.sharedInstance.appLanguage
                                {
                                    if !AppData.sharedInstance.changeLangManual
                                    {
                                        UserDefaults.standard.setValue(model.language, forKey: "appLanguage")
                                        AppData.sharedInstance.appLanguage = model.language
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
                                    }
                                }
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
    
    func callLanguageAPI()
    {
        //AppData.sharedInstance.showLoader()
        
        let params = ["userid":UserManager.shared.userid,
                      "language":AppData.sharedInstance.appLanguage] as NSDictionary
        
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
    
    // MARK: - Location Manager Delegate
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("didFailWithError: \(error)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "OK")
        errorAlert.show()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        self.getAddressFromLatLon(location: newLocation.coordinate)
    }
    
    //MARK:- get Address from latitude and longitude
    func getAddressFromLatLon(location : CLLocationCoordinate2D) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = location.latitude
        center.longitude = location.longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    //print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil
                {
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        //let addressString : String = ""
                        /*if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }*/
                        if pm.country != nil {
//                            self.btnCountry.setTitle(pm.country, for: .normal)
//
//                            self.btnCountry.setImage(UIImage(named: self.locale(for: pm.country ?? "")), for: .normal)
                            //addressString = addressString + pm.country! + ", "
                        }
                        /*if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }*/
                    }
                }
        })
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
