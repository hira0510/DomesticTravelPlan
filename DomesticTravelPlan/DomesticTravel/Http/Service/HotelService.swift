//
//  HotelService.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Moya

enum HotelService {
    case getHotel
}

extension HotelService: TargetType {

    var baseURL: URL {
        return URL(string: "https://media.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json")!
    }

    var path: String {
        switch self {
        case .getHotel:
            return ""
        }
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
