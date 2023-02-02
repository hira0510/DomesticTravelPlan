//
//  DomesticSearchCircleCollectionViewCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/3.
//

import UIKit

class DomesticSearchCircleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "DomesticSearchCircleCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func configCell(text: String, select: Bool) {
        mImageView.alpha = select ? 1 : 0.6
        mLabel.text = text.gb
    }
}
