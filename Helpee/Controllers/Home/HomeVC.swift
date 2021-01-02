//
//  HomeVC.swift
//  Helpee
//
//  Created by iMac on 29/12/20.
//

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {

    let blueInstagramColor = UIColor(red: 55/255.0, green: 160/255.0, blue: 0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // change selected bar color
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
        let child_1 = EmergencyVC(itemInfo: IndicatorInfo(title: "Emergency", image: UIImage(named: "emergency")))
        let child_2 = ReportVC(itemInfo: IndicatorInfo(title: "Report Alert", image: UIImage(named: "report-alert")))
        let child_3 = NearbyVC(itemInfo: IndicatorInfo(title: "Nearby Alerts", image: UIImage(named: "nearby-alert")))
        return [child_1, child_2, child_3]
    }
}
