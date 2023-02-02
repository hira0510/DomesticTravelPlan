//
//  StringExtension.swift
//  JJKK
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation

extension String {

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }


    /// 替換字串
    ///
    /// - Parameters:
    ///   - target: 要被替換的文字
    ///   - withString: 替換的文字
    /// - Returns: 回傳文字
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }

    /// 是否包含字串
    ///
    /// - Parameter find: 要找的文字
    /// - Returns: 回傳文字
    func contains(find: String) -> Bool {
        if self.range(of: find) != nil {
            return true
        } else {
            return false
        }
    }

    /// 網址Encoded，因為Kinfisher不支援中文字..
    ///
    /// - Returns: 回傳Encode字串
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    /// 從某個啟始點之後的佔位符開始擷取
    ///
    /// - Parameter index: 從哪一個
    /// - Returns: 回字串
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]

            return String(subString)
        } else {
            return self
        }
    }
}

extension Int {

    func secondsToHoursMinutesSeconds() -> (String, String, String) {
        var h = String(format: "%i:", self / 3600)
        var m = String(format: "%i:", (self % 3600) / 60)
        var s = String((self % 3600) % 60)

        if self / 3600 <= 0 {
            h = ""
        }

        if self / 3600 < 10 && self / 3600 != 0 {
            h = String(format: "0%i:", self / 3600)
        }

        if (self % 3600) / 60 < 10 {
            m = String(format: "0%i:", (self % 3600) / 60)
        }

        if (self % 3600) % 60 < 10 {
            s = String(format: "0%i ", (self % 3600) % 60)
        }

        return (h, m, s)
    }
}
