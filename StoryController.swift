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
    
    @IBOutlet weak var upRightButton: UIButton!
    @IBOutlet weak var middleRightButton: UIButton!
    @IBOutlet weak var downRightButton: UIButton!
    
    @IBOutlet weak var upLeftButton: UIButton!
    @IBOutlet weak var middleLeftButton: UIButton!
    @IBOutlet weak var downLeftButton: UIButton!
    
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
    
    // method to handle clicking the next button for the story page
    @IBAction func rightPressed(_ sender: UIButton) {

        switch currentImage {
        
        case "12":
            upRightButton.setImage(UIImage(named:"cat.png"), for: .normal)
            middleRightButton.setImage(UIImage(named:"elephant.png"), for: .normal)
            downRightButton.setImage(UIImage(named:"bird.png"), for: .normal)
            self.upRightButton.isHidden=false
            self.middleRightButton.isHidden=false
            self.downRightButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break
        // here choose between branch 1-a or 1-b
        case "22" :
            sleep(3)
            // disable next button until recieving touch input from the
            nextButton.isEnabled = false
            
            if( flag )
            {
            timerChild = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(rightPressed), userInfo: nil, repeats: true)
            flag = false
                
                SendText("T")
            }
            
            childChoice = BleManagerNew.getInstance().recive
            
            if ( childChoice == ""){
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
            
                // take first choice (Right sensor = 0)
                if (childChoice == "0") {
                    currentArray = "imagesChoice1_a"
                    BleManagerNew.getInstance().recive = ""
                }
                    // take first choice (Left sensor = 1)
                else if (childChoice == "1") {
                    currentArray = "imagesChoice1_b"
                    BleManagerNew.getInstance().recive = ""
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
        
            
        // here choose between branch 2-a or 2-b
        case "31" :
            sleep(3)
            // disable next button until recieving touch input from the child
            nextButton.isEnabled = false
            
            if( flag )
            {
            timerChild = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(rightPressed), userInfo: nil, repeats: true)
            flag = false
                SendText("T")
            }
            
            childChoice = BleManagerNew.getInstance().recive
            
            if ( childChoice == ""  ){
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
                BleManagerNew.getInstance().recive = ""
                
            }
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                currentArray = "imagesChoice2_b"
                BleManagerNew.getInstance().recive = ""
            }
            
            imagePosition = 0
            childChoice = ""
            break
        
        case "39a" :
            upLeftButton.setImage(UIImage(named:"vegetables.png"), for: .normal)
            middleLeftButton.setImage(UIImage(named:"meat.png"), for: .normal)
            downLeftButton.setImage(UIImage(named:"ant.png"), for: .normal)
            self.upLeftButton.isHidden=false
            self.middleLeftButton.isHidden=false
            self.downLeftButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break
        case "40a":
            upLeftButton.setImage(UIImage(named:"sand.png"), for: .normal)
            middleLeftButton.setImage(UIImage(named:"air.png"), for: .normal)
            downLeftButton.setImage(UIImage(named:"water.png"), for: .normal)
            self.upLeftButton.isHidden=false
            self.middleLeftButton.isHidden=false
            self.downLeftButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break

        case "41a":
            upLeftButton.setImage(UIImage(named:"bigSun.png"), for: .normal)
            middleLeftButton.setImage(UIImage(named:"earth.png"), for: .normal)
            downLeftButton.setImage(UIImage(named:"moon.png"), for: .normal)
            self.upLeftButton.isHidden=false
            self.middleLeftButton.isHidden=false
            self.downLeftButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break
            
        // check if its one of the two pictures that are the end of the SECOND branch
        case "44a" :
            
            currentArray = "imagesArray3"
            imagePosition = 0
            break
            
        // check if its one of the two pictures that are the end of the SECOND branch
        case "44b" :
            upRightButton.setImage(UIImage(named:"desert.png"), for: .normal)
            middleRightButton.setImage(UIImage(named:"sea.png"), for: .normal)
            downRightButton.setImage(UIImage(named:"forest.png"), for: .normal)
            self.upRightButton.isHidden=false
            self.middleRightButton.isHidden=false
            self.downRightButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break
        case "45b" :
            upRightButton.setImage(UIImage(named:"four.png"), for: .normal)
            middleRightButton.setImage(UIImage(named:"three.png"), for: .normal)
            downRightButton.setImage(UIImage(named:"two.png"), for: .normal)
            self.upRightButton.isHidden=false
            self.middleRightButton.isHidden=false
            self.downRightButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            break
        case "46b" :
            upRightButton.setImage(UIImage(named:"sea.png"), for: .normal)
            middleRightButton.setImage(UIImage(named:"camp.png"), for: .normal)
            downRightButton.setImage(UIImage(named:"village.png"), for: .normal)
            self.upRightButton.isHidden=false
            self.middleRightButton.isHidden=false
            self.downRightButton.isHidden=false
            // disable next button until recieving input
            nextButton.isEnabled = false
            imagePosition += 1
            
        case "49b" :
            
            currentArray = "imagesArray3"
            imagePosition = 0
            break
        
        // LAST picture
        case "53" :
            storyImg.image = UIImage(named: "54");
            nextButton.isHidden = true
            break
            
        // In case its only the next picture
        default :
            imagePosition += 1
            break
            
        }
        // if its not the last picture
        if(!(currentImage == "53")){
            changeImage(position: imagePosition, currentArray: currentArray)
        }
    } // end rightPressed method
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // send first voice for the story
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
    
    //right buttons
    @IBAction func upButtonPressed(_ sender: Any) { //cat
        let alertController = UIAlertController(title: "إجابة خاطئة ", message: "حاولي مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "محاولة أخرى", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        SendText("W:Try")
    }

    @IBAction func button2Pressed(_ sender: Any) { //elephant
        SendText("W:en2")
        sleep (3)
        nextButton.isEnabled = true
        self.upRightButton.isHidden=true
        self.middleRightButton.isHidden=true
        self.downRightButton.isHidden=true
    }

    @IBAction func bottomButtonPressed(_ sender: Any) {//bird
        let alertController = UIAlertController(title: "إجابة خاطئة ", message: "حاولي مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "محاولة أخرى", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        SendText("W:Try")
    }
    
    //left buttons
    
    @IBAction func upLeftPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "إجابة خاطئة ", message: "حاولي مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "محاولة أخرى", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        SendText("W:Try")
    }
   
    @IBAction func middleLeftPressed(_ sender: Any) {
        SendText("W:en2")
        sleep (3)
        nextButton.isEnabled = true
        self.upLeftButton.isHidden=true
        self.middleLeftButton.isHidden=true
        self.downLeftButton.isHidden=true
    }
    
    @IBAction func downLeftPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "إجابة خاطئة ", message: "حاولي مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "محاولة أخرى", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        SendText("W:Try")
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
