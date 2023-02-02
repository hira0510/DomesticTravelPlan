//
//  HotelModel.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//
import Foundation
import ObjectMapper

class HotelModel: Mappable {

    var xmlHead: HotelXmlHead?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        xmlHead <- map["XML_Head"]
    }
}

class HotelXmlHead: Mappable {

    var infos: HotelInfos?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        infos <- map["Infos"]
    }
}

class HotelInfos: Mappable {

    var info: [HotelInfo] = []

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        info <- map["Info"]
    }
}

class HotelInfo: Mappable {

    var id: String = ""
    var name: String = ""
    var description: String = ""
    var add: String = ""
    var tel: String = ""
    var image1: String = ""
    var image2: String = ""
    var image3: String = ""
    var px: Double = 0
    var py: Double = 0
    var money: String = ""
    var serviceInfo: String = ""
    var parkingInfo: String = ""
    var website: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        description <- map["Description"]
        add <- map["Add"]
        tel <- map["Tel"]
        image1 <- map["Picture1"]
        image2 <- map["Picture2"]
        image3 <- map["Picture3"]
        px <- map["Px"]
        py <- map["Py"]
        money <- map["Spec"]
        serviceInfo <- map["Serviceinfo"]
        parkingInfo <- map["Parkinginfo"]
        website <- map["Website"]
    }
}
