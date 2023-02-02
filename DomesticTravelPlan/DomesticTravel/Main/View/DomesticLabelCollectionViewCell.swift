//
//  DomesticLabelCollectionViewCell.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

protocol HotelAddressProtocol: AnyObject {
    func clickAddBtn(px: Double, py: Double)
    func clickWebBtn(url: String)
}

class DomesticLabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var telLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var webLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var serviceInfoLbl: UILabel!
    @IBOutlet weak var parkingSpaceLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!

    internal weak var delegate: HotelAddressProtocol?
    private var data: HotelInfo!
    private var attractionsData: AttractionsInfo!
    private var delicacyData: DelicacyInfo!

    static var nib: UINib {
        return UINib(nibName: "DomesticLabelCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func clickWebBtn(_ sender: UIButton) {
        var url: String = ""
        if let datas = data {
            url = datas.website
        } else if let datas = attractionsData {
            url = datas.website
        } else if let datas = delicacyData {
            url = datas.website
        }
        delegate?.clickWebBtn(url: url)
    }

    @IBAction func clickAddBtn(_ sender: UIButton) {
        var px: Double = 0.0
        var py: Double = 0.0
        if let datas = data {
            px = datas.px
            py = datas.py
        } else if let datas = attractionsData {
            px = datas.px
            py = datas.py
        } else if let datas = delicacyData {
            px = datas.px
            py = datas.py
        }
        delegate?.clickAddBtn(px: px, py: py)
    }

    func configCell(model: HotelInfo) {
        data = model
        nameLbl.text = text(model.name.gb)
        telLbl.text = "电话：" + text(model.tel)
        descriptionLbl.text = "介绍：" + text(model.description.gb)
        moneyLbl.text = "价格：" + text(model.money.gb)
        serviceInfoLbl.text = "服务介绍：" + text(model.serviceInfo.gb)
        parkingSpaceLbl.text = "停车位：" + text(model.parkingInfo.gb)

        webLbl.attributedText = attributedString(text: text(model.website), isAdd: false)
        addLbl.attributedText = attributedString(text: text(model.add.gb), isAdd: true)

        webBtn.isUserInteractionEnabled = model.website != ""

        if model.add != "" {
            addBtn.isUserInteractionEnabled = model.px > 0 && model.py > 0
        } else {
            addBtn.isUserInteractionEnabled = false
        }
    }

    func attractionsConfigCell(model: AttractionsInfo) {
        attractionsData = model
        nameLbl.text = text(model.name.gb)
        telLbl.text = "电话：" + text(model.tel)
        descriptionLbl.text = "介绍：" + text(model.toldeScribe.gb)
        moneyLbl.text = "票价：" + text(model.ticketInfo.gb)
        serviceInfoLbl.text = "营业时间：" + text(model.openTime.gb)
        parkingSpaceLbl.text = ""

        webLbl.attributedText = attributedString(text: text(model.website), isAdd: false)
        addLbl.attributedText = attributedString(text: text(model.add.gb), isAdd: true)

        webBtn.isUserInteractionEnabled = model.website != ""

        if model.add != "" {
            addBtn.isUserInteractionEnabled = model.px > 0 && model.py > 0
        } else {
            addBtn.isUserInteractionEnabled = false
        }
    }

    func delicacyConfigCell(model: DelicacyInfo) {
        delicacyData = model
        nameLbl.text = text(model.name.gb)
        telLbl.text = "电话：" + text(model.tel)
        descriptionLbl.text = "介绍：" + text(model.description.gb)
        moneyLbl.text = ""
        serviceInfoLbl.text = "营业时间：" + text(model.openTime.gb)
        parkingSpaceLbl.text = "停车位：" + text(model.parkingInfo.gb)

        webLbl.attributedText = attributedString(text: text(model.website), isAdd: false)
        addLbl.attributedText = attributedString(text: text(model.add.gb), isAdd: true)

        webBtn.isUserInteractionEnabled = model.website != ""

        if model.add != "" {
            addBtn.isUserInteractionEnabled = model.px > 0 && model.py > 0
        } else {
            addBtn.isUserInteractionEnabled = false
        }
    }

    private func attributedString(text: String, isAdd: Bool) -> NSMutableAttributedString {
        let str = isAdd ? "地址：" : "官方网站："
        let attributedString = NSMutableAttributedString(string: "\(str)\(text)", attributes: [
                .font: UIFont(name: "PingFangTC-Regular", size: 17.0)!,
                .foregroundColor: UIColor.blue,
                .kern: -0.33
            ])
        attributedString.addAttributes([
                .font: UIFont(name: "PingFangTC-Regular", size: 17.0)!,
                .foregroundColor: UIColor(red: 91 / 255, green: 58 / 255, blue: 165 / 255, alpha: 1),
                .kern: -0.33
            ], range: NSRange(location: 0, length: str.count))
        return attributedString
    }

    func text(_ data: String) -> String {
        data == "" ? "--" : data
    }
}
