//
//  Alarm.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/24.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift


class Alarm: Object {
    @objc dynamic var id = 0
    @objc dynamic var alarm = Date()
    @objc dynamic var all = 0
    @objc dynamic var mon = 0
    @objc dynamic var tue = 0
    @objc dynamic var wed = 0
    @objc dynamic var thu = 0
    @objc dynamic var fri = 0
    @objc dynamic var sat = 0
    @objc dynamic var sun = 0
    @objc dynamic var only = 0
    @objc dynamic var createAt = Date()
    
    // IDをプライマリキーにする
    override static func primaryKey() -> String? {
        return "id"
        
    }
}
