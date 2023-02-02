//
//  LotteryMainResultCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/10.
//

import UIKit

class LotteryMainResultCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sloganView: ShimmeringView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private var isFavorite: Bool = false
    private var hotelModel: HotelInfo?
    private var attractionsModel: AttractionsInfo?
    private var delicacyModel: DelicacyInfo?
    private let hotelSqlite = HotelSQLite()
    private let attractionsSqlite = AttractionsSQLite()
    private let delicacySqlite = DelicacySQLite()
    
    static var nib: UINib {
        return UINib(nibName: "LotteryMainResultCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let label = UILabel(frame: sloganView.bounds)
        label.text = "✨✨✨✨✨✨✨✨✨✨✨✨✨✨"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC", size: 16)
        
        sloganView.contentView = label
        sloganView.isShimmering = true
        sloganView.shimmerSpeed = 300
        sloganView.shimmerPauseDuration = 0.5
        
        favoriteButton.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
        bgView.layer.cornerRadius = 8
        addButton.layer.cornerRadius = 8
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
        } else {
            id = ""
            name = "查无资讯"
            add = ""
            image = ""
            isFavorite = false
        }
        
        favoriteButton.isUserInteractionEnabled = name != "查无资讯"
        addButton.isUserInteractionEnabled = name != "查无资讯"
        
        titleLabel.text = name
        addLabel.text = add
        mImageView.loadImage(url: image, placeholder: UIImage(named: "noImage"), options: nil, completionHandler: nil)
        
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
