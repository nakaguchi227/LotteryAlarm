//
//  SecondViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/24.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar
import CalculateCalendarLogic
import GoogleMobileAds

class SecondViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, GADBannerViewDelegate  {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var bannerView: GADBannerView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1566808571626806/1769336227"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
        
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let arraySet = CarendarArray.array()

        let year: Int = self.gregorian.component(.year, from: date)
        let day: Int = self.gregorian.component(.day, from: date)
        let month: Int = self.gregorian.component(.month, from: date)
        
        let pram1 = String(year) + String(month) + String(day) + String(1)
        let pram2 = String(year) + String(month) + String(day) + String(2)
        let pram3 = String(year) + String(month) + String(day) + String(3)
        let pram4 = String(year) + String(month) + String(day) + String(4)
        let pram5 = String(year) + String(month) + String(day) + String(5)
        
        if arraySet.contains(Int(pram1)!){
            return UIImage(named: "omikuji_1")
        }else if arraySet.contains(Int(pram2)!){
            return UIImage(named: "omikuji_2")
        }else if arraySet.contains(Int(pram3)!){
            return UIImage(named: "omikuji_3")
        }else if arraySet.contains(Int(pram4)!){
            return UIImage(named: "omikuji_4")
        }else if arraySet.contains(Int(pram5)!){
            return UIImage(named: "omikuji_5")
        }else{
            return nil
            
        }
        
        
//            return arraySet.contains(day) ? UIImage(named: "check") : nil
     }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }

}

