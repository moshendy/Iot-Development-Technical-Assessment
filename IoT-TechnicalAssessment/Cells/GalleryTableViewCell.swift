//
//  GalleryTableViewCell.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
