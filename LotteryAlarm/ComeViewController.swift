//
//  ComeViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/05.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift

class ComeViewController: UIViewController {

    var fade_timer = Timer()
   
    @IBOutlet weak var omikujiImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print("時間がきた")
        
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
         
          print(settingDate)
        
        
        
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
                   content.body = "アプリを開いて今日のおみくじ結果と天気を確認しよう-\(i)"
               }else{
                   content.title = "アラームが設定されています"
                   content.body = "今日のおみくじ結果と天気を確認しよう-\(i)"
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
