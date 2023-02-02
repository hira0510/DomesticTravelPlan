//
//  DomesticTravelStoryBoardExtension.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit

extension UIStoryboard {
    
    /// 載入TabController
    ///
    /// - Returns:  回傳MainTabController
    static func loadDomesticMainTabController() -> DomesticMainTabController {
        let vc = UIStoryboard(name: "DomesticMain", bundle: nil).instantiateViewController(withIdentifier: "DomesticMainTabController") as! DomesticMainTabController
        return vc
    }
    
    /// 載入web頁
    ///
    /// - Returns:  回傳DomesticWebViewController
    static func loadDomesticWebViewController() -> DomesticWebViewController {
        let vc = UIStoryboard.init(name: "DomesticMain", bundle: nil).instantiateViewController(withIdentifier: "DomesticWebViewController") as! DomesticWebViewController
        return vc
    }
    
    /// 載入旅館資訊頁
    ///
    /// - Returns:  回傳HotelSecondViewController
    static func loadHotelSecondViewController(model: HotelInfo) -> HotelSecondViewController {
        let vc = UIStoryboard.init(name: "Hotel", bundle: nil).instantiateViewController(withIdentifier: "HotelSecondViewController") as! HotelSecondViewController
        vc.model = model
        return vc
    }
    
    /// 載入景點資訊頁
    ///
    /// - Returns:  回傳AttractionsResultViewController
    static func loadAttractionsResultViewController(model: AttractionsInfo) -> AttractionsResultViewController {
        let vc = UIStoryboard.init(name: "Attractions", bundle: nil).instantiateViewController(withIdentifier: "AttractionsResultViewController") as! AttractionsResultViewController
        vc.attractionsData = model
        return vc
    }
    
    /// 載入小吃資訊頁
    ///
    /// - Returns:  回傳DelicacySecondViewController
    static func loadDelicacySecondViewController(model: DelicacyInfo) -> DelicacySecondViewController {
        let vc = UIStoryboard.init(name: "Delicacy", bundle: nil).instantiateViewController(withIdentifier: "DelicacySecondViewController") as! DelicacySecondViewController
        vc.model = model
        return vc
    }
    
    /// 載入收藏頁
    ///
    /// - Returns:  回傳DomesticFavoriteViewController
    static func loadDomesticFavoriteViewController(type: DomesticFavoriteType) -> DomesticFavoriteViewController {
        let vc = UIStoryboard.init(name: "Favorite", bundle: nil).instantiateViewController(withIdentifier: "DomesticFavoriteViewController") as! DomesticFavoriteViewController
        vc.favorType = type
        return vc
    }
}
