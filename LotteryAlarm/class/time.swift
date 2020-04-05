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
        compornets.second = 0
        
        
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
        compornets.second = 0
        
        
        let today = calendar.date(from: compornets)

        let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let a = dateFormatter.string(from: today!) // 2017/10/01 00:00:00
        
        return today!
    
    
    }
    
    
    class func selectTimeTwoAf(hour:Int, min:Int)->Date{
        
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 2, to: tomorrow!)
        return modifiedDate!

    }
    
    class func selectTimeThreeAf(hour:Int, min:Int)->Date{
        
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 3, to: tomorrow!)
        return modifiedDate!

    }
    
    class func selectTimeFourAf(hour:Int, min:Int)->Date{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 4, to: tomorrow!)
        return modifiedDate!

    }
    
    class func selectTimeFiveAf(hour:Int, min:Int)->Date{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 5, to: tomorrow!)
        return modifiedDate!

    }
    
    class func selectTimeSixAf(hour:Int, min:Int)->Date{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 6, to: tomorrow!)
        return modifiedDate!

    }
    
    class func selectTimeSevenAf(hour:Int, min:Int)->Date{
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        var compornets = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        compornets.hour = hour
        compornets.minute = min
        compornets.second = 0
        
        let tomorrow = calendar.date(from: compornets)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: tomorrow!)
        return modifiedDate!

    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
    static let jst = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_JP")
}

extension Date {
    static var current: Date = Date(timeIntervalSinceNow: TimeInterval(TimeZone.jst.secondsFromGMT()))
}

extension DateFormatter {
    // テンプレートの定義(例)
    enum Template: String {
        case date = "yMd"     // 2017/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2017/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
        case year = "y"
        case month = "M"
        case day = "d"
        case hour = "H"
        case min = "m"
    }

    func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}
