//
//  ConnectViewController.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/8/17.
//  Copyright © 2017 iWAN. All rights reserved.
//


import UIKit
import CoreBluetooth

class ConnectViewController: UIViewController,BleManagerDelegate{
    
    //var BlueToothDevice_Peripheral:CBPeripheral?
    
    @IBOutlet weak var CodeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set( "1234", forKey: "ConnectionCode")
        BleManagerNew.getInstance().delegate=self

        BleManagerNew.getInstance().initCBCentralManager() //Step 1 create A CPManager
    }
    
    
    func TestFunc() {
        
    }
    
    @IBAction func ConnectClick(_ sender: BounceButton) {
        
        if (CodeTextField.text == "") {
            let alert = UIAlertController(title: "تنبيه", message: " فضلا ادخل الرمز", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if CodeTextField.text != UserDefaults.standard.string(forKey: "ConnectionCode"){
            let alert = UIAlertController(title: "تنبيه", message: " الرمز الذي تم إدخاله غير صحيح، الرجاء المحاولة مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
        UserDefaults.standard.set(true,forKey: "isConnectionCodeEntered")
            if BleManagerNew.getInstance().state==CBCentralManagerState.poweredOn {
                BleManagerNew.getInstance().startScanPeripheral() //step 2 start scanning for Peripheral
            }
        }
        
    }
    
    
    //This invoked on step 2
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber){
        print("Step 2 called didDiscoverPeripheral - CBAdvertisementDataLocalNameKey is \"\(CBAdvertisementDataLocalNameKey)\"")
        
        // Retrieve the peripheral name from the advertisement data using the "kCBAdvDataLocalName" key
        if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("NEXT PERIPHERAL NAME: \(peripheralName)")
            print("NEXT PERIPHERAL UUID: \(peripheral.identifier.uuidString)")
            if peripheralName == "Adafruit Bluefruit LE" {
                print("SENSOR TAG FOUND! ADDING NOW!!!")
                // to save power, stop scanning for other devices
                BleManagerNew.getInstance().stopScanPeripheral()
                // Request a connection to the peripheral
                BleManagerNew.getInstance().connectPeripheral(peripheral)//Step 3 connect to the Peripheral ( the Device )
            }
        }
    }

    //This Invoked on Step 3 if the connection
    func didDiscoverServices(_ peripheral: CBPeripheral){
        // Core Bluetooth creates an array of CBService objects —- one for each service that is discovered on the peripheral.
        if let services = peripheral.services {
            for service in services {
                print("Discovered service \(service)")
                // If we found either the temperature or the humidity service, discover the characteristics for those services.
                if (service.uuid == CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) {
                    peripheral.discoverCharacteristics(nil, for: service) //Step 4 Finding Characteristics Responsible for Writing and Reading
                }
            }
        }
    }
    
    
    //This invoked on Step 4 Finding Characteristics Responsilbe for Writing and Reading
    func didDiscoverCharacteritics(_ service: CBService){
        for characteristic in service.characteristics! {
            // Trying to find the characteristic that sends data
            if characteristic.uuid == CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") {
                //Send Characteristic for Writing has been found
                print("Send Characteristic for Writing has been found ")
                BleManagerNew.getInstance().characteristicForWrite = characteristic
                
            }
            if characteristic.uuid == CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") {
                //this characteristic for recieving data
                BleManagerNew.getInstance().setNotification(enable: true, forCharacteristic: characteristic) //Monitor Revieved Messages
                print("Receive Characteristic has been found and set to be notified")
            }
        }
    }
    
    func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral){
        print("Device has been conncted and you can move to the next viewcontroller ")
    }
    
    func failToConnectPeripheral(_ peripheral: CBPeripheral, error: Error){
        print("Failed to connect to the device! so you cannot move to the next viewcontroller")
    }
}


