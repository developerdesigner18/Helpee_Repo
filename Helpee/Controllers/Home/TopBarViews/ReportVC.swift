//
//  ReportVC.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit
import XLPagerTabStrip

class ReportVC: UIViewController,IndicatorInfoProvider {

    var popup = KLCPopup()
    @IBOutlet weak var alertView: UIView!
    
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
        self.alertView.isHidden = true
    }
    
    //MARK:- btn actions
    @IBAction func btnRape(_ sender: Any) {
        self.openAlertView()
    }
    
    @IBAction func btnAccident(_ sender: Any) {
        self.openAlertView()
    }
    
    @IBAction func btnKidnapping(_ sender: Any) {
        self.openAlertView()
    }
    
    @IBAction func btnAssult(_ sender: Any) {
        self.openAlertView()
    }
    
    //MARK:- open alertView
    func openAlertView()
    {
        self.alertView.isHidden = false
        popup = KLCPopup(contentView: self.alertView, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
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
