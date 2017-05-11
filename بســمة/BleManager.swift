//
//  BleManager.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/8/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import Foundation
import CoreBluetooth


class BleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    static let sharedInstance = BleManager()
    
    var centralManager:CBCentralManager! //CBCentralManager is responsible for scanning for, discovering, and connecting to peripherals.
    var BlueToothDevice_Peripheral:CBPeripheral?
    var _characteristics: CBCharacteristic?
    // define our scanning interval times
    let timerPauseInterval:TimeInterval = 10.0
    let timerScanInterval:TimeInterval = 2.0
    var keepScanning = false
    
    override init(){
        //Initializing 
        super.init()

    }
    
    func Connect(){
        centralManager = CBCentralManager(delegate: self,queue: nil) // this should called on ViewDidLoad to create CBCentralManager
            print("called")
        if centralManager.isScanning==true {
            print("scanning")
        }else {
            print("Not scanning")
        }
    }
    
    
    //here code for centralManager methods for connecting bluetooth
    // MARK: - CBCentralManagerDelegate methods
    // Invoked when the central manager’s state is updated.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var showAlert = true
        var message = ""
        switch central.state {
        case .poweredOff:
            message = "Bluetooth on this device is currently powered off."
        case .unsupported:
            message = "This device does not support Bluetooth Low Energy."
        case .unauthorized:
            message = "This app is not authorized to use Bluetooth Low Energy."
        case .resetting:
            message = "The BLE Manager is resetting; a state update is pending."
        case .unknown:
            message = "The state of the BLE Manager is unknown."
        case .poweredOn:
            showAlert = false
            message = "Bluetooth LE is turned on and ready for communication."
            print(message)
            keepScanning=true
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            
            let sensorTagAdvertisingUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
            print("Scanning for SensorTag adverstising with UUID: \(sensorTagAdvertisingUUID)")
            centralManager.scanForPeripherals(withServices: [sensorTagAdvertisingUUID], options: nil)
        }
        if showAlert {
            //show msg
        }
    }
    
    @objc func pauseScan() {
        // Scanning uses up battery on phone, so pause the scan process for the designated interval.
        print("*** PAUSING SCAN...")
        _ = Timer(timeInterval: timerPauseInterval, target: self, selector: #selector(resumeScan), userInfo: nil, repeats: false)
        centralManager.stopScan()
        
    }
    
    @objc func resumeScan() {
        if keepScanning {
            // Start scanning again...
            print("*** RESUMING SCAN!")
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            
            
        }
    }
    
    
    /*
     Invoked when the central manager discovers a peripheral while scanning.
     The advertisement data can be accessed through the keys listed in Advertisement Data Retrieval Keys.
     You must retain a local copy of the peripheral if any command is to be performed on it.
     In use cases where it makes sense for your app to automatically connect to a peripheral that is
     located within a certain range, you can use RSSI data to determine the proximity of a discovered
     peripheral device.
     central - The central manager providing the update.
     peripheral - The discovered peripheral.
     advertisementData - A dictionary containing any advertisement data.
     RSSI - The current received signal strength indicator (RSSI) of the peripheral, in decibels.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("centralManager didDiscoverPeripheral - CBAdvertisementDataLocalNameKey is \"\(CBAdvertisementDataLocalNameKey)\"")
        
        // Retrieve the peripheral name from the advertisement data using the "kCBAdvDataLocalName" key
        if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("NEXT PERIPHERAL NAME: \(peripheralName)")
            print("NEXT PERIPHERAL UUID: \(peripheral.identifier.uuidString)")
            
            if peripheralName == "Adafruit Bluefruit LE" {
                print("SENSOR TAG FOUND! ADDING NOW!!!")
                // to save power, stop scanning for other devices
                keepScanning = false
                
                // save a reference to the sensor tag
                BlueToothDevice_Peripheral = peripheral
                BlueToothDevice_Peripheral!.delegate = self
                
                // Request a connection to the peripheral
                centralManager.connect(BlueToothDevice_Peripheral!, options: nil)
            }
        }
    }
    
    
    /*
     Invoked when a connection is successfully created with a peripheral.
     
     This method is invoked when a call to connectPeripheral:options: is successful.
     You typically implement this method to set the peripheral’s delegate and to discover its services.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("**** SUCCESSFULLY CONNECTED TO SENSOR TAG!!!")
        
        // Now that we've successfully connected to the SensorTag, let's discover the services.
        // - NOTE:  we pass nil here to request ALL services be discovered.
        //          If there was a subset of services we were interested in, we could pass the UUIDs here.
        //          Doing so saves battery life and saves time.
        peripheral.discoverServices(nil)
    }
    
    
    /*
     Invoked when the central manager fails to create a connection with a peripheral.
     
     This method is invoked when a connection initiated via the connectPeripheral:options: method fails to complete.
     Because connection attempts do not time out, a failed connection usually indicates a transient issue,
     in which case you may attempt to connect to the peripheral again.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("**** CONNECTION TO SENSOR TAG FAILED!!!")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("**** DISCONNECTED FROM SENSOR TAG!!!")
        if error != nil {
            print("****** DISCONNECTION DETAILS: \(error!.localizedDescription)")
        }
        BlueToothDevice_Peripheral = nil
        
        //try to reconnect
        let sensorTagAdvertisingUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        print("Scanning for SensorTag adverstising with UUID: \(sensorTagAdvertisingUUID)")
        centralManager.scanForPeripherals(withServices: [sensorTagAdvertisingUUID], options: nil)
    }
    
    
    //MARK: - CBPeripheralDelegate methods
    
    /*
     Invoked when you discover the peripheral’s available services.
     
     This method is invoked when your app calls the discoverServices: method.
     If the services of the peripheral are successfully discovered, you can access them
     through the peripheral’s services property.
     
     If successful, the error parameter is nil.
     If unsuccessful, the error parameter returns the cause of the failure.
     */
    // When the specified services are discovered, the peripheral calls the peripheral:didDiscoverServices: method of its delegate object.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("ERROR DISCOVERING SERVICES: ")
            return
        }
        
        // Core Bluetooth creates an array of CBService objects —- one for each service that is discovered on the peripheral.
        if let services = peripheral.services {
            for service in services {
                print("Discovered service \(service)")
                // If we found either the temperature or the humidity service, discover the characteristics for those services.
                if (service.uuid == CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    
    /*
     Invoked when you discover the characteristics of a specified service.
     If the characteristics of the specified service are successfully discovered, you can access
     them through the service's characteristics property.
     If successful, the error parameter is nil.
     If unsuccessful, the error parameter returns the cause of the failure.
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("ERROR DISCOVERING CHARACTERISTICS: ")
            return
        }
        
        if let characteristics = service.characteristics {
            //var enableValue:UInt8 = 1
            //let enableBytes = Data(bytes: UnsafePointer<UInt8>(&enableValue), count: sizeof(UInt8))
            
            for characteristic in characteristics {
                // Trying to find the characteristic that sends data
                if characteristic.uuid == CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") {
                    _characteristics = characteristic
                    //BlueToothDevice_Peripheral?.readValue(for: _characteristics!)
                    
                    //let string = "Hello msg"
                    //let data = string.data(using: String.Encoding.utf8)
                    //BlueToothDevice_Peripheral?.writeValue(data!, for: _characteristics!,type: CBCharacteristicWriteType.withoutResponse)
                    
                    //sendData(TextData: "Another Hello")
                }
                if characteristic.uuid == CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") {
                    //this characteristic for recieving data
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func sendData(TextData : String)
    {
        let dataToSend = TextData.data(using: String.Encoding.utf8)
        print("SendData Method invoked")
        //print(_characteristics?.uuid)
        if (BlueToothDevice_Peripheral != nil) {
            BlueToothDevice_Peripheral?.writeValue(dataToSend!, for: _characteristics!,type: CBCharacteristicWriteType.withoutResponse)
        }else {
            print("Device not connected")
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //data recieved
        if(characteristic.value != nil) {
            let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
            print( stringValue)
        }
    }
    
    
    
    
    
    
    
}
