//
//  HotelBlankCollectionReusableView.swift
//  
//
//  Created by  on 2020/5/28.
//

import UIKit

class HotelBlankCollectionReusableView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib: UINib {
        return UINib(nibName: "HotelBlankCollectionReusableView", bundle: Bundle(for: self))
    }
}
