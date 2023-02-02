//
//  DomesticFavoriteViewModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/9.
//

import UIKit

class DomesticFavoriteViewModel: DomesticBaseViewModel {
    
    internal var hotelModels: [HotelInfo] = []
    internal var attractionsModels: [AttractionsInfo] = []
    internal var delicacyModels: [DelicacyInfo] = []
    internal let hotelSqlite = HotelSQLite()
    internal let attractionsSqlite = AttractionsSQLite()
    internal let delicacySqlite = DelicacySQLite()
}
