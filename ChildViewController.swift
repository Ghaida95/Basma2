//
//  ChildViewController.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/15/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import UIKit
import CoreBluetooth

class ChildViewController: UIViewController, BleManagerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let displayedStars = UserDefaults.standard.integer(forKey: "displayedStars")
        var starsMsg = ""
        
        switch displayedStars {
            
        case 0 :
            starsMsg = "S0"
        case 1 :
            starsMsg = "S1"
        case 2 :
            starsMsg = "S2"
        case 3 :
            starsMsg = "S3"
        case 4 :
            starsMsg = "S4"
        case 5 :
            starsMsg = "S5"
        default :
            starsMsg = "S0"
        }
       // SendT(starsMsg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // a function for sending text to Basma hardware
    func SendT(_ text: String) {
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
        print("SendTextMessage Invoked-- Msg: "+text)
        
    }//end sendT func

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
