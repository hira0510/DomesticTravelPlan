//
// JJKK
// GlobalUtil 建立時間：2018/10/2 1:19 PM
//
// 使用的Swift版本：4.0
//
// Copyright © 2018 . All rights reserved.


import Foundation
import Kingfisher
import RxCocoa
import RxSwift


class GlobalUtil {
    
    static var hotelSequence: [HotelInfo] = []
    static var attractionsSequence: [AttractionsInfo] = []
    static var delicacySequence: [DelicacyInfo] = []

    ///  指定時間戳的西元年月日時
    ///
    /// - Parameter timeInterval: 指定時間戳
    /// - Returns: 回傳西元年String 0.(2020.06.02) 1.(06/02/ 15:16) 2.(20200602-151617) 3.(2020/07/28)
    static func specificTimeIntervalChangeAnnoDomini(timeInterval: Int) -> (String, String, String, String) {
        let timeInterval: TimeInterval = TimeInterval(timeInterval)
        let date: Date = Date(timeIntervalSince1970: timeInterval)

        let dateFormat1: DateFormatter = DateFormatter()
        dateFormat1.dateFormat = "yyyy.MM.dd"
        let dateFormatStr1 = String(dateFormat1.string(from: date))

        let dateFormat2: DateFormatter = DateFormatter()
        dateFormat2.dateFormat = "MM/dd HH:mm"
        let dateFormatStr2 = String(dateFormat2.string(from: date))

        let dateFormat3: DateFormatter = DateFormatter()
        dateFormat3.dateFormat = "yyyyMMdd-HHmmss"
        dateFormat3.locale = Locale(identifier: "zh_Hans_CN")
        dateFormat3.timeZone = TimeZone(identifier: "Asia/Shanghai")
        let dateFormatStr3 = String(dateFormat3.string(from: date))

        let dateFormat4: DateFormatter = DateFormatter()
        dateFormat4.dateFormat = "yyyy/MM/dd"
        let dateFormatStr4 = String(dateFormat4.string(from: date))

        return (dateFormatStr1, dateFormatStr2, dateFormatStr3, dateFormatStr4)
    }

    /// 計算寬度等比放大縮小(播放器專用)
    ///
    /// - Parameter width: 設計稿的寬
    /// - Returns: 回傳CGFloat
    static func calculateWidthScaleWithSizePlayer(width: CGFloat) -> CGFloat {
        var scale: CGFloat = 0.0
        switch UIScreen.main.bounds.width {
        case 428:
            scale = width / CGFloat(428)
        case 414:
            scale = width / CGFloat(414)
        case 390:
            scale = width / CGFloat(390)
        case 375:
            scale = width / CGFloat(375)
        case 320:
            scale = width / CGFloat(320)
        default:
            scale = width / CGFloat(375)
        }
        let result = UIScreen.main.bounds.height * scale
        return result
    }

    /// 計算寬度等比放大縮小
    ///
    /// - Parameter width: 設計稿的寬
    /// - Returns: 回傳CGFloat
    static func calculateWidthScaleWithSize(width: CGFloat) -> CGFloat {
        var scale: CGFloat = 0.0
        switch UIScreen.main.bounds.width {
        case 428:
            scale = width / CGFloat(428)
        case 414:
            scale = width / CGFloat(414)
        case 390:
            scale = width / CGFloat(390)
        case 375:
            scale = width / CGFloat(375)
        case 320:
            scale = width / CGFloat(320)
        default:
            scale = width / CGFloat(375)
        }
        let result = UIScreen.main.bounds.width * scale
        return result
    }

    /// 計算等比放大縮小（長片主頁與專題專用）
    ///
    /// - Parameter width: 被計算的寬
    /// - Returns: 回傳CGFloat
    static func calculateWidthScaleWithSizeLongHomePage(width: CGFloat) -> CGFloat {
        let scale = width / CGFloat(375)
        let result = UIScreen.main.bounds.width * scale
        return result
    }
}
