//
//  ComeViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/05.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class ComeViewController: UIViewController, CLLocationManagerDelegate, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    
    //端末のサイズを取得
    let myBoundSize: CGSize = UIScreen.main.bounds.size

    var fade_timer = Timer()
   
    @IBOutlet weak var omikujiImage: UIImageView!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var snoozeButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    @IBOutlet weak var offLabel: UILabel!
    
    @IBOutlet weak var offView: UIImageView!
    
  
    
    
    let apiKey = "2ce4a1fedd40fd6894cc7da923a14180"
    var lat = 26.8205
    var lon = 30.8024

    
    
    let geocoder = CLGeocoder()
    
    var idoData:Double?
    var keidoData:Double?
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        
        disabledLocationLabel()
      
        // use popup to check and get location
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        
        
        // テンプレートから時刻を表示
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let todayStart = calendar.startOfDay(for: today)
         
        let realm = try! Realm()
        let todayData = realm.objects(Lottery.self).filter("lotteryDate == %@", todayStart).first
        
        if let lotteryNo = todayData{
            switch lotteryNo.lottery{
            case 1:
                omikujiImage.image = UIImage(named: "omikuji_daikichi1")
            case 2:
                omikujiImage.image = UIImage(named: "omikuji_kichi2")
            case 3:
                omikujiImage.image = UIImage(named: "omikuji_syoukichi3")
            case 4:
                omikujiImage.image = UIImage(named: "omikuji_kyou4")
            default:
                omikujiImage.image = UIImage(named: "omikuji_daikyou5")
            }
        }
        omikujiImage.center = CGPoint(x: myBoundSize.width * 0.25, y: myBoundSize.height * 0.6)
        
        conditionImageView.frame = CGRect(x: myBoundSize.width * 0.55, y: myBoundSize.height * 0.45, width: 100, height: 100)
        offView.frame = CGRect(x: myBoundSize.width * 0.55, y: myBoundSize.height * 0.45, width: 100, height: 100)
        offLabel.frame = CGRect(x: myBoundSize.width * 0.42, y: myBoundSize.height * 0.6, width: myBoundSize.width * 0.5, height: 100)
        
        temperatureLabel.frame = CGRect(x: myBoundSize.width * 0.42, y: myBoundSize.height * 0.58, width: myBoundSize.width * 0.5, height: 100)
        
        maxTempLabel.frame = CGRect(x: myBoundSize.width * 0.42, y: myBoundSize.height * 0.64, width: myBoundSize.width * 0.5, height: 100)
        
        minTempLabel.frame = CGRect(x: myBoundSize.width * 0.42, y: myBoundSize.height * 0.7, width: myBoundSize.width * 0.5, height: 100)
        
        
        if let wacthed = todayData{
            try! realm.write {
                wacthed.wacthed = 1
            }
        }
        
        
        //アニメーションの設定
        /* ラベルを透明にする */
        omikujiImage.alpha = 0.0
        /* タイマー実行 */
        fade_timer = Timer.scheduledTimer(
                            timeInterval: 0.1,
                            target: self,
                            selector: #selector(self.fade_in),
                            userInfo: nil,
                            repeats: true
                        )
        
        //停止ボタンの設定
        stopButton.setTitle("停　止", for: .normal)
        stopButton.setTitleColor(UIColor.white, for: .normal)// タイトルの色
        stopButton.backgroundColor = UIColor.mainGreen// ボタンの色
        
        stopButton.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.15, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.15)
        
        //スヌーズボタンの設定
        snoozeButton.setTitle("スヌーズ", for: .normal)
        snoozeButton.backgroundColor = UIColor.mainYellow// ボタンの色
        snoozeButton.frame = CGRect(x: myBoundSize.width * 0.05, y: myBoundSize.height * 0.32, width: myBoundSize.width * 0.9, height: myBoundSize.height * 0.05)
        
        
        
        
        let snoozeSet = realm.objects(SelectedSnooze.self).first
        if let snooze = snoozeSet{
            if snooze.snooze == 0{
                snoozeButton.isHidden = true
            }
        }else{
            snoozeButton.isHidden = true
        }
        
       
        print(idoData)
        print(keidoData)
        
        let myLocation = MyLocation()
        myLocation.reverseGeocode(lat: 35.653948476390205, lon: 139.73154725662124) { (placemarks) in
            if let data = placemarks.first {
            }
        }
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    /* 0.1秒毎に実行される関数 */
    @objc func fade_in() {
        omikujiImage.alpha += 0.05
        
        /* 透明度がなくなったらタイマーを止める */
        if (omikujiImage.alpha >= 1.0) {
            fade_timer.invalidate()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        
        let realm = try! Realm()
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
        
        //時間をセットして、今日の日にちをとってくる
        let alarmSetToday:Date = SelectTime.selectTimeToday(hour: initialHour!, min: initialMin!)
        //時間をセットして、明日の日にちをとってくる
        let alarmSetTommory:Date = SelectTime.selectTimeTomorrow(hour: initialHour!, min: initialMin!)
        let alarmSetTwoAf:Date = SelectTime.selectTimeTwoAf(hour: initialHour!, min: initialMin!)
        let alarmSetThreeAf:Date = SelectTime.selectTimeThreeAf(hour: initialHour!, min: initialMin!)
        let alarmSetFourAf:Date = SelectTime.selectTimeFourAf(hour: initialHour!, min: initialMin!)
        let alarmSetFiveAf:Date = SelectTime.selectTimeFiveAf(hour: initialHour!, min: initialMin!)
        let alarmSetSixAf:Date = SelectTime.selectTimeSixAf(hour: initialHour!, min: initialMin!)
        let alarmSetSevenAf:Date = SelectTime.selectTimeSevenAf(hour: initialHour!, min: initialMin!)
        
         let weekDayResult = realm.objects(Alarm.self).first
        
        var monStatus:Int?
        var tueStatus:Int?
        var wedStatus:Int?
        var thuStatus:Int?
        var friStatus:Int?
        var satStatus:Int?
        var sunStatus:Int?
        
        if let weekDay = weekDayResult{
            monStatus = weekDay.mon
            tueStatus = weekDay.tue
            wedStatus = weekDay.wed
            thuStatus = weekDay.thu
            friStatus = weekDay.fri
            satStatus = weekDay.sat
            sunStatus = weekDay.sun
        }else{
            monStatus = 0
            tueStatus = 0
            wedStatus = 0
            thuStatus = 0
            friStatus = 0
            satStatus = 0
            sunStatus = 0
        }
        
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
             let alarm = realm.objects(Alarm.self)
             try! realm.write {
                 realm.delete(alarm)
             }
         }else{
            try! realm.write {
                weekDayResult!.alarm = alarmSet ?? Date()
                
            }
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
         //------ローカルプッシュの設定↓
        if alarmSet != nil{
            let LotteryNo = LotterySet.LotteryNo(settingDate:settingDate!)
            for i in 0...60 {
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
                
                print(notificationTime)
                
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
                
                // 通知内容の設定
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
               UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            //------ローカルプッシュの設定↑
            
        }
         
        
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let second = storyboard.instantiateViewController(withIdentifier: "tab")
        //ここが実際に移動するコードとなります
        second.modalPresentationStyle = .fullScreen
        self.present(second, animated: true, completion: nil)
    }
    
    @IBAction func snoozeAction(_ sender: Any) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //------ローカルプッシュの設定↓
        let LotteryNo = LotterySet.LotteryNo(settingDate:Date())
        let realm = try! Realm()
        let selectedSnooze = realm.objects(SelectedSnooze.self).first
        
        var snooze:Int
        
        if let snoozeTime = selectedSnooze{
            snooze = snoozeTime.snooze
        }else{
            snooze = 3
        }
        
        for i in 0...60 {
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            var notificationTime = DateComponents()
            
            let time = i + snooze
               
            let modifiedAlarmSet = Calendar.current.date(byAdding: .minute, value: time, to: Date())!
              
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
               
            print(notificationTime)
               
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
               
            // 通知内容の設定
            // 通知内容の設定
            if i == 0{
                content.title = "スヌーズです"
                content.body = "アプリを開いて今日のおみくじ結果と天気を確認しよう"
            }else{
                content.title = "スヌーズが設定されています"
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
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       //------ローカルプッシュの設定↑
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.stopUpdatingLocation()
            disabledLocationLabel()
        default:
            locationManager.stopUpdatingLocation()
            disabledLocationLabel()
        }
    }
    
    func disabledLocationLabel(){
        
//        temperatureLabel.isHidden = true
//        maxTempLabel.isHidden = true
//        minTempLabel.isHidden = true
    }
    
    
    
    
//    var b:String?
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locationData = locations.last
//
//
//        if var ido = locationData?.coordinate.latitude{
//            ido = round(ido*1000000)/1000000
//            idoLabel.text = String(ido)
//            idoData = ido
//        }
//        print(idoData)
//
//        if var keido = locationData?.coordinate.longitude{
//            keido = round(keido*1000000)/1000000
//            keidoLabel.text = String(keido)
//            keidoData = keido
//        }
//
//        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
//
//            response in
//
//
//            if let responseStr = response.value {
//                let jsonResponse = JSON(responseStr)
//                let jsonWeather = jsonResponse["weather"].array![0]
//                let jsonTemp = jsonResponse["main"]
//                let iconName = jsonWeather["icon"].stringValue
//
////                self.locationLabel.text = jsonResponse["name"].stringValue
//                self.conditionImageView.image = UIImage(named: iconName)
////                self.conditionLabel.text = jsonWeather["main"].stringValue
//                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
//            }
//        }
//
//        //表示更新
//        if let location = locations.first {
//            //緯度・経度
//            idoLabel.text = location.coordinate.latitude.description
//            keidoLabel.text = location.coordinate.longitude.description
//
//            //逆ジオコーディング
//            geocoder.reverseGeocodeLocation( location, completionHandler: { ( placemarks, error ) in
//                if let placemark = placemarks?.first {
//                    //位置情報
//                    self.postal.text = placemark.postalCode
//
//                }
//            } )
//        }
//
//    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(location)
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        offLabel.isHidden = true
        offView.isHidden = true
        
        print(lat)
        print(lon)

        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {

            response in
          
            if let responseStr = response.value {
            
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue

//                self.locationLabel.text = jsonResponse["name"].stringValue
                
//                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "現在気温：" +  "\(Int(round(jsonTemp["temp"].doubleValue)))" + "℃"
                
                
                self.maxTempLabel.text = "最高気温：" +  "\(Int(round(jsonTemp["temp_max"].doubleValue)))" + "℃"
                self.minTempLabel.text = "最低気温：" +  "\(Int(round(jsonTemp["temp_min"].doubleValue)))" + "℃"
                
                print(jsonWeather["id"])
                
                if [803,804].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "broken clouds")
                }else if [200,201,202,210,211,212,221,230,231,232].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "thunderstorm")
                }else if [300,301,302,310,311,312,313,314,321,520,521,522,531].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "shower rain")
                }else if [500,501,502,503,504].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "rain")
                }else if [511,600,601,602,611,612,613,615,616,620,621,622].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "snow")
                }else if [701,711,721,731,741,751,761,762,771,781].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "mist")
                }else if [800].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "clear sky")
                }else if [801].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "few clouds")
                }else if [802].contains(jsonWeather["id"]){
                    self.conditionImageView.image = UIImage(named: "scattered clouds")
                }else{
                    self.conditionImageView.image = UIImage(named: "hatena")
                }
                
            }else{
               self.maxTempLabel.text = "位置情報が設定されていません"
            }
        }
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



