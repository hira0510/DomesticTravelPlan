//
//  DelicacyMainCollectionViewCell.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class DelicacyMainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sImageView: UIImageView!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var model: DelicacyInfo?
    private var isFavorite: Bool = false
    private let mSqlite = DelicacySQLite()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        sImageView.layer.cornerRadius = 5
        favoriteButton.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    }
    
    static var nib: UINib {
        return UINib(nibName: "DelicacyMainCollectionViewCell", bundle: nil)
    }
    
    func config(model: DelicacyInfo) {
        self.model = model
        
        sLabel.text = model.name.gb
        addLabel.text = model.add.gb
        sImageView.loadImage(url: model.image1, placeholder: UIImage(named: "noImage"), options: nil, completionHandler: nil)
        
        let favor = mSqlite.searchCollect(_id: model.id) > 0
        isFavorite = favor
        favor ? favoriteButton.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    
    @objc func clickFavorite() {
        guard let model = self.model else { return }
        isFavorite = !isFavorite
        isFavorite ? favoriteButton.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
        isFavorite ? mSqlite.insertData(_data: model): mSqlite.delData(_id: model.id)
    }
}
