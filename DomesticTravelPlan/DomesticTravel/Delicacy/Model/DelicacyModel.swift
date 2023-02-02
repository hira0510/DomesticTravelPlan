//
//  DelicacyModel.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.
//
import Foundation
import ObjectMapper

class DelicacyModel: Mappable {

    var head: DelicacyHead?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        head <- map["XML_Head"]
    }
}

class DelicacyHead: Mappable {

    var infos: DelicacyInfos?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        infos <- map["Infos"]
    }
}

class DelicacyInfos: Mappable {

    var info: [DelicacyInfo] = []

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        info <- map["Info"]
    }
}

class DelicacyInfo: Mappable {

    var id: String = ""
    var name: String = ""
    var tel: String = ""
    var add: String = ""
    var description: String = ""
    var px: Double = 0
    var py: Double = 0
    var image1: String = ""
    var image2: String = ""
    var image3: String = ""
    var openTime: String = ""
    var parkingInfo: String = ""
    var website: String = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        tel <- map["Tel"]
        add <- map["Add"]
        description <- map["Description"]
        px <- map["Px"]
        py <- map["Py"]
        image1 <- map["Picture1"]
        image2 <- map["Picture2"]
        image3 <- map["Picture3"]
        openTime <- map["Opentime"]
        parkingInfo <- map["Parkinginfo"]
        website <- map["Website"]
    }
}
