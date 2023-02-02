//
//  DelicacySQLite.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/9.
//

import UIKit
import SQLite

struct DelicacySQLite {
    
    private var db: Connection!
    private let collection = Table("Delicacy") //表名
    private let id = Expression<Int64>("id")      //主键
    private let image1 = Expression<String>("image1")  //圖片1
    private let image2 = Expression<String>("image2") //圖片2
    private let image3 = Expression<String>("image3") //圖片3
    private let name = Expression<String>("name") //名稱
    private let tel = Expression<String>("tel") //电话
    private let description = Expression<String>("description") //介绍
    private let openTime = Expression<String>("openTime") //营业时间
    private let parkingInfo = Expression<String>("parkingInfo") //停车位
    private let website = Expression<String>("website") //網站
    private let add = Expression<String>("add") //地址
    private let px = Expression<Double>("px") //經度
    private let py = Expression<Double>("py") //緯度
    private let mId = Expression<String>("mId") //他的id
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3(filePath: String = "/Documents")  {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        do {
            db = try Connection(sqlFilePath)
            try db.run(collection.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(image1)
                t.column(image2)
                t.column(image3)
                t.column(name)
                t.column(tel)
                t.column(description)
                t.column(openTime)
                t.column(parkingInfo)
                t.column(website)
                t.column(add)
                t.column(px)
                t.column(py)
                t.column(mId)
            })
        } catch {
            print("db collection error => \(error)")
        }
    }
    
    //插入数据
    func insertData(_data: DelicacyInfo) {
        do {
            if searchCollect(_id: _data.id) == 0 && !_data.id.elementsEqual("") {
                let insert = collection.insert(image1 <- _data.image1, image2 <- _data.image2, image3 <- _data.image3, name <- _data.name, tel <- _data.tel, description <- _data.description, openTime <- _data.openTime, parkingInfo <- _data.parkingInfo, website <- _data.website, add <- _data.add, px <- _data.px, py <- _data.py, mId <- _data.id)
                try db.run(insert)
            }
        } catch {
            print("[DEBUG] insert error => \(error)")
        }
    }
    
    /// 更新数据
    func upDate(_data: DelicacyInfo) {
        do {
            if searchCollect(_id: _data.id) != 0 {
                let currUser = collection.filter(mId == _data.id)
                let insertVideoID = currUser.update(image1 <- _data.image1, image2 <- _data.image2, image3 <- _data.image3, name <- _data.name, tel <- _data.tel, description <- _data.description, openTime <- _data.openTime, parkingInfo <- _data.parkingInfo, website <- _data.website, add <- _data.add, px <- _data.px, py <- _data.py, mId <- _data.id)
                try db.run(insertVideoID)
            }
        } catch {
            print(error)
        }
    }
    
    //读取数据
    func readData() -> [DelicacyInfo] {
        var collectionArray: [DelicacyInfo] = []
        
        for user in try! db.prepare(collection) {
            var pars = [String: Any]()
            pars["Id"] = user[mId]
            pars["Name"] = user[name]
            pars["Tel"] = user[tel]
            pars["Add"] = user[add]
            pars["Description"] = user[description]
            pars["Px"] = user[px]
            pars["Py"] = user[py]
            pars["Picture1"] = user[image1]
            pars["Picture2"] = user[image2]
            pars["Picture3"] = user[image3]
            pars["Opentime"] = user[openTime]
            pars["Parkinginfo"] = user[parkingInfo]
            pars["Website"] = user[website]
            let collectionData: DelicacyInfo = DelicacyInfo(JSON: pars)!
            collectionArray.append(collectionData)
        }
        return collectionArray
    }
    
    func searchCollect(_id: String) -> Int {
        do {
            let searchCnt = collection.filter(mId == _id)
            return try db.scalar(searchCnt.count)
        } catch {
            return 0
        }
    }
    
    //删除数据
    func delData(_id: String) {
        let currUser = collection.filter(_id == self.mId)
        do {
            try db.run(currUser.delete())
        } catch {
            print(error)
        }
    }
}
