//
//  AttractionsModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import Foundation
import ObjectMapper

class AttractionsModel: Mappable {

    var xmlHead: AttractionsXmlHead?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        xmlHead <- map["XML_Head"]
    }
}

class AttractionsXmlHead: Mappable {

    var infos: AttractionsInfos?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        infos <- map["Infos"]
    }
}

class AttractionsInfos: Mappable {

    var info: [AttractionsInfo] = []

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        info <- map["Info"]
    }
}

class AttractionsInfo: Mappable {

    var id: String = ""
    var name: String = ""
    var toldeScribe: String = ""
    var tel: String = ""
    var add: String = ""
    var image1: String = ""
    var image2: String = ""
    var image3: String = ""
    var px: Double = 0
    var py: Double = 0
    var ticketInfo: String = ""
    var openTime: String = ""
    var website: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        toldeScribe <- map["Toldescribe"]
        tel <- map["Tel"]
        add <- map["Add"]
        image1 <- map["Picture1"]
        image2 <- map["Picture2"]
        image3 <- map["Picture3"]
        px <- map["Px"]
        py <- map["Py"]
        ticketInfo <- map["Ticketinfo"]
        openTime <- map["Opentime"]
        website <- map["Website"]
    }
}
