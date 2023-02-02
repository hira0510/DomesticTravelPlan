//
//  DomesticLandingViewModel.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit
import RxCocoa
import RxSwift

struct VersionInfo {
    var url: String //下載應用URL
    var title: String //title
    var message: String //提示內容
    var version: String //版本
}

class DomesticLandingViewModel: DomesticBaseViewModel {
    
    //本地版本
    private func localVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func versionUpdate() -> UIAlertController? {
        //1 請求服務端資料，並進行解析,得到需要的資料
        //2 版本更新
        let appId: String = "1579663274"
        //获取appstore上的最新版本号
        let appUrl: String = "http://itunes.apple.com/lookup?id=" + appId
        guard let appMsg = try? String.init(contentsOf: URL(string: appUrl)!, encoding: .utf8) else { return nil }
        let appMsgDict: [String: Any] = getDictFromString(jString: appMsg)
        guard let appResultsArray: NSArray = (appMsgDict["results"] as? NSArray) else { return nil }
        guard let appResultsDict: [String: Any] = appResultsArray.lastObject as? [String: Any] else { return nil }
        guard let appStoreVersion: String = appResultsDict["version"] as? String else { return nil }
        
        return handleUpdate(VersionInfo(url: "http://itunes.apple.com/app/id" + appId, title: "有新版本啦～", message: "赶快去升级吧～", version: appStoreVersion))
    }
    
    // 版本比較
    private func versionCompare(localVersion: String, serverVersion: String) -> Bool {
         let result = localVersion.compare(serverVersion, options: .numeric, range: nil, locale: nil)
         if result == .orderedDescending || result == .orderedSame {
             return false
         }
             return true
     }
    
    /// 版本更新
    private func handleUpdate(_ info: VersionInfo) -> UIAlertController? {
        guard let localVersion = localVersion(), versionCompare(localVersion: localVersion, serverVersion: info.version) else { return nil }
        let alert = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
        let update = UIAlertAction(title: "立即更新", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: info.url)!)
        })
        alert.addAction(update)
        return alert
    }

    /// JSONString转字典
    private func getDictFromString(jString: String) -> [String: Any] {
        if let jsonData = jString.data(using: .utf8, allowLossyConversion: false) {
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            guard let json = dict as? [String: Any] else { return [:] }
            return json
        }
        return [:]
    }
}
