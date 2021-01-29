//
//  ReportVC.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit
import CoreLocation
import XLPagerTabStrip

class ReportVC: UIViewController,IndicatorInfoProvider,CLLocationManagerDelegate {

    var popup = KLCPopup()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var lblSexual: UILabel!
    @IBOutlet weak var lblAccident: UILabel!
    @IBOutlet weak var lblPhysical: UILabel!
    @IBOutlet weak var lblKidnapping: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var alertView: UIView!
    var alertType = ""
    var latitude = ""
    var longitude = ""
    
    var itemInfo: IndicatorInfo = "View"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "ReportVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSexual.text = AppData.sharedInstance.getLocalizeString(str: "SEXUAL ASSAULT")
        self.lblAccident.text = AppData.sharedInstance.getLocalizeString(str: "ACCIDENT")
        self.lblKidnapping.text = AppData.sharedInstance.getLocalizeString(str: "KIDNAPPING")
        self.lblPhysical.text = AppData.sharedInstance.getLocalizeString(str: "PHYSICAL ASSAULT")
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        self.alertView.isHidden = true
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
        
        self.latitude = "\(location.latitude)"
        self.longitude = "\(location.longitude)"
        
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
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        self.lblLocation.text = addressString
                        
                    }
                }
        })
    }
    
    //MARK:- API Call
    func callCreateAlertAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["userid":UserManager.shared.userid,
                      "alerttypeid":self.alertType,
                      "location":self.lblLocation.text ?? "",
                      "latitude":self.latitude,
                      "longitude":self.longitude] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + CREATE_ALERT  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        self.popup.dismiss(true)
                        if let message = res.value(forKey: "message") as? String
                        {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
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
    @IBAction func btnRape(_ sender: Any) {
        self.alertType = "1"
        self.openAlertView(status: AppData.sharedInstance.getLocalizeString(str: "SEXUAL ASSAULT"))
    }
    
    @IBAction func btnAccident(_ sender: Any) {
        self.alertType = "2"
        self.openAlertView(status: AppData.sharedInstance.getLocalizeString(str: "ACCIDENT"))
    }
    
    @IBAction func btnKidnapping(_ sender: Any) {
        self.alertType = "3"
        self.openAlertView(status: AppData.sharedInstance.getLocalizeString(str: "KIDNAPPING"))
    }
    
    @IBAction func btnAssult(_ sender: Any) {
        self.alertType = "4"
        self.openAlertView(status: AppData.sharedInstance.getLocalizeString(str: "PHYSICAL ASSAULT"))
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.popup.dismiss(true)
    }
    
    @IBAction func btnAlert(_ sender: Any) {
        self.callCreateAlertAPI()
    }
    
    //MARK:- open alertView
    func openAlertView(status : String)
    {
        self.locationManager.startUpdatingLocation()
        self.titleLbl.text = status
        self.alertView.isHidden = false
        popup = KLCPopup(contentView: self.alertView, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        popup.show()
        popup.didFinishDismissingCompletion = {
           // self.ListNoteWebService()
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
