//
//  DomesticFavoriteMainCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/9.
//

import UIKit

class DomesticFavoriteMainCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sImageView: UIImageView!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var isFavorite: Bool = false
    private var hotelModel: HotelInfo?
    private var attractionsModel: AttractionsInfo?
    private var delicacyModel: DelicacyInfo?
    private let hotelSqlite = HotelSQLite()
    private let attractionsSqlite = AttractionsSQLite()
    private let delicacySqlite = DelicacySQLite()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        sImageView.layer.cornerRadius = 5
        favoriteButton.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    }
    
    static var nib: UINib {
        return UINib(nibName: "DomesticFavoriteMainCell", bundle: nil)
    }
    
    func config(hotel: HotelInfo? = nil, attractions: AttractionsInfo? = nil, delicacy: DelicacyInfo? = nil) {
        var id: String = ""
        var name: String = ""
        var add: String = ""
        var image: String = ""
        
        if let hotel = hotel {
            hotelModel = hotel
            id = hotel.id.gb
            name = hotel.name.gb
            add = hotel.add.gb
            image = hotel.image1.gb
            isFavorite = hotelSqlite.searchCollect(_id: id) > 0
        } else if let attractions = attractions {
            attractionsModel = attractions
            id = attractions.id.gb
            name = attractions.name.gb
            add = attractions.add.gb
            image = attractions.image1.gb
            isFavorite = attractionsSqlite.searchCollect(_id: id) > 0
        } else if let delicacy = delicacy {
            delicacyModel = delicacy
            id = delicacy.id.gb
            name = delicacy.name.gb
            add = delicacy.add.gb
            image = delicacy.image1.gb
            isFavorite = delicacySqlite.searchCollect(_id: id) > 0
        }
        
        sLabel.text = name
        addLabel.text = add
        sImageView.loadImage(url: image, placeholder: UIImage(named: "noImage"), options: nil, completionHandler: nil)
        
        isFavorite ? favoriteButton.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    
    @objc func clickFavorite() {
        isFavorite = !isFavorite
        isFavorite ? favoriteButton.setImage(UIImage(named: "Favorites_choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
        
        if let model = hotelModel {
            isFavorite ? hotelSqlite.insertData(_data: model): hotelSqlite.delData(_id: model.id)
        } else if let model = attractionsModel {
            isFavorite ? attractionsSqlite.insertData(_data: model): attractionsSqlite.delData(_id: model.id)
        } else if let model = delicacyModel {
            isFavorite ? delicacySqlite.insertData(_data: model): delicacySqlite.delData(_id: model.id)
        }
    }
}
