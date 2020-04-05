//
//  TestViewController.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/04/04.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TestViewController: UIViewController {

    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didButtou(_ sender: Any) {
        
        print(input.text)
        
        if let aa = input.text{
            let touroku = aa
            
            self.ref.childByAutoId().setValue(touroku)
        }else{
            print("書いてないよ")
        }
        
       

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
