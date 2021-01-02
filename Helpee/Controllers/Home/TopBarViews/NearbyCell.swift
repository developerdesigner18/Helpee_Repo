//
//  NearbyCell.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit

class NearbyCell: UITableViewCell {
    
    @IBOutlet weak var vW: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vW.addShadowView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension UIView {
    
    func addShadowView() {
        //Remove previous shadow views
        superview?.viewWithTag(119900)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = 119900
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.25
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
}
