//
//  HotelTYCycleCollectionViewCell.swift
//
//
//  Created by    on
//  Copyright © All rights reserved.
//

import UIKit
import Kingfisher

class HotelTYCycleCollectionViewCell: UICollectionViewCell {

    lazy var image = UIImageView()
    lazy var views = RoundCornersView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image.frame = self.bounds
        self.image.layer.cornerRadius = 5
        self.image.clipsToBounds = true
        self.image.image = UIImage(named: "noImage")
        self.views.frame = self.bounds
        self.views.addSubview(image)
        self.views.layer.shadowRadius = 4
        self.views.layer.shadowColor = UIColor.black.cgColor
        self.views.layer.shadowOpacity = 0.5
        self.views.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.views.clipsToBounds = true
        self.views.layer.masksToBounds = false
        addSubview(views)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addImage(url: String) {
        image.loadImage(url: url, placeholder: UIImage(named: "noImage"), options: [.transition(.fade(0.5)), .keepCurrentImageWhileLoading], completionHandler: nil)
    }
}
