//
//  StoryController.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/10/17.
//  Copyright © 2017 iWAN. All rights reserved.
// version 5

import Foundation
import UIKit
import CoreBluetooth

class StoryController: UIViewController, BleManagerDelegate{
    
    
    @IBOutlet weak var storyImg: UIImageView!
    
    
    // define arrays which contain picture names
    
    var imagesArray1: [String] = ["1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"]
    
    var imagesArray2: [String] = ["29", "30","31"]
    
    var imagesArray3: [String] = ["50","51","52","53"]
    
    var imagesChoice1_a: [String] = ["23a", "24a"]
    
    var imagesChoice1_b: [String] = ["23b", "24b","25b","26b","27b","28b"]
    
    var imagesChoice2_a: [String] = ["32a", "33a","34a","35a","36a","37a", "38a","39a","40a","41a","42a","43a","44a"]
    
    var imagesChoice2_b: [String] = ["32b", "33b","34b","35b","36b","37b", "38b","39b","40b","41b","42b","43b","44b","45b","46b","47b","48b","49b"]
    
    var imagePosition = 0
    var currentArray = "imagesArray1"
    var currentImage = ""
    var childChoice = ""
    @IBOutlet weak var nextButton: UIButton!
    var timerChild : Timer!
    var flag = true
    
    @IBAction func rightPressed(_ sender: UIButton) {
        
        
        switch currentImage {
        
        // here choose between brance 1-a or 1-b
        case "22" :
            
            nextButton.isEnabled = false
            SendText("T")
            
            if( flag )
            {
            timerChild = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(rightPressed), userInfo: nil, repeats: true)
            flag = false
            }
            
            childChoice = BleManagerNew.getInstance().recive
            
            if ( childChoice == "" || childChoice == "9" ){
                print("No input recieved")
                return }
                
            // if there's input recieved
            else {
                    print("input recieved. Value: " + childChoice)
                    print("stopping timer")
                    timerChild.invalidate()
                    flag = true
                    nextButton.isEnabled = true
                }//else
            
                // take first choice (Right sensor)
                if (childChoice == "0") {
                    currentArray = "imagesChoice1_a"
                    
                }
                    // take first choice (Left sensor)
                else if (childChoice == "1") {
                    currentArray = "imagesChoice1_b"
                }
                imagePosition = 0
                childChoice = ""
                break
                
                
        // check if its one of the two pictures that are the end of the FIRST branch
        case "24a" :
                
                currentArray = "imagesArray2"
                imagePosition = 0
                break
        
            
        // check if its one of the two pictures that are the end of the FIRST branch
        case "28b" :
                
                currentArray = "imagesArray2"
                imagePosition = 0
                break
        
            
        // here choose between brance 2-a or 2-b
        case "31" :
            
            nextButton.isEnabled = false
            SendText("T")
            
            if( flag )
            {
            timerChild = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(rightPressed), userInfo: nil, repeats: true)
            flag = false
            }
            
            childChoice = BleManagerNew.getInstance().recive
            
            if ( childChoice == "" || childChoice == "9" ){
                print("No input recieved")
                return }
                
            // if there's input recieved
            else {
                    print("input recieved. Value: " + childChoice)
                    print("stopping timer")
                    timerChild.invalidate()
                    flag = true
                    nextButton.isEnabled = true
            }//else
            
            // take first choice (Right sensor)
            if (childChoice == "0") {
                currentArray = "imagesChoice2_a"
                
            }
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                currentArray = "imagesChoice2_b"
            }
            
            imagePosition = 0
            childChoice = ""
            break
        
        
        // check if its one of the two pictures that are the end of the SECOND branch
        case "44a" :
            
            currentArray = "imagesArray3"
            imagePosition = 0
            break
            
        // check if its one of the two pictures that are the end of the SECOND branch
        case "49b" :
            
            currentArray = "imagesArray3"
            imagePosition = 0
            break
            
        case "53" :
            storyImg.isHidden = true
            nextButton.isHidden = true
            break
            
        // In case its only the next picture
        default :
            imagePosition += 1
            break
            
        }
        
            changeImage(position: imagePosition, currentArray: currentArray)

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SendText("W:1")
    }
    
    
    
    func changeImage(position: Int, currentArray: String) {
        
        // check which array
        switch currentArray {
        case "imagesArray1":
            currentImage = imagesArray1[position]
        case "imagesArray2":
            currentImage = imagesArray2[position]
        case "imagesArray3":
            currentImage = imagesArray3[position]
        // choice 1 - a
        case "imagesChoice1_a":
            currentImage = imagesChoice1_a[position]
        // choice 1 - b
        case "imagesChoice1_b":
            currentImage = imagesChoice1_b[position]
        // choice 2 - a
        case "imagesChoice2_a":
            currentImage = imagesChoice2_a[position]
        // choice 2 - b
        case "imagesChoice2_b":
            currentImage = imagesChoice2_b[position]
            
        default: break
            
        }
        
        // display image
        storyImg.image = UIImage(named: currentImage);
        
        // send sound 
        SendText("W:"+currentImage)
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // a function for sending text to Basma hardware
    func SendText(_ text: String) {
        print("SendTextMessage Invoked")
        print(text)
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
    }
    

}
