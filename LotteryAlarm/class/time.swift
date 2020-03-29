//
//  time.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/28.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import Foundation

class SelectTime{
    
    class func selectTimeTomorrow(hour:Int, min:Int)->Date{
        
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow!)


        let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let a = dateFormatter.string(from: tomorrow!) // 2017/10/01 00:00:00
        
        return modifiedDate!
    
    
    }
    
    class func selectTimeToday(hour:Int, min:Int)->Date{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        
        
        let today = calendar.date(from: compornets)

        let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let a = dateFormatter.string(from: today!) // 2017/10/01 00:00:00
        
        return today!
    
    
    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
    static let jst = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_JP")
}

extension DateFormatter {
    static func current(_ dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateFormat = dateFormat
        return df
    }
}

extension Date {
    static var current: Date = Date(timeIntervalSinceNow: TimeInterval(TimeZone.jst.secondsFromGMT()))
}
