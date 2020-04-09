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

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        Thread.sleep(forTimeInterval: 1.0)
        print("時間がきた")
        
        // Do any additional setup after loading the view.
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
         
         let dayOfWeekToday = DateFormatter()
         dayOfWeekToday.dateFormat = DateFormatter.dateFormat(fromTemplate: "E", options: 1, locale: Locale.current)
        
         if dayOfWeekToday.string(from: Date()) == "Mon"{
             if alarmSetToday > date1{
                 if monStatus == 1{
                     alarmSet = alarmSetToday
                 }else{
                     if tueStatus == 1{
                         alarmSet = alarmSetTommory
                     }else{
                         if wedStatus == 1{
                             alarmSet = alarmSetTwoAf

                         }else{
                             if thuStatus == 1{
                                 alarmSet = alarmSetThreeAf
                             }else{
                                 if friStatus == 1{
                                     alarmSet = alarmSetFourAf

                                 }else{
                                     if satStatus == 1{
                                         alarmSet = alarmSetFiveAf
                                         
                                     }else{
                                         if sunStatus == 1{
                                             alarmSet = alarmSetSixAf
                                             }}}}}}}
                 }else{
                 if tueStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if wedStatus == 1{
                         alarmSet = alarmSetTwoAf
                     }else{
                         if thuStatus == 1{
                            alarmSet = alarmSetThreeAf
                         }else{
                             if friStatus == 1{
                                 alarmSet = alarmSetFourAf
                             }else{
                                 if satStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                 }else{
                                     if sunStatus == 1{
                                         alarmSet = alarmSetSixAf
                                     }else{
                                         if monStatus == 1{
                                             alarmSet = alarmSetSevenAf
                                         }}}}}}}}
         }else if dayOfWeekToday.string(from: Date()) == "Tue"{
             if alarmSetToday > date1{
             if tueStatus == 1{
                 alarmSet = alarmSetToday
             }else{
                 if wedStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if thuStatus == 1{
                         alarmSet = alarmSetTwoAf

                     }else{
                         if friStatus == 1{
                             alarmSet = alarmSetThreeAf
                         }else{
                             if satStatus == 1{
                                 alarmSet = alarmSetFourAf

                             }else{
                                 if sunStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                     
                                 }else{
                                     if monStatus == 1{
                                         alarmSet = alarmSetSixAf
                                         }}}}}}}
             }else{
             if wedStatus == 1{
                 alarmSet = alarmSetTommory
             }else{
                 if thuStatus == 1{
                     alarmSet = alarmSetTwoAf
                 }else{
                     if friStatus == 1{
                        alarmSet = alarmSetThreeAf
                     }else{
                         if satStatus == 1{
                             alarmSet = alarmSetFourAf
                         }else{
                             if sunStatus == 1{
                                 alarmSet = alarmSetFiveAf
                             }else{
                                 if monStatus == 1{
                                     alarmSet = alarmSetSixAf
                                 }else{
                                     if tueStatus == 1{
                                         alarmSet = alarmSetSevenAf
                                     }}}}}}}}
             print("火曜だ")
         }else if dayOfWeekToday.string(from: Date()) == "Wed"{
             if alarmSetToday > date1{
             if wedStatus == 1{
                 alarmSet = alarmSetToday
             }else{
                 if thuStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if friStatus == 1{
                         alarmSet = alarmSetTwoAf

                     }else{
                         if satStatus == 1{
                             alarmSet = alarmSetThreeAf
                         }else{
                             if sunStatus == 1{
                                 alarmSet = alarmSetFourAf

                             }else{
                                 if monStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                     
                                 }else{
                                     if tueStatus == 1{
                                         alarmSet = alarmSetSixAf
                                         }}}}}}}
             }else{
             if thuStatus == 1{
                 alarmSet = alarmSetTommory
             }else{
                 if friStatus == 1{
                     alarmSet = alarmSetTwoAf
                 }else{
                     if satStatus == 1{
                        alarmSet = alarmSetThreeAf
                     }else{
                         if sunStatus == 1{
                             alarmSet = alarmSetFourAf
                         }else{
                             if monStatus == 1{
                                 alarmSet = alarmSetFiveAf
                             }else{
                                 if tueStatus == 1{
                                     alarmSet = alarmSetSixAf
                                 }else{
                                     if wedStatus == 1{
                                         alarmSet = alarmSetSevenAf
                                     }}}}}}}}
             print("水だ")
         }else if dayOfWeekToday.string(from: Date()) == "Thu"{
             if alarmSetToday > date1{
             if thuStatus == 1{
                 alarmSet = alarmSetToday
             }else{
                 if friStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if satStatus == 1{
                         alarmSet = alarmSetTwoAf

                     }else{
                         if sunStatus == 1{
                             alarmSet = alarmSetThreeAf
                         }else{
                             if monStatus == 1{
                                 alarmSet = alarmSetFourAf

                             }else{
                                 if tueStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                     
                                 }else{
                                     if wedStatus == 1{
                                         alarmSet = alarmSetSixAf
                                         }}}}}}}
             }else{
             if friStatus == 1{
                 alarmSet = alarmSetTommory
             }else{
                 if satStatus == 1{
                     alarmSet = alarmSetTwoAf
                 }else{
                     if sunStatus == 1{
                        alarmSet = alarmSetThreeAf
                     }else{
                         if monStatus == 1{
                             alarmSet = alarmSetFourAf
                         }else{
                             if tueStatus == 1{
                                 alarmSet = alarmSetFiveAf
                             }else{
                                 if wedStatus == 1{
                                     alarmSet = alarmSetSixAf
                                 }else{
                                     if thuStatus == 1{
                                         alarmSet = alarmSetSevenAf
                                     }}}}}}}}

             print("木だ")
         }else if dayOfWeekToday.string(from: Date()) == "Fri"{
             if alarmSetToday > date1{
             if friStatus == 1{
                 alarmSet = alarmSetToday
             }else{
                 if satStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if sunStatus == 1{
                         alarmSet = alarmSetTwoAf

                     }else{
                         if monStatus == 1{
                             alarmSet = alarmSetThreeAf
                         }else{
                             if tueStatus == 1{
                                 alarmSet = alarmSetFourAf

                             }else{
                                 if wedStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                     
                                 }else{
                                     if thuStatus == 1{
                                         alarmSet = alarmSetSixAf
                                         }}}}}}}
             }else{
             if satStatus == 1{
                 alarmSet = alarmSetTommory
             }else{
                 if sunStatus == 1{
                     alarmSet = alarmSetTwoAf
                 }else{
                     if monStatus == 1{
                        alarmSet = alarmSetThreeAf
                     }else{
                         if tueStatus == 1{
                             alarmSet = alarmSetFourAf
                         }else{
                             if wedStatus == 1{
                                 alarmSet = alarmSetFiveAf
                             }else{
                                 if thuStatus == 1{
                                     alarmSet = alarmSetSixAf
                                 }else{
                                     if friStatus == 1{
                                         alarmSet = alarmSetSevenAf
                                     }}}}}}}}
             print("金だ")
         }else if dayOfWeekToday.string(from: Date()) == "Sat"{
             if alarmSetToday > date1{
             if satStatus == 1{
                 alarmSet = alarmSetToday
             }else{
                 if sunStatus == 1{
                     alarmSet = alarmSetTommory
                 }else{
                     if monStatus == 1{
                         alarmSet = alarmSetTwoAf

                     }else{
                         if tueStatus == 1{
                             alarmSet = alarmSetThreeAf
                         }else{
                             if wedStatus == 1{
                                 alarmSet = alarmSetFourAf

                             }else{
                                 if thuStatus == 1{
                                     alarmSet = alarmSetFiveAf
                                     
                                 }else{
                                     if friStatus == 1{
                                         alarmSet = alarmSetSixAf
                                         }}}}}}}
             }else{
             if sunStatus == 1{
                 alarmSet = alarmSetTommory
             }else{
                 if monStatus == 1{
                     alarmSet = alarmSetTwoAf
                 }else{
                     if tueStatus == 1{
                        alarmSet = alarmSetThreeAf
                     }else{
                         if wedStatus == 1{
                             alarmSet = alarmSetFourAf
                         }else{
                             if thuStatus == 1{
                                 alarmSet = alarmSetFiveAf
                             }else{
                                 if friStatus == 1{
                                     alarmSet = alarmSetSixAf
                                 }else{
                                     if satStatus == 1{
                                         alarmSet = alarmSetSevenAf
                                     }}}}}}}}
             print("土だ")
         }else{
            if alarmSetToday > date1{
            if sunStatus == 1{
                alarmSet = alarmSetToday
            }else{
                if monStatus == 1{
                    alarmSet = alarmSetTommory
                }else{
                    if tueStatus == 1{
                        alarmSet = alarmSetTwoAf

                    }else{
                        if wedStatus == 1{
                            alarmSet = alarmSetThreeAf
                        }else{
                            if thuStatus == 1{
                                alarmSet = alarmSetFourAf

                            }else{
                                if friStatus == 1{
                                    alarmSet = alarmSetFiveAf
                                    
                                }else{
                                    if satStatus == 1{
                                        alarmSet = alarmSetSixAf
                                        }}}}}}}
            }else{
            if monStatus == 1{
                alarmSet = alarmSetTommory
            }else{
                if tueStatus == 1{
                    alarmSet = alarmSetTwoAf
                }else{
                    if wedStatus == 1{
                       alarmSet = alarmSetThreeAf
                    }else{
                        if thuStatus == 1{
                            alarmSet = alarmSetFourAf
                        }else{
                            if friStatus == 1{
                                alarmSet = alarmSetFiveAf
                            }else{
                                if satStatus == 1{
                                    alarmSet = alarmSetSixAf
                                }else{
                                    if sunStatus == 1{
                                        alarmSet = alarmSetSevenAf
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
                content.title = "起きる時間ですよ"
                content.body = "今日のおみくじ結果と天気を確認しよう-\(i)"
                  

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
