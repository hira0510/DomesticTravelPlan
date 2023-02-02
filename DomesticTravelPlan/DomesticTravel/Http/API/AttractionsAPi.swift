//
//  AttractionsAPi.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import RxSwift

class AttractionsAPi {
    let mainQueue = MainScheduler.instance
    let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    let provider = MoyaProvider<AttractionsService>()

    func fetchDataAttractions() -> Observable<AttractionsModel> {
        return provider.rx.request(.getAttractionsJson).asObservable().mapObject(AttractionsModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
