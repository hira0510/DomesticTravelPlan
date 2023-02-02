//
//  HotelVIewModel.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

enum HotelCollectionSection {
    case search
    case banner
    case video
}

class HotelViewModel: DomesticBaseViewModel {

    internal var hotelSequence = BehaviorRelay<[HotelInfo]>(value: [])
    internal var areas: String = "全部"
    internal var NData: [HotelInfo] = []
    internal var WData: [HotelInfo] = []
    internal var SData: [HotelInfo] = []
    internal var EData: [HotelInfo] = []
    internal var otherData: [HotelInfo] = []
    internal var searchData: [HotelInfo] = []
    internal var areaData: [HotelInfo] = []
    internal var collectionSection: [HotelCollectionSection] = [
            .search,
            .banner,
            .video
    ]
    
    func requestHotelData() -> Observable<Bool> {
        return hotelApi.fetchHotelModel().flatMap { (object) -> Observable<Bool> in
            guard object.xmlHead?.infos?.info.count ?? 0 > 0 else { return Observable.just(false) }
            let model: [HotelInfo] = (object.xmlHead?.infos?.info)!
            let data: [HotelInfo] = model.filter { $0.image1 != "" } + model.filter { $0.image1 == "" }
            GlobalUtil.hotelSequence = data
            return self.setHotelData()
        }
    }
    
    func setHotelData() -> Observable<Bool> {
        let n: [String] = ["臺北", "台北", "新北", "基隆"]
        let w: [String] = ["桃園", "新竹", "苗栗", "彰化", "台中", "臺中", "南投"]
        let e: [String] = ["宜蘭", "花蓮", "臺東", "台東"]
        let s: [String] = ["雲林", "嘉義", "台南", "臺南", "高雄", "屏東"]

        let data = GlobalUtil.hotelSequence
        hotelSequence.accept(data)
        for (i, _) in data.enumerated() {
            if data[i].name != "" {
                if data[i].add.contains(strArray: n) {
                    self.NData.append(data[i])
                } else if data[i].add.contains(strArray: w) {
                    self.WData.append(data[i])
                } else if data[i].add.contains(strArray: e) {
                    self.EData.append(data[i])
                } else if data[i].add.contains(strArray: s) {
                    self.SData.append(data[i])
                } else {
                    self.otherData.append(data[i])
                }
            }
        }
        return Observable.just(true)
    }

    func search(title: String, toSearchMode: Bool = true) {
        guard title != "" else {
            searchData = []
            areaData = []
            types = DataType(rawValue: 0)!
            return
        }

        let title2 = title.big5
        if toSearchMode {
            searchData = []
            let model = whichModel()
            types = DataType(rawValue: 6)!

            for (i, v) in model.enumerated() {
                if model[i].add.contains(title) || model[i].add.contains(title2) || model[i].name.contains(title) || model[i].name.contains(title2) {
                    searchData.append(v)
                }
            }
        } else {
            areaData = []
            guard title != "全部" else { return }
            let model = whichModel()

            for (i, v) in model.enumerated() {
                if model[i].add.contains(title) || model[i].add.contains(title2) || model[i].name.contains(title) || model[i].name.contains(title2) {
                    areaData.append(v)
                }
            }
        }
    }

    func whichModel() -> [HotelInfo] {
        switch types {
        case .all:
            return hotelSequence.value
        case .N:
            return !areaData.isEmpty ? areaData : NData
        case .E:
            return !areaData.isEmpty ? areaData : EData
        case .S:
            return !areaData.isEmpty ? areaData : SData
        case .W:
            return !areaData.isEmpty ? areaData : WData
        case .other:
            return !areaData.isEmpty ? areaData : otherData
        case .search:
            return searchData
        }
    }
}

extension String {

    /// 是否包含字串
    ///
    /// - Parameter find: 要找的文字陣列
    /// - Returns: 回傳文字
    func contains(strArray: [String]) -> Bool {
        for str in strArray {
            if self.contains(str) {
                return true
            }
        }
        return false
    }
}
