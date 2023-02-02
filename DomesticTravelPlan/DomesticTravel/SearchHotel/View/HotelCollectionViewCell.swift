//
//  HotelCollectionViewCell.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class HotelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    @IBOutlet weak var telLbl: UILabel!
    @IBOutlet weak var favorBtn: UIButton!
    
    private var model: HotelInfo?
    private var isFavorite: Bool = false
    private let mSqlite = HotelSQLite()
    
    override func awakeFromNib() {
         super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        imageV.layer.cornerRadius = 5
        favorBtn.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    }

    static var nib: UINib {
        return UINib(nibName: "HotelCollectionViewCell", bundle: nil)
    }

    internal func configCell(data: HotelInfo) {
        model = data
        titleLbl.text = data.name.gb
        telLbl.text = "☎️ " + data.tel.gb
        addLbl.text = data.add.gb
        imageV.loadImage(url: data.image1, placeholder: UIImage(named: "noImage"), options: [.transition(.fade(0.5))], completionHandler: nil)
                
        let favor = mSqlite.searchCollect(_id: data.id) > 0
        isFavorite = favor
        favor ? favorBtn.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favorBtn.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    
    @objc func clickFavorite() {
        guard let model = self.model else { return }
        isFavorite = !isFavorite
        isFavorite ? favorBtn.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favorBtn.setImage(UIImage(named: "Favorites"), for: .normal)
        isFavorite ? mSqlite.insertData(_data: model): mSqlite.delData(_id: model.id)
    }
}
