//
//  HotelAPI.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import RxSwift

class HotelAPI {
    let mainQueue = MainScheduler.instance
    let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    let provider = MoyaProvider<HotelService>()

    func fetchHotelModel() -> Observable<HotelModel> {
        return provider.rx.request(.getHotel).asObservable().mapObject(HotelModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
