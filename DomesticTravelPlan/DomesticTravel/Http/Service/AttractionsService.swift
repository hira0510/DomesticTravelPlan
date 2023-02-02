//
//  AttractionsService.swift
//  DomesticTravelPlan
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Moya

enum AttractionsService {
    case getAttractionsJson
}

extension AttractionsService: TargetType {

    var baseURL: URL {
        return URL(string: "https://media.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json")!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }
}
