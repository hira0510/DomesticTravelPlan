//
//  DomesticImageCollectionViewCell.swift
//  
//
//  Created by  on 2020/5/28.
//

import UIKit
import Kingfisher

class DomesticImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.cornerRadius = 5
    }
    
    static var nib: UINib {
        return UINib(nibName: "DomesticImageCollectionViewCell", bundle: nil)
    }

    internal func configCell(img: String) {
        imageV.loadImage(url: img, placeholder: UIImage(named: "noImage"), options: nil, completionHandler: nil)
    }
}
