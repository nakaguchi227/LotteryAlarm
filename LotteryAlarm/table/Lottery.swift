//
//  Lottery.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/08.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift


class Lottery: Object {
    @objc dynamic var id = 0
    @objc dynamic var lottery = 0
    @objc dynamic var wacthed = 0
    @objc dynamic var lotteryDate = Date()
        
    // IDをプライマリキーにする
    override static func primaryKey() -> String? {
        return "id"
        
    }
}
