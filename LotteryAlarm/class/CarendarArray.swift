//
//  CarendarArray.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/11.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import Foundation
import RealmSwift

class CarendarArray{
    class func array() -> [Int]{
        
        let realm = try! Realm()
        let LotteryRsults = realm.objects(Lottery.self)
        
        var arraySet: [Int] = []
        
        LotteryRsults.forEach{
            let lotteryDate = $0.lotteryDate
            
            let calendar = Calendar(identifier: .gregorian)
            let todayStart = calendar.startOfDay(for: Date())
            
            if $0.lotteryDate > todayStart{
                return
            }
            
            // DateFormatter のインスタンスを作成
            let alarmSetJpYear = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpYear.locale = Locale(identifier: "ja_JP")
            alarmSetJpYear.setTemplate(.year)
           let year = Int(alarmSetJpYear.string(from: lotteryDate))
            
            let alarmSetJpMonth = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpMonth.locale = Locale(identifier: "ja_JP")
            alarmSetJpMonth.setTemplate(.month)
            let month = Int(alarmSetJpMonth.string(from: lotteryDate))
            
            let alarmSetJpDay = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpDay.locale = Locale(identifier: "ja_JP")
            alarmSetJpDay.setTemplate(.day)
            let day = Int(alarmSetJpDay.string(from: lotteryDate))
            
            let no = $0.lottery
            
            let parm = String(year!) + String(month!) + String(day!) + String(no)
            
            arraySet.append(Int(parm)!)
        }
       
        return arraySet
        
    }
}
