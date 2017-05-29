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
        SendT("N")
        recive()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartNFC(_ sender: UIButton) {
        SendT("N")
        recive()
    }

    
    // a function for sending text to Basma hardware
    func SendT(_ text: String) {
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
        print("SendTextMessage Invoked-- Msg: "+text)
        
    }//end sendT func
    
    var timer :Timer!
    var flag = true
    var childChoice = ""
    
    func recive (){
        
        if( flag )
        {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(recive), userInfo: nil, repeats: true)
            flag = false
        }
        
        childChoice = BleManagerNew.getInstance().recive
        
        if ( childChoice == "" || childChoice == "9" ){
            print("No input recieved")
            return }
            
            // if there's input recieved
        else {
            
        
            // take first choice (Right sensor = 0)
            if (childChoice == "0") {
                BleManagerNew.getInstance().recive = ""
                //sleep(1)
                SendT("ho")
                //returnStars()
            }
                // take first choice (Left sensor = 1)
            else if (childChoice == "1") {
                    BleManagerNew.getInstance().recive = ""
                    //sleep (1)
                    SendT("fo")
                    //returnStars()
                }
            
            print("input recieved. Value: " + childChoice)
            print("stopping timer")
            timer.invalidate()
            flag = true
            returnStars()
            
        
        }
        
    }
    
    func returnStars (){
        
        let displayedStars = UserDefaults.standard.integer(forKey: "displayedStars")
        var starsMsg = ""
        //print (displayedStars)
        
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
        sleep (10)
        print ("now")
        SendT(starsMsg)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
