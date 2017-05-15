//
//  NFCViewController.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/15/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import UIKit
import CoreBluetooth

class NFCViewController: UIViewController, BleManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NFCstart(_ sender: Any) {
        SendT("N")
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
