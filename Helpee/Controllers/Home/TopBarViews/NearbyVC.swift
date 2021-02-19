//
//  NearbyVC.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit
import XLPagerTabStrip

class NearbyVC: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var noDataLbl: UILabel!
    var arrNearByAlerts = NSMutableArray()
    @IBOutlet weak var tblView: UITableView!
    var itemInfo: IndicatorInfo = "View"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: "NearbyVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "NearbyCell", bundle: nil), forCellReuseIdentifier: "NearbyCell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callNearByAlertsAPI()
    }
    
    //MARK:- API Call
    func callNearByAlertsAPI()
    {
        AppData.sharedInstance.showLoader()
        
        let params = ["user_id":UserManager.shared.userid] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + GET_INCEDENTS  , param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary
            {
                if let success = res.value(forKey: "success") as? Int
                {
                    if success == 1
                    {
                        if let message = res.value(forKey: "alerts") as? NSArray
                        {
                            self.arrNearByAlerts = NSMutableArray()
                            for dict in message
                            {
                                let model = nearByAlertModel(dict: dict as! NSDictionary)
                                self.arrNearByAlerts.add(model)
                            }
                            self.noDataLbl.isHidden = true
                            self.tblView.reloadData()
                        }
                    }
                    else{
                        self.noDataLbl.isHidden = false
                        if let message = res.value(forKey: "message") as? String
                        {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension NearbyVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNearByAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "NearbyCell", for: indexPath) as! NearbyCell
        let model = self.arrNearByAlerts[indexPath.row] as! nearByAlertModel
        cell.lblDateTime.text = model.created_at
        cell.lblLocation.text = model.location
        cell.alertName.text = model.alert_name
        cell.alertImg.image = UIImage(named: model.alert_img)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 9
        {
            return 140
        }
        return 130
    }
}
