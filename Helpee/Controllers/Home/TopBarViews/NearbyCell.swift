//
//  NearbyCell.swift
//  Helpee
//
//  Created by iMac on 30/12/20.
//

import UIKit

class NearbyCell: UITableViewCell {
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var alertName: UILabel!
    @IBOutlet weak var vW: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //vW.layer.masksToBounds = false
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
