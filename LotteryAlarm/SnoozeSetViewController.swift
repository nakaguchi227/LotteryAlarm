//
//  SnoozeSetViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/12.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import RealmSwift

class SnoozeSetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snooze", for: indexPath) as! CustomTableViewCell
        // セルに値を設定
        
        let realm = try! Realm()
        let snoozeData = realm.objects(SelectedSnooze.self).first
        if let snoozeTime = snoozeData{
            if snoozeTime.snooze == indexPath.row{
                cell.checkImage.image = UIImage(named: imageNames[indexPath.row])
            }else{
                cell.checkImage.image = nil
            }
        }else{
            cell.checkImage.image = nil
        }
        
        cell.titleLabel.text = items[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let snoozeData = realm.objects(SelectedSnooze.self).first
        if let tapData = snoozeData{
            try! realm.write {
                tapData.snooze = indexPath.row
            }
        }else{
            let snooze = SelectedSnooze()
            snooze.snooze = indexPath.row
            try! realm.write {
                realm.add(snooze)
            }
        }
        loadView()
        viewDidLoad()
    }
    
    
    //ラベル
    let items = ["設定しない","1分","2分","3分","4分","5分","6分","7分","8分","9分","10分"]
    // 画像のファイル名
    let imageNames = ["snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck", "snoozeCheck"]
 
    
    //端末のサイズを取得
    let myBoundSize: CGSize = UIScreen.main.bounds.size

    @IBOutlet weak var snoozeTitle: UILabel!
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBAction func returnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var snoozeTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.snoozeTableView.delegate = self
        self.snoozeTableView.dataSource = self
        snoozeTableView.isScrollEnabled = false
        
        //保存ボタンの設定
        snoozeTitle.backgroundColor = UIColor.darkGray// ボタンの色
        snoozeTitle.frame = CGRect(x: myBoundSize.width * 0, y: myBoundSize.height * 0, width: myBoundSize.width * 1, height: myBoundSize.height * 0.05)
        
        returnButton.frame = CGRect(x: myBoundSize.width * 0, y: myBoundSize.height * 0, width: myBoundSize.width * 0.2, height: myBoundSize.height * 0.05)


        // Do any additional setup after loading the view.
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
