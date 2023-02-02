//
//
// FireBaseManager 建立時間：2019/4/2 10:05 AM
//
// 使用的Swift版本：4.0
//
// Copyright © 2019 . All rights reserved.


import Foundation
import Firebase

class FireBaseManager {

    private static var instance: FireBaseManager? = nil

    public static var shard: FireBaseManager {
        get {
            objc_sync_enter(FireBaseManager.self)
            if instance == nil {
                instance = FireBaseManager()
            }
            objc_sync_exit(FireBaseManager.self)
            return instance!
        }
    }

    private init() {

    }
    
    func reportFirebase(domain: String, msg: String, text: String) {
        let userInfo = [
            "msg": msg,
            "text": text
        ]
        let error = NSError(domain: domain, code: -999, userInfo: userInfo)
        sendCrashEvent(error: error)
    }

    /// 傳送網路錯誤事件
    ///
    /// - Parameters:
    ///   - name: 事件名稱
    ///   - event: 事件描述
    public func sendEvent(name: String, event: [String: Any]) {

        onBackgroundThread {
            Analytics.logEvent(name, parameters: event)
        }
    }
    
    /// 傳送自定義播放請求失敗紀錄
    public func sendCrashEvent(error: Error) {
        onBackgroundThread {
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    /// 背景異步
    ///
    /// - Parameter block:
    public func onBackgroundThread(block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
}
