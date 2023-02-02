//
//  AttractionsViewModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

enum DataType: Int {
    case all = 0
    case N = 1
    case W = 2
    case S = 3
    case E = 4
    case other = 5
    case search = 6
}

enum AttractionsCollectionSection: String {
    case search = "搜尋"
    case N = "北部"
    case W = "中部"
    case S = "南部"
    case E = "东部"
    case other = "其他"
}

class AttractionsViewModel: DomesticBaseViewModel {

    internal var attractionsSequence = BehaviorRelay<[AttractionsInfo]>(value: [])
    internal var NData: [AttractionsInfo] = []
    internal var WData: [AttractionsInfo] = []
    internal var SData: [AttractionsInfo] = []
    internal var EData: [AttractionsInfo] = []
    internal var otherData: [AttractionsInfo] = []
    internal var searchTitle: String = ""
    internal var collectionSection: [AttractionsCollectionSection] = [
        .search,
        .N,
        .W,
        .S,
        .E,
        .other
    ]
    
    func setAttractionsData() -> Observable<Bool> {
        let data = GlobalUtil.attractionsSequence
        self.attractionsSequence.accept(data)
        
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
    
    func search(index: Int) -> [AttractionsInfo] {
        let title = searchTitle
        let title2 = title.big5
        
        let models: [[AttractionsInfo]] = [NData, WData, SData, EData, otherData]
        let model: [AttractionsInfo] = models[index]
        var data: [AttractionsInfo] = []
        
        guard title != "" else { return model }
        for (i, v) in model.enumerated() {
            if model[i].add.contains(title) || model[i].add.contains(title2) || model[i].name.contains(title) || model[i].name.contains(title2) {
                data.append(v)
            }
        }
        return data
    }
}
