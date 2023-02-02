//
//  DomesticSearchLittleCollectionViewCell.swift
//  

import UIKit

class DomesticSearchLittleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12.5
    }
    
    static var nib: UINib {
        return UINib(nibName: "DomesticSearchLittleCollectionViewCell", bundle: nil)
    }

    func configCell(title: String, select: Bool) {
        titleLabel.text = title.gb
        bgView.backgroundColor = select ? UIColor(0x9884D1): UIColor(0xAF84D1)
    }
}
