//
//  FirstViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/24.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    
    // UIImage のインスタンスを設定
    let check = UIImage(named:"check")!
    let noCheck = UIImage(named:"nocheck")!
    
    //端末のサイズを取得
    let myBoundSize: CGSize = UIScreen.main.bounds.size
    //チェックボタンのサイズ
    var buttonWidth: CGFloat = 24
    var buttonHeight: CGFloat = 24
    
    //チェックボタン文字のフォントとサイズ
    var labelFont: CGFloat = 18
    var labelWidth: CGFloat = 24
    var labelHeight: CGFloat = 24
    var labelWidth2: CGFloat = 40
    
    
    //stasuを定義
    let on:Int = 1
    let off:Int = 0
   
    //月曜のチェックボタン
    @IBOutlet weak var monCheckButton: UIButton!
    
    //火曜のチェックボタン
    @IBOutlet weak var tueCheckButton: UIButton!
    //水曜のチェックボタン
    @IBOutlet weak var wedCheckButton: UIButton!
    //木曜のチェックボタン
    @IBOutlet weak var thuCheckButton: UIButton!
    //金曜のチェックボタン
    @IBOutlet weak var friCheckButton: UIButton!
    //土曜のチェックボタン
    @IBOutlet weak var satCheckButton: UIButton!
    //日曜のチェックボタン
    @IBOutlet weak var sunCheckButton: UIButton!
    
    //毎日のチェックボタン
    @IBOutlet weak var allCheckButton: UIButton!
    //一回のみのチェックボタン
    @IBOutlet weak var onlyCheckButton: UIButton!
    
    var allStatus:Int?
    var onlyStatus:Int?
    var monStatus:Int?
    var tueStatus:Int?
    var wedStatus:Int?
    var thuStatus:Int?
    var friStatus:Int?
    var satStatus:Int?
    var sunStatus:Int?
    
    var alarm:Date?
    
    //ピッカー
    @IBOutlet weak var timePickerView: UIPickerView!
    
    
    //時間を定義
    let dataList = [
        Array(0..<24),
        Array(0..<60)
    ]
    
    var selectedHour:Int?
    var selectedMin:Int?
    

       //コンポーネントに含まれるデータの個数を返すメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return dataList[component].count
       }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0{
            return 50
        }else{
            return 50
        }
    }
       

       //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = dataList[component][row].description
        
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectTime = dataList[component][row]
        
        let row1 = pickerView.selectedRow(inComponent: 0)
        let row2 = pickerView.selectedRow(inComponent: 1)
        
        let h = self.pickerView(pickerView, titleForRow: row1, forComponent: 0)
        let m = self.pickerView(pickerView, titleForRow:row2, forComponent: 1)
        
        selectedHour = Int(h!)!
        selectedMin = Int(m!)!
        
    }
    
    @IBOutlet weak var countTime: UILabel!
    
    var alarmHour:Int = 1
    var alarmMin:Int = 1
    var alarmSec:Int = 1
    //timerの時間(1時間,10分,10秒)
    var time: [Int] = [1,10,10]
    var countDown:Timer?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        timePickerView.frame = CGRect(x: 0, y: myBoundSize.height * 0.1, width: myBoundSize.width, height: myBoundSize.height * 0.25)
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        let realm = try! Realm()
        
        let alarmResult = realm.objects(Alarm.self).first
        
        if let status = alarmResult{
            allStatus = status.all
            onlyStatus = status.only
            monStatus = status.mon
            tueStatus = status.tue
            wedStatus = status.wed
            thuStatus = status.thu
            friStatus = status.fri
            satStatus = status.sat
            sunStatus = status.sun
        }else{
            allStatus = off
            onlyStatus = off
            monStatus = off
            tueStatus = off
            wedStatus = off
            thuStatus = off
            friStatus = off
            satStatus = off
            sunStatus = off
            
        }
        
        
        //月曜ボタンとラベル
        if monStatus! == on{
            monCheckButton.setImage(check, for: .normal)
        }else{
            monCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        monCheckButton.tintColor = UIColor.gray  //画像の色を設定
        monCheckButton.frame = CGRect(x: myBoundSize.width * 0.1, y: myBoundSize.height * 0.45, width: buttonWidth, height: buttonHeight)
        let monLabel = UILabel()
        monLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        monLabel.text = "月"
        monLabel.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.45, width: labelWidth, height: labelHeight)
        monLabel.textColor = UIColor.gray
        self.view.addSubview(monLabel)
        
        //火曜ボタン
        if tueStatus == on{
            tueCheckButton.setImage(check, for: .normal)
        }else{
            tueCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        tueCheckButton.tintColor = UIColor.gray  //画像の色を設定
        tueCheckButton.frame = CGRect(x: myBoundSize.width * 0.3, y: myBoundSize.height * 0.45, width: buttonWidth, height: buttonHeight)
        let tueLabel = UILabel()
        tueLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        tueLabel.text = "火"
        tueLabel.frame = CGRect(x: myBoundSize.width * 0.25, y: myBoundSize.height * 0.45, width: labelWidth, height: labelHeight)
        tueLabel.textColor = UIColor.gray
        self.view.addSubview(tueLabel)
        
        //水曜ボタン
        if wedStatus == on{
            wedCheckButton.setImage(check, for: .normal)
        }else{
            wedCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        wedCheckButton.tintColor = UIColor.gray  //画像の色を設定
        wedCheckButton.frame = CGRect(x: myBoundSize.width * 0.5, y: myBoundSize.height * 0.45, width: buttonWidth, height: buttonHeight)
        let wedLabel = UILabel()
        wedLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        wedLabel.text = "水"
        wedLabel.frame = CGRect(x: myBoundSize.width * 0.45, y: myBoundSize.height * 0.45, width: labelWidth, height: labelHeight)
        wedLabel.textColor = UIColor.gray
        self.view.addSubview(wedLabel)
        
        //木曜ボタン
        if thuStatus == on{
            thuCheckButton.setImage(check, for: .normal)
        }else{
            thuCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
    
        thuCheckButton.tintColor = UIColor.gray  //画像の色を設定
        thuCheckButton.frame = CGRect(x: myBoundSize.width * 0.7, y: myBoundSize.height * 0.45, width: buttonWidth, height: buttonHeight)
        let thuLabel = UILabel()
        thuLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        thuLabel.text = "木"
        thuLabel.frame = CGRect(x: myBoundSize.width * 0.65, y: myBoundSize.height * 0.45, width: labelWidth, height: labelHeight)
        thuLabel.textColor = UIColor.gray
        self.view.addSubview(thuLabel)
        
        //金曜ボタン
        if friStatus == on{
            friCheckButton.setImage(check, for: .normal)
        }else{
            friCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        friCheckButton.tintColor = UIColor.gray  //画像の色を設定
        friCheckButton.frame = CGRect(x: myBoundSize.width * 0.9, y: myBoundSize.height * 0.45, width: buttonWidth, height: buttonHeight)
        let friLabel = UILabel()
        friLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        friLabel.text = "金"
        friLabel.frame = CGRect(x: myBoundSize.width * 0.85, y: myBoundSize.height * 0.45, width: labelWidth, height: labelHeight)
        friLabel.textColor = UIColor.gray
        self.view.addSubview(friLabel)
        
        //土曜ボタン
        if satStatus == on{
            satCheckButton.setImage(check, for: .normal)
        }else{
            satCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        satCheckButton.tintColor = UIColor.gray  //画像の色を設定
        satCheckButton.frame = CGRect(x: myBoundSize.width * 0.35, y: myBoundSize.height * 0.5, width: buttonWidth, height: buttonHeight)
        let satLabel = UILabel()
        satLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        satLabel.text = "土"
        satLabel.frame = CGRect(x: myBoundSize.width * 0.3, y: myBoundSize.height * 0.5, width: labelWidth, height: labelHeight)
        satLabel.textColor = UIColor.gray
        self.view.addSubview(satLabel)
        
        
        //日曜ボタン
        if sunStatus == on{
            sunCheckButton.setImage(check, for: .normal)
        }else{
            sunCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        sunCheckButton.tintColor = UIColor.gray  //画像の色を設定
        sunCheckButton.frame = CGRect(x: myBoundSize.width * 0.6, y: myBoundSize.height * 0.5, width: buttonWidth, height: buttonHeight)
        let sunLabel = UILabel()
        sunLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        sunLabel.text = "日"
        sunLabel.frame = CGRect(x: myBoundSize.width * 0.55, y: myBoundSize.height * 0.5, width: labelWidth, height: labelHeight)
        sunLabel.textColor = UIColor.gray
        self.view.addSubview(sunLabel)
        
        //allボタン
        if allStatus == on{
            allCheckButton.setImage(check, for: .normal)
        }else{
            allCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        allCheckButton.tintColor = UIColor.gray  //画像の色を設定
        allCheckButton.frame = CGRect(x: myBoundSize.width * 0.3, y: myBoundSize.height * 0.38, width: buttonWidth, height: buttonHeight)
        let allLabel = UILabel()
        allLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        allLabel.text = "毎日"
        allLabel.frame = CGRect(x: myBoundSize.width * 0.2, y: myBoundSize.height * 0.38, width: labelWidth2, height: labelHeight)
        allLabel.textColor = UIColor.gray
        self.view.addSubview(allLabel)
        
        //1回ボタン
        if onlyStatus == on{
            onlyCheckButton.setImage(check, for: .normal)
        }else{
            onlyCheckButton.setImage(noCheck, for: .normal)// 画像を設定
        }
        onlyCheckButton.tintColor = UIColor.gray  //画像の色を設定
        onlyCheckButton.frame = CGRect(x: myBoundSize.width * 0.7, y: myBoundSize.height * 0.38, width: buttonWidth, height: buttonHeight)
        let onlyLabel = UILabel()
        onlyLabel.font = UIFont.boldSystemFont(ofSize: labelFont)
        onlyLabel.text = "1回"
        onlyLabel.frame = CGRect(x: myBoundSize.width * 0.62, y: myBoundSize.height * 0.38, width: labelWidth2, height: labelHeight)
        onlyLabel.textColor = UIColor.gray
        self.view.addSubview(onlyLabel)
        
        //labelの表示を初期化
       
        
        
       
//        let cal = Calendar(identifier: .gregorian)
//        // 現在日時を dt に代入
//         let aaa = alarmResult!.alarm
//        // 8時間後を求める（60秒 × 60分 × 8時間)
//        let bbb = Date()
//
//        // dt2 - dt1 を計算
//        let diff1 = cal.dateComponents([.hour], from: bbb, to: aaa)
//        let diff11 = cal.dateComponents([.minute], from: bbb, to: aaa)
//        let diff111 = cal.dateComponents([.second], from: bbb, to: aaa)
//        // dt1 - dt2 を計算
////        let diff2 = cal.dateComponents([.hour], from: bbb, to: aaa)
//
//        print(aaa)
//        print(bbb)
//        print("差は \(diff1.hour!) 時間")
//        print("差は \(diff11.minute!) 分")
//        print("差は \(diff111.second!) 秒")
//
////        print("差は \(diff2.hour!) 時間")秒
//
//        // 書式を設定する
//        let formatter = DateComponentsFormatter()
//        // 表示単位を指定
//        formatter.unitsStyle = .positional
//        // 表示する時間単位を指定
//        formatter.allowedUnits = [.hour, .minute, .second]
//
//        // 設定した書式にしたがって表示
//        print(formatter.string(from: diff111)!)
//
        
        
        
        alarmHour = 3
        alarmMin = 3
        alarmSec = 3
        countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
        //1秒ごとに時間をtimerメソッドを呼び出す。
//        Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(timer) , userInfo: nil, repeats: false)
        
        
        
        // Do any additional setup after loading the view.
    }
    //毎日ボタンのアクション
    @IBAction func allActionButton(_ sender: Any) {
        
        if let num = allStatus{
            if num == on{
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                allCheckButton.setImage(check, for: .normal)
                allStatus = on
                
                monCheckButton.setImage(check, for: .normal)
                monStatus = on
                
                tueCheckButton.setImage(check, for: .normal)
                tueStatus = on
                
                wedCheckButton.setImage(check, for: .normal)
                wedStatus = on
                
                thuCheckButton.setImage(check, for: .normal)
                thuStatus = on
                
                friCheckButton.setImage(check, for: .normal)
                friStatus = on
                
                satCheckButton.setImage(check, for: .normal)
                satStatus = on
                
                sunCheckButton.setImage(check, for: .normal)
                sunStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
                
            }
        }else{
            allCheckButton.setImage(check, for: .normal)
            allStatus = on
            
            monCheckButton.setImage(check, for: .normal)
            monStatus = on
            
            tueCheckButton.setImage(check, for: .normal)
            tueStatus = on
            
            wedCheckButton.setImage(check, for: .normal)
            wedStatus = on
            
            thuCheckButton.setImage(check, for: .normal)
            thuStatus = on
            
            friCheckButton.setImage(check, for: .normal)
            friStatus = on
            
            satCheckButton.setImage(check, for: .normal)
            satStatus = on
            
            sunCheckButton.setImage(check, for: .normal)
            sunStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //一日ボタンのアクション
    @IBAction func onlyActionButton(_ sender: Any) {
        if let num = onlyStatus{
            if num == on{
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }else{
                onlyCheckButton.setImage(check, for: .normal)
                onlyStatus = on
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
                
                monCheckButton.setImage(noCheck, for: .normal)
                monStatus = off
                
                tueCheckButton.setImage(noCheck, for: .normal)
                tueStatus = off
                
                wedCheckButton.setImage(noCheck, for: .normal)
                wedStatus = off
                
                thuCheckButton.setImage(noCheck, for: .normal)
                thuStatus = off
                
                friCheckButton.setImage(noCheck, for: .normal)
                friStatus = off
                
                satCheckButton.setImage(noCheck, for: .normal)
                satStatus = off
                
                sunCheckButton.setImage(noCheck, for: .normal)
                sunStatus = off
            }
        }else{
            onlyCheckButton.setImage(check, for: .normal)
            onlyStatus = on
            
            allCheckButton.setImage(noCheck, for: .normal)
            allStatus = off
            
            monCheckButton.setImage(noCheck, for: .normal)
            monStatus = off
           
            tueCheckButton.setImage(noCheck, for: .normal)
            tueStatus = off
           
            wedCheckButton.setImage(noCheck, for: .normal)
            wedStatus = off
           
            thuCheckButton.setImage(noCheck, for: .normal)
            thuStatus = off
           
            friCheckButton.setImage(noCheck, for: .normal)
            friStatus = off
           
            satCheckButton.setImage(noCheck, for: .normal)
            satStatus = off
           
            sunCheckButton.setImage(noCheck, for: .normal)
            sunStatus = off
        }
    }
    
    //月曜ボタンのアクション
    @IBAction func monActionButton(_ sender: Any) {
        if let num = monStatus{
            if num == on{
                monCheckButton.setImage(noCheck, for: .normal)
                monStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                monCheckButton.setImage(check, for: .normal)
                monStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            monCheckButton.setImage(check, for: .normal)
            monStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //火曜ボタンのアクション
    @IBAction func tueActionButton(_ sender: Any) {
        if let num = tueStatus{
            if num == on{
                tueCheckButton.setImage(noCheck, for: .normal)
                tueStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                tueCheckButton.setImage(check, for: .normal)
                tueStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            tueCheckButton.setImage(check, for: .normal)
            tueStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //水曜ボタンのアクション
    @IBAction func wedActionButton(_ sender: Any) {
        if let num = wedStatus{
            if num == on{
                wedCheckButton.setImage(noCheck, for: .normal)
                wedStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                wedCheckButton.setImage(check, for: .normal)
                wedStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            wedCheckButton.setImage(check, for: .normal)
            wedStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //木曜ボタンのアクション
    @IBAction func thuActionButton(_ sender: Any) {
        if let num = thuStatus{
            if num == on{
                thuCheckButton.setImage(noCheck, for: .normal)
                thuStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                thuCheckButton.setImage(check, for: .normal)
                thuStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            thuCheckButton.setImage(check, for: .normal)
            thuStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //金曜ボタンのアクション
    @IBAction func friActionButton(_ sender: Any) {
        if let num = friStatus{
            if num == on{
                friCheckButton.setImage(noCheck, for: .normal)
                friStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                friCheckButton.setImage(check, for: .normal)
                friStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            friCheckButton.setImage(check, for: .normal)
            friStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //土曜ボタンのアクション
    @IBAction func satActionButton(_ sender: Any) {
        if let num = satStatus{
            if num == on{
                satCheckButton.setImage(noCheck, for: .normal)
                satStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                satCheckButton.setImage(check, for: .normal)
                satStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            satCheckButton.setImage(check, for: .normal)
            satStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    //日曜ボタンのアクション
    @IBAction func sunActionButton(_ sender: Any) {
        if let num = sunStatus{
            if num == on{
                sunCheckButton.setImage(noCheck, for: .normal)
                sunStatus = off
                
                allCheckButton.setImage(noCheck, for: .normal)
                allStatus = off
            }else{
                sunCheckButton.setImage(check, for: .normal)
                sunStatus = on
                
                onlyCheckButton.setImage(noCheck, for: .normal)
                onlyStatus = off
            }
        }else{
            sunCheckButton.setImage(check, for: .normal)
            sunStatus = on
            
            onlyCheckButton.setImage(noCheck, for: .normal)
            onlyStatus = off
        }
    }
    
    @IBAction func saveActionButton(_ sender: Any) {
        
        let alarmSetTommory:Date = SelectTime.selectTimeTomorrow(hour: selectedHour ?? 0, min: selectedMin ?? 0)
        let alarmSetToday:Date = SelectTime.selectTimeToday(hour: selectedHour ?? 0, min: selectedMin ?? 0)
        
        let date1 = Date()
        
        var alarmSet:Date?
        
        // NSDate（日時）の比較
        if ( date1.compare(alarmSetToday) == .orderedAscending ) {
            print("date1が前")
            alarmSet = alarmSetToday
        }
        else if ( date1.compare(alarmSetToday) == .orderedSame ) {
            alarmSet = alarmSetToday
        }
        else {
            print("date1が後")
            alarmSet = alarmSetTommory
        }
        
        print(alarmSet)
         
        
        let realm = try! Realm()
        
        let alarmResult = realm.objects(Alarm.self).first
        
        if let status = alarmResult{
            try! realm.write {
                status.alarm = alarmSet ?? Date()
                status.all = allStatus ?? 0
                status.mon = monStatus ?? 0
                status.tue = tueStatus ?? 0
                status.wed = wedStatus ?? 0
                status.thu = thuStatus ?? 0
                status.fri = friStatus ?? 0
                status.sat = satStatus ?? 0
                status.sun = sunStatus ?? 0
                status.only = onlyStatus ?? 0
            }
        }else{
            let alarm = Alarm()
            alarm.id = 1
            alarm.alarm = alarmSet ?? Date()
            alarm.all = allStatus ?? 0
            alarm.mon = monStatus ?? 0
            alarm.tue = tueStatus ?? 0
            alarm.wed = wedStatus ?? 0
            alarm.thu = thuStatus ?? 0
            alarm.fri = friStatus ?? 0
            alarm.sat = satStatus ?? 0
            alarm.sun = sunStatus ?? 0
            alarm.only = onlyStatus ?? 0
            alarm.createAt = Date()
            
            try! realm.write {
                realm.add(alarm)
            }
            
            
        }
        let cal = Calendar(identifier: .gregorian)
        // 現在日時を dt に代入
        let setTime = alarmResult!.alarm
        // 8時間後を求める（60秒 × 60分 × 8時間)
        let nowTime = Date()

        // setTime - nowTime を計算
        let diff = cal.dateComponents([.second], from: nowTime, to: setTime)
        
        // 書式を設定する
        let formatter = DateComponentsFormatter()
        // 表示単位を指定
        formatter.unitsStyle = .positional
        // 表示する時間単位を指定
        formatter.allowedUnits = [.hour, .minute, .second]
        // 設定した書式にしたがって表示
        let diffTime = formatter.string(from: diff)!
        
        print(diffTime)
    
        if diffTime.count == 8{
            alarmHour = Int(String(diffTime.prefix(2)))!
            alarmMin = Int(String(diffTime[diffTime.index(diffTime.startIndex, offsetBy: 3)..<diffTime.index(diffTime.startIndex, offsetBy: 5)]))!
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 7{
            alarmHour = Int(String(diffTime.prefix(1)))!
            alarmMin = Int(String(diffTime[diffTime.index(diffTime.startIndex, offsetBy: 2)..<diffTime.index(diffTime.startIndex, offsetBy: 4)]))!
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 5{
            alarmHour = 0
            alarmMin = Int(String(diffTime.prefix(2)))!
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 4{
            alarmHour = 0
            alarmMin = Int(String(diffTime.prefix(1)))!
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 2{
            alarmHour = 0
            alarmMin = 0
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 1{
            alarmHour = 0
            alarmMin = 0
            alarmSec = Int(String(diffTime.suffix(1)))!
        }
        
        print(alarmHour)
        print(alarmMin)
        print(alarmSec)
        
        countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
        
        if let aa = countDown{
            aa.invalidate()
        }
        
        //1秒ごとに時間をtimerメソッドを呼び出す。
        countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
        
    
    }
    
    @objc func timer(){
        if (alarmHour == 0 && alarmMin == 0 && alarmSec == 0) {
            countTime.text = "終了"
        } else {
            if alarmSec > 0 {
                //秒数が0以上の時秒数を-1
                alarmSec -= 1
            } else {
                //秒数が0の時
                alarmSec += 59
                if alarmMin > 0 {
                    //分が0以上の時、分を-1
                    alarmMin -= 1
                } else {
                    //分が０の時、+59分、時間-1
                    alarmMin += 59
                    alarmHour -= 1
                }
            }
        
            countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
        }
    }

}

