//
//  FirstViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/24.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import GoogleMobileAds

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, GADBannerViewDelegate {
    
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
        
        //pickerで合わせた時間を保存しておく
        let realm = try! Realm()
        let selectedTimeResult = realm.objects(SelectedTime.self).first
        if let selected = selectedTimeResult{
            try! realm.write {
                selected.hour = selectedHour!
                selected.minutes = selectedMin!
            }
        }else{
            let selected = SelectedTime()
            selected.hour = selectedHour!
            selected.minutes = selectedMin!

            try! realm.write {
                realm.add(selected)
            }
        }
    }
    
    @IBOutlet weak var countTime: UILabel!
    @IBOutlet weak var caution: UILabel!
    
    var alarmHour:Int = 1
    var alarmMin:Int = 1
    var alarmSec:Int = 1
    //timerの時間(1時間,10分,10秒)
    var time: [Int] = [1,10,10]
    var countDown:Timer?
    
    var push:UNUserNotificationCenter?
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    @IBOutlet weak var snoozeButton: UIButton!
    
    //位置情報を取得する
    var locationManager: CLLocationManager!
    
    //バナー広告
    var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        timePickerView.frame = CGRect(x: 0, y: myBoundSize.height * 0.1, width: myBoundSize.width, height: myBoundSize.height * 0.25)
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        let realm = try! Realm()
        
        let alarmResult = realm.objects(Alarm.self).first
        var setTime:Date?
        
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
            setTime = status.alarm
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
            setTime = nil
            
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
        
        caution.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.725, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.1)
        
        countTime.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.7, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.1)
        if setTime == nil{
            alarmHour = 0
            alarmMin = 0
            alarmSec = 0
            countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
        }else{
            let cal = Calendar(identifier: .gregorian)
            let nowTime = Date()
            if setTime! < nowTime{
                //まずは、同じstororyboard内であることをここで定義します
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let second = storyboard.instantiateViewController(withIdentifier: "come")
                //ここが実際に移動するコードとなります
                second.modalPresentationStyle = .fullScreen
                self.present(second, animated: true, completion: nil)
                
            }else{
                // setTime - nowTime を計算
                let diff = cal.dateComponents([.second], from: nowTime, to: setTime!)
                
                // 書式を設定する
                let formatter = DateComponentsFormatter()
                // 表示単位を指定
                formatter.unitsStyle = .positional
                // 表示する時間単位を指定
                formatter.allowedUnits = [.hour, .minute, .second]
                // 設定した書式にしたがって表示
                let diffTime = formatter.string(from: diff)!
                
                if diffTime.count == 9{
                    alarmHour = Int(String(diffTime.prefix(3)))!
                    alarmMin = Int(String(diffTime[diffTime.index(diffTime.startIndex, offsetBy: 4)..<diffTime.index(diffTime.startIndex, offsetBy: 6)]))!
                    alarmSec = Int(String(diffTime.suffix(2)))!
                }else if diffTime.count == 8{
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
                countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
                if let aa = countDown{
                    aa.invalidate()
                }
                //1秒ごとに時間をtimerメソッドを呼び出す。
                countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
            }
            
        }
        
        
        //pickerの初期値
        var initialHour:Int?
        var initialMin:Int?
        
        let selectedTimeResult = realm.objects(SelectedTime.self).first
        if let selected = selectedTimeResult{
            initialHour = selected.hour
            initialMin = selected.minutes
        }else{
            initialHour = 0
            initialMin = 0
        }
        
        //pickerの初期値
        timePickerView.selectRow(initialHour!, inComponent: 0, animated: true)
        timePickerView.selectRow(initialMin!, inComponent: 1, animated: true)
        
        //保存ボタンの設定
        saveButton.setTitle("保　存", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)// タイトルの色
        saveButton.backgroundColor = UIColor.mainGreen// ボタンの色
        
        saveButton.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.55, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.05)
        
        //リセットボタンの設定
        resetButton.setTitleColor(UIColor.white, for: .normal)// タイトルの色
        resetButton.backgroundColor = UIColor.mainYellow// ボタンの色
        
        resetButton.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.62, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.03)
        
        snoozeButton.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.8, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.03)
        
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1566808571626806/1769336227"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    
        
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 登録
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidEnterBackground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // AppDelegate -> applicationWillEnterForegroundの通知
    @objc func viewWillEnterForeground(notification: Notification) {
        print("フォアグラウンド")
        loadView()
        viewDidLoad()
    }

    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func viewDidEnterBackground(notification: Notification) {
        print("バックグラウンド")
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
        
        if onlyStatus == 0 && monStatus == 0 && tueStatus == 0 && wedStatus == 0 && thuStatus == 0 && friStatus == 0 && satStatus == 0 && sunStatus == 0{
            let alert: UIAlertController = UIAlertController(title: "チェックしてください", message: nil, preferredStyle:  UIAlertController.Style.alert)
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                
            })
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        //pickerの初期値
        var initialHour:Int?
        var initialMin:Int?
        
        let realm = try! Realm()
        let selectedTimeResult = realm.objects(SelectedTime.self).first
        if let selected = selectedTimeResult{
            initialHour = selected.hour
            initialMin = selected.minutes
        }else{
            initialHour = 0
            initialMin = 0
        }
    
        //時間をセットして、今日の日にちをとってくる
        let alarmSetToday:Date = SelectTime.selectTimeToday(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        //時間をセットして、明日の日にちをとってくる
        let alarmSetTommory:Date = SelectTime.selectTimeTomorrow(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetTwoAf:Date = SelectTime.selectTimeTwoAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetThreeAf:Date = SelectTime.selectTimeThreeAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetFourAf:Date = SelectTime.selectTimeFourAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetFiveAf:Date = SelectTime.selectTimeFiveAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetSixAf:Date = SelectTime.selectTimeSixAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        let alarmSetSevenAf:Date = SelectTime.selectTimeSevenAf(hour: selectedHour ?? initialHour!, min: selectedMin ?? initialMin!)
        
        
        
        //比較用に現在時刻を獲得
        let date1 = Date()
        //変数alarmsSetを用意
        var alarmSet:Date?
        //設定日を用意しておく
        var settingDate:Date?
        
        let settingDateToday = Calendar.current.date(byAdding: .day, value: 0, to: date1 )!
        let settingDateOne = Calendar.current.date(byAdding: .day, value: 1, to: date1 )!
        let settingDateTwo = Calendar.current.date(byAdding: .day, value: 2, to: date1 )!
        let settingDateThree = Calendar.current.date(byAdding: .day, value: 3, to: date1 )!
        let settingDateFour = Calendar.current.date(byAdding: .day, value: 4, to: date1 )!
        let settingDateFive = Calendar.current.date(byAdding: .day, value: 5, to: date1 )!
        let settingDateSix = Calendar.current.date(byAdding: .day, value: 6, to: date1 )!
        let settingDateSeven = Calendar.current.date(byAdding: .day, value: 7, to: date1 )!
        
        let dayOfWeekToday = DateFormatter()
        dayOfWeekToday.dateFormat = DateFormatter.dateFormat(fromTemplate: "E", options: 1, locale: Locale.current)
       
        if dayOfWeekToday.string(from: Date()) == "Mon"{
            if alarmSetToday > date1{
                if monStatus == 1{
                    alarmSet = alarmSetToday
                    settingDate = settingDateToday
                }else{
                    if tueStatus == 1{
                        alarmSet = alarmSetTommory
                        settingDate = settingDateOne
                    }else{
                        if wedStatus == 1{
                            alarmSet = alarmSetTwoAf
                            settingDate = settingDateTwo
                        }else{
                            if thuStatus == 1{
                                alarmSet = alarmSetThreeAf
                                settingDate = settingDateThree
                            }else{
                                if friStatus == 1{
                                    alarmSet = alarmSetFourAf
                                    settingDate = settingDateFour
                                }else{
                                    if satStatus == 1{
                                        alarmSet = alarmSetFiveAf
                                        settingDate = settingDateFive
                                    }else{
                                        if sunStatus == 1{
                                            alarmSet = alarmSetSixAf
                                            settingDate = settingDateSix
                                            }}}}}}}
                }else{
                if tueStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if wedStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if thuStatus == 1{
                           alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if friStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if satStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if sunStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                    }else{
                                        if monStatus == 1{
                                            alarmSet = alarmSetSevenAf
                                            settingDate = settingDateSeven
                                        }}}}}}}}
        }else if dayOfWeekToday.string(from: Date()) == "Tue"{
            if alarmSetToday > date1{
            if tueStatus == 1{
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                if wedStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if thuStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if friStatus == 1{
                            alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if satStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if sunStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if monStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                        }}}}}}}
            }else{
            if wedStatus == 1{
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }else{
                if thuStatus == 1{
                    alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                }else{
                    if friStatus == 1{
                       alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                    }else{
                        if satStatus == 1{
                            alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                        }else{
                            if sunStatus == 1{
                                alarmSet = alarmSetFiveAf
                                settingDate = settingDateFive
                            }else{
                                if monStatus == 1{
                                    alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                }else{
                                    if tueStatus == 1{
                                        alarmSet = alarmSetSevenAf
                                        settingDate = settingDateSeven
                                    }}}}}}}}
            print("火曜だ")
        }else if dayOfWeekToday.string(from: Date()) == "Wed"{
            if alarmSetToday > date1{
            if wedStatus == 1{
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                if thuStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if friStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if satStatus == 1{
                            alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if sunStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if monStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if tueStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                        }}}}}}}
            }else{
            if thuStatus == 1{
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }else{
                if friStatus == 1{
                    alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                }else{
                    if satStatus == 1{
                       alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                    }else{
                        if sunStatus == 1{
                            alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                        }else{
                            if monStatus == 1{
                                alarmSet = alarmSetFiveAf
                                settingDate = settingDateFive
                            }else{
                                if tueStatus == 1{
                                    alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                }else{
                                    if wedStatus == 1{
                                        alarmSet = alarmSetSevenAf
                                        settingDate = settingDateSeven
                                    }}}}}}}}
            print("水だ")
        }else if dayOfWeekToday.string(from: Date()) == "Thu"{
            if alarmSetToday > date1{
            if thuStatus == 1{
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                if friStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if satStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if sunStatus == 1{
                            alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if monStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if tueStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if wedStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                        }}}}}}}
            }else{
            if friStatus == 1{
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }else{
                if satStatus == 1{
                    alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                }else{
                    if sunStatus == 1{
                       alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                    }else{
                        if monStatus == 1{
                            alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                        }else{
                            if tueStatus == 1{
                                alarmSet = alarmSetFiveAf
                                settingDate = settingDateFive
                            }else{
                                if wedStatus == 1{
                                    alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                }else{
                                    if thuStatus == 1{
                                        alarmSet = alarmSetSevenAf
                                        settingDate = settingDateSeven
                                    }}}}}}}}

            print("木だ")
        }else if dayOfWeekToday.string(from: Date()) == "Fri"{
            if alarmSetToday > date1{
            if friStatus == 1{
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                if satStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if sunStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if monStatus == 1{
                            alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if tueStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if wedStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if thuStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                        }}}}}}}
            }else{
            if satStatus == 1{
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }else{
                if sunStatus == 1{
                    alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                }else{
                    if monStatus == 1{
                       alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                    }else{
                        if tueStatus == 1{
                            alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                        }else{
                            if wedStatus == 1{
                                alarmSet = alarmSetFiveAf
                                settingDate = settingDateFive
                            }else{
                                if thuStatus == 1{
                                    alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                }else{
                                    if friStatus == 1{
                                        alarmSet = alarmSetSevenAf
                                        settingDate = settingDateSeven
                                    }}}}}}}}
            print("金だ")
        }else if dayOfWeekToday.string(from: Date()) == "Sat"{
            if alarmSetToday > date1{
            if satStatus == 1{
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                if sunStatus == 1{
                    alarmSet = alarmSetTommory
                    settingDate = settingDateOne
                }else{
                    if monStatus == 1{
                        alarmSet = alarmSetTwoAf
                        settingDate = settingDateTwo
                    }else{
                        if tueStatus == 1{
                            alarmSet = alarmSetThreeAf
                            settingDate = settingDateThree
                        }else{
                            if wedStatus == 1{
                                alarmSet = alarmSetFourAf
                                settingDate = settingDateFour
                            }else{
                                if thuStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    settingDate = settingDateFive
                                }else{
                                    if friStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        settingDate = settingDateSix
                                        }}}}}}}
            }else{
            if sunStatus == 1{
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }else{
                if monStatus == 1{
                    alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                }else{
                    if tueStatus == 1{
                       alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                    }else{
                        if wedStatus == 1{
                            alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                        }else{
                            if thuStatus == 1{
                                alarmSet = alarmSetFiveAf
                                settingDate = settingDateFive
                            }else{
                                if friStatus == 1{
                                    alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                }else{
                                    if satStatus == 1{
                                        alarmSet = alarmSetSevenAf
                                        settingDate = settingDateSeven
                                    }}}}}}}}
            print("土だ")
        }else{
           if alarmSetToday > date1{
           if sunStatus == 1{
               alarmSet = alarmSetToday
            settingDate = settingDateToday
           }else{
               if monStatus == 1{
                   alarmSet = alarmSetTommory
                settingDate = settingDateOne
               }else{
                   if tueStatus == 1{
                       alarmSet = alarmSetTwoAf
                    settingDate = settingDateTwo
                   }else{
                       if wedStatus == 1{
                           alarmSet = alarmSetThreeAf
                        settingDate = settingDateThree
                       }else{
                           if thuStatus == 1{
                               alarmSet = alarmSetFourAf
                            settingDate = settingDateFour
                           }else{
                               if friStatus == 1{
                                   alarmSet = alarmSetFiveAf
                                   settingDate = settingDateFive
                               }else{
                                   if satStatus == 1{
                                       alarmSet = alarmSetSixAf
                                    settingDate = settingDateSix
                                       }}}}}}}
           }else{
           if monStatus == 1{
               alarmSet = alarmSetTommory
            settingDate = settingDateOne
           }else{
               if tueStatus == 1{
                   alarmSet = alarmSetTwoAf
                settingDate = settingDateTwo
               }else{
                   if wedStatus == 1{
                      alarmSet = alarmSetThreeAf
                    settingDate = settingDateThree
                   }else{
                       if thuStatus == 1{
                           alarmSet = alarmSetFourAf
                        settingDate = settingDateFour
                       }else{
                           if friStatus == 1{
                               alarmSet = alarmSetFiveAf
                            settingDate = settingDateFive
                           }else{
                               if satStatus == 1{
                                   alarmSet = alarmSetSixAf
                                settingDate = settingDateSix
                               }else{
                                   if sunStatus == 1{
                                       alarmSet = alarmSetSevenAf
                                    settingDate = settingDateSeven
                                   }}}}}}}}
            print("日だ")
        }
       
        if alarmSet == nil{
            if ( date1.compare(alarmSetToday) == .orderedAscending ) {
                print("date1が前")
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else if ( date1.compare(alarmSetToday) == .orderedSame ) {
                alarmSet = alarmSetToday
                settingDate = settingDateToday
            }else{
                print("date1が後")
                alarmSet = alarmSetTommory
                settingDate = settingDateOne
            }
        }
       
        let alarmResult = realm.objects(Alarm.self).first
        
        //alarmResults があれば上書きし、なければ新規作成
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
        var setTime:Date
        if let aa = alarmResult{
            setTime = aa.alarm
        }else{
            setTime = alarmSet!
        }
        
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
        
        if diffTime.count == 9{
            alarmHour = Int(String(diffTime.prefix(3)))!
            alarmMin = Int(String(diffTime[diffTime.index(diffTime.startIndex, offsetBy: 4)..<diffTime.index(diffTime.startIndex, offsetBy: 6)]))!
            alarmSec = Int(String(diffTime.suffix(2)))!
        }else if diffTime.count == 8{
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
        
        countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)
        
        if let aa = countDown{
            aa.invalidate()
        }
        
        //1秒ごとに時間をtimerメソッドを呼び出す。
        countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let LotteryNo = LotterySet.LotteryNo(settingDate:settingDate!)
        print(LotteryNo)
        
        //------ローカルプッシュの設定↓
        for i in 0...63 {
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            var notificationTime = DateComponents()
            
            
            let modifiedAlarmSet = Calendar.current.date(byAdding: .minute, value: i, to: alarmSet!)!
            

            // DateFormatter のインスタンスを作成
            let alarmSetJpYear = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpYear.locale = Locale(identifier: "ja_JP")
            alarmSetJpYear.setTemplate(.year)
            
            let alarmSetJpMonth = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpMonth.locale = Locale(identifier: "ja_JP")
            alarmSetJpMonth.setTemplate(.month)
            
            let alarmSetJpDay = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpDay.locale = Locale(identifier: "ja_JP")
            alarmSetJpDay.setTemplate(.day)
            
            let alarmSetJpHour = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpHour.locale = Locale(identifier: "ja_JP")
            alarmSetJpHour.setTemplate(.hour)
            
            let alarmSetJpMin = DateFormatter()
            // ロケールを日本（日本語）に設定
            alarmSetJpMin.locale = Locale(identifier: "ja_JP")
            alarmSetJpMin.setTemplate(.min)
            
            notificationTime.year = Int(alarmSetJpYear.string(from: modifiedAlarmSet))
            notificationTime.month = Int(alarmSetJpMonth.string(from: modifiedAlarmSet))
            notificationTime.day = Int(alarmSetJpDay.string(from: modifiedAlarmSet))
            notificationTime.hour = Int(alarmSetJpHour.string(from: modifiedAlarmSet))
            notificationTime.minute = Int(alarmSetJpMin.string(from: modifiedAlarmSet))
            
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
            
            // 通知内容の設定
            if i == 0{
                content.title = "起きる時間ですよ"
                content.body = "アプリを開いて今日のおみくじ結果と天気を確認しよう"
            }else{
                content.title = "アラームが設定されています"
                content.body = "今日のおみくじ結果と天気を確認しよう"
            }
            switch LotteryNo{
            case 1:
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "oneMusic.mp3"))
            case 2:
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "twoMusic.mp3"))
            case 3:
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "threeMusic.mp3"))
            case 4:
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "fourMusic.mp3"))
            default:
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "fiveMusic.mp3"))
            }
            
            
        
            // 通知スタイルを指定
            let request = UNNotificationRequest(identifier: "identifier-\(i)", content: content, trigger: trigger)
            // 通知をセット
            
            push = UNUserNotificationCenter.current()
            push!.add(request, withCompletionHandler: nil)
        }
        //------ローカルプッシュの設定↑
        
    
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
        let realm = try! Realm()
        let alarm = realm.objects(Alarm.self)
        try! realm.write {
            realm.delete(alarm)
            
        }
        alarmHour = 0
        alarmMin = 0
        alarmSec = 0
        countTime.text = String(format: "%02d", alarmHour) + ":" + String(format: "%02d", alarmMin) + ":" + String(format: "%02d", alarmSec)

        if let aa = countDown{
            aa.invalidate()
        }
        let center = UNUserNotificationCenter.current()
        
        print(center)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
    }
    
    @objc func timer(){
        if (alarmHour == 0 && alarmMin == 0 && alarmSec == 0) {
            countTime.text = "終了"
            //まずは、同じstororyboard内であることをここで定義します
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let second = storyboard.instantiateViewController(withIdentifier: "come")
            //ここが実際に移動するコードとなります
            second.modalPresentationStyle = .fullScreen
            self.present(second, animated: true, completion: nil)
            if let aa = countDown{
                aa.invalidate()
            }
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
    
    
     
    // 完全に全ての読み込みが完了時に実行
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    @IBAction func snoozeAction(_ sender: Any) {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "snooze")
        //ここが実際に移動するコードとなります
       
        self.present(second, animated: true, completion: nil)
    }
    
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }

        locationManager.requestWhenInUseAuthorization()
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

