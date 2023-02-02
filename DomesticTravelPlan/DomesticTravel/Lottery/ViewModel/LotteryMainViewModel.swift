//
//  LotteryMainViewModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/10.
//

import UIKit

enum LotteryCollectionSection {
    case filter
    case result
}

class LotteryMainViewModel: DomesticBaseViewModel {
    
    internal var hotelData: HotelInfo?
    internal var attractionsData: AttractionsInfo?
    internal var delicacyData: DelicacyInfo?
    
    internal var collectionSection: [LotteryCollectionSection] = [
        .filter,
        .result
    ]
}
