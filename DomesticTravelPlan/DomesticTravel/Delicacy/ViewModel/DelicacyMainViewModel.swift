//
//  DelicacyMainViewModel.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum DelicacyCollectionSection {
    case select
    case search
    case data
}

class DelicacyMainViewModel: DomesticBaseViewModel {

    internal var delicacySequence = BehaviorRelay<[DelicacyInfo]>(value: [])
    internal var NData: [DelicacyInfo] = []
    internal var SData: [DelicacyInfo] = []
    internal var EData: [DelicacyInfo] = []
    internal var WData: [DelicacyInfo] = []
    internal var otherData: [DelicacyInfo] = []
    internal var searchData: [DelicacyInfo] = []
    internal var searchTitle: String = ""
    internal var collectionSection: [DelicacyCollectionSection] = [
            .select,
            .search,
            .data
    ]

    func setDelicacyData() -> Observable<Bool> {
        let data = GlobalUtil.delicacySequence
        self.delicacySequence.accept(data)

        let n: [String] = ["臺北", "台北", "新北", "基隆"]
        let w: [String] = ["桃園", "新竹", "苗栗", "彰化", "台中", "臺中", "南投"]
        let e: [String] = ["宜蘭", "花蓮", "臺東", "台東"]
        let s: [String] = ["雲林", "嘉義", "台南", "臺南", "高雄", "屏東"]

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

    func whichModel(search: Bool = false) -> [DelicacyInfo] {
        guard (searchTitle == "" && searchData.isEmpty) || search else {
            return searchData
        }
        switch types {
        case .all:
            return delicacySequence.value
        case .N:
            return NData
        case .E:
            return EData
        case .S:
            return SData
        case .W:
            return WData
        default:
            return otherData
        }
    }

    func search(title: String) {
        searchData = []
        guard title != "" else {
            types = DataType(rawValue: 0)!
            return
        }

        let title2 = title.big5

        let model = whichModel(search: true)
        for (i, v) in model.enumerated() {
            if model[i].add.contains(title) || model[i].add.contains(title2) || model[i].name.contains(title) || model[i].name.contains(title2) {
                searchData.append(v)
            }
        }
    }
}
