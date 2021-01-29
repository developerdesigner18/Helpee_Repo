//
//  HomeVC.swift
//  Helpee
//
//  Created by iMac on 29/12/20.
//

import UIKit
import XLPagerTabStrip
import CoreLocation

class HomeVC: ButtonBarPagerTabStripViewController,CLLocationManagerDelegate {

    var latitude = ""
    var longitude = ""
    var locationManager = CLLocationManager()
    let blueInstagramColor = UIColor(red: 55/255.0, green: 160/255.0, blue: 0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callLanguageAPI()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        print("Bearer Token :=> ",UserManager.shared.token)
        
        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(callLatLong), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenAPICall(notification:)), name: Notification.Name("tokenAPICall"), object: nil)
    }
    
    func callLanguageAPI()
    {
        AppData.sharedInstance.showLoader()
        
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
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("didFailWithError: \(error.localizedDescription)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "OK")
        errorAlert.show()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        self.latitude = "\(newLocation.coordinate.latitude)"
        self.longitude = "\(newLocation.coordinate.longitude)"
    }
    
    @objc func callLatLong()
    {
        self.callLatLongAPI()
    }
    
    @objc func tokenAPICall(notification: Notification) {
        self.callSaveTokenAPI()
    }
    
    func callLatLongAPI()
    {
        //AppData.sharedInstance.showLoader()
        
        let params = ["userid":UserManager.shared.userid,
                      "latitude": self.latitude,
                      "longitude": self.longitude] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + LAT_LONG  , param: params) { (response, error) in
            //AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        
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
    
    func callSaveTokenAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["userid":UserManager.shared.userid,
                      "devicetoken":AppData.sharedInstance.fcm_token] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SAVE_TOKEN  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        
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
    
    override func viewWillAppear(_ animated: Bool) {
        // change selected bar color
        
        self.tabBarController?.tabBar.items?[0].title = AppData.sharedInstance.getLocalizeString(str: "HOME")
        self.tabBarController?.tabBar.items?[1].title = AppData.sharedInstance.getLocalizeString(str: "SETTINGS")
        self.tabBarController?.tabBar.items?[2].title = AppData.sharedInstance.getLocalizeString(str: "PROFILE")
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont(name: "AvenirNext-Medium", size: 14)!
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.imageView.tintColor = .white
            newCell?.imageView.tintColor = UIColor(red: 241/255, green: 193/255, blue: 14/255, alpha: 1.0)
            oldCell?.label.textColor = .black
            newCell?.label.textColor = .black
            oldCell?.label.backgroundColor = .white
            newCell?.label.backgroundColor = UIColor(red: 241/255, green: 193/255, blue: 14/255, alpha: 1.0)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = EmergencyVC(itemInfo: IndicatorInfo(title: AppData.sharedInstance.getLocalizeString(str: "Emergency"), image: UIImage(named: "emergency")))
        let child_2 = ReportVC(itemInfo: IndicatorInfo(title: AppData.sharedInstance.getLocalizeString(str: "Report Alert"), image: UIImage(named: "report-alert")))
        let child_3 = NearbyVC(itemInfo: IndicatorInfo(title: AppData.sharedInstance.getLocalizeString(str: "Nearby Alerts"), image: UIImage(named: "nearby-alert")))
        return [child_1, child_2, child_3]
    }
}
