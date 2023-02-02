//
//  DelicacyAPI.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.getDelicacy
//
import UIKit
import Moya
import ObjectMapper
import RxSwift

class DelicacyAPI {
    let mainQueue = MainScheduler.instance
    let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    let provider = MoyaProvider<DelicacyService>()

    func fetchDelicacyModel() -> Observable<DelicacyModel> {
        return provider.rx.request(.getDelicacy).asObservable().mapObject(DelicacyModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
