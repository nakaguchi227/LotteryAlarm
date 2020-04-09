//
//  LotterySet.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/08.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import Foundation
import RealmSwift

class LotterySet{
    class func LotteryNo(settingDate:Date) -> Int{
        
        // テンプレートから時刻を表示
        let setting = DateFormatter()
        setting.setTemplate(.date)
        let setDate = setting.string(from: settingDate)
        let calendar = Calendar(identifier: .gregorian)
        let setDayStart = calendar.startOfDay(for: settingDate)
       
        var id:Int?
        var lotteryNo:Int?
        
       let realm = try! Realm()
        let setDateFindData = realm.objects(Lottery.self).filter("lotteryDate == %@", setDayStart).first
        if let setDateFind = setDateFindData{
            lotteryNo = setDateFind.lottery
        }else{
            let result = realm.objects(Lottery.self)
            if result.count == 0{
                id = 1
            }else{
                let newDate = result.sorted(byKeyPath: "id", ascending: false).first
                id = newDate!.id + 1
            }
            
            // 1から10までのIntを生成
            let iValue = Int.random(in: 1 ... 10)
            print(iValue)
            
            switch iValue {
            case 1:
                lotteryNo = 1
            case (2...4):
                lotteryNo = 2
            case (5...7):
                lotteryNo = 3
            case (8...9):
                lotteryNo = 4
            case 10:
                lotteryNo = 5
            default:
                lotteryNo = 1
            }
            
            let lotteryData = Lottery()
            lotteryData.id = id!
            lotteryData.lottery = lotteryNo!
            lotteryData.lotteryDate = setDayStart
            
            try! realm.write {
                realm.add(lotteryData)
            }
            
        }
        
        return lotteryNo!
    }
}
