//
//  DomesticBaseViewModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit
import RxCocoa
import RxSwift

class DomesticBaseViewModel: NSObject {

    public let attractionsApi = AttractionsAPi()
    public let hotelApi = HotelAPI()
    public let delicacyApi = DelicacyAPI()
    public var types: DataType = .all
    
    func requestAttractionsData() -> Observable<Bool> {
        return attractionsApi.fetchDataAttractions().flatMap { (object) -> Observable<Bool> in
            guard object.xmlHead?.infos?.info.count ?? 0 > 0 else { return Observable.just(false) }
            let model: [AttractionsInfo] = object.xmlHead?.infos?.info ?? []
            let data: [AttractionsInfo] = model.filter { $0.image1 != "" } + model.filter { $0.image1 == "" }
            GlobalUtil.attractionsSequence = data
            return Observable.just(true)
        }
    }
    
    func requestDelicacyData() -> Observable<Bool> {
        return delicacyApi.fetchDelicacyModel().flatMap { (object) -> Observable<Bool> in
            guard object.head?.infos?.info.count ?? 0 > 0 else { return Observable.just(false) }
            let model: [DelicacyInfo] = (object.head?.infos?.info)!
            let data: [DelicacyInfo] = model.filter { $0.image1 != "" } + model.filter { $0.image1 == "" }
            GlobalUtil.delicacySequence = data
            return Observable.just(true)
        }
    }
}
