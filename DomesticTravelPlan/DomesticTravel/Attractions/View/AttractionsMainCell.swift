//
//  AttractionsMainCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class AttractionsMainCell: UICollectionViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var model: AttractionsInfo?
    private var isFavorite: Bool = false
    private let mSqlite = AttractionsSQLite()
    
    static var nib: UINib {
        return UINib(nibName: "AttractionsMainCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
        favoriteButton.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    }
    
    internal func configCell(model: AttractionsInfo) {
        self.model = model
        
        titleLabel.text = model.name.gb
        addressLabel.text = model.add.gb
        mImageView.loadImage(url: model.image1, placeholder: UIImage(named: "noImage"), options: nil, completionHandler: nil)
        
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
