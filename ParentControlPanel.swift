//
//  ParentControlPanel.swift
//  بســمة
//
//  Created by ShahadR on 4/14/17.
//  Copyright © 2017 iWAN. All rights reserved.
// version 4

import Foundation
import UIKit
import CoreBluetooth

class ParentControlPanel : UIViewController ,BleManagerDelegate{
    
    //alaa//
    @IBOutlet weak var ChildNameInParentLabel: UILabel!
    @IBOutlet weak var AddChildButton: UIButton!
    @IBOutlet weak var EditChildButton: UIButton!
    @IBOutlet weak var AvatarPic: UIImageView!
    
    var timer = Timer()
    var backgroundTask = BackgroundTask()
    var timer2 = Timer()
    var backgroundTask2 = BackgroundTask()
    var timer3 = Timer()
    var backgroundTask3 = BackgroundTask()
    var timer4 = Timer()
    var backgroundTask4 = BackgroundTask()
    var timer5 = Timer()
    var backgroundTask5 = BackgroundTask()
    
    
    
    // Time text fields
    @IBOutlet weak var datePickerTxt1: UITextField!
    @IBOutlet weak var datePickerTxt2: UITextField!
    @IBOutlet weak var datePickerTxt3: UITextField!
    @IBOutlet weak var datePickerTxt4: UITextField!
    @IBOutlet weak var datePickerTxt5: UITextField!
    
    // Time enabling switches
    @IBOutlet weak var switchBtn1: UISwitch!
    @IBOutlet weak var switchBtn2: UISwitch!
    @IBOutlet weak var switchBtn3: UISwitch!
    @IBOutlet weak var switchBtn4: UISwitch!
    @IBOutlet weak var switchBtn5: UISwitch!
    
    
    // Chart
    var lineChart: LineChart!
    
    // stars variables
    var totalStars = 0
    var displayedStars = 0
    var morningStars = 0
    var nightStars = 0
    var brushTeethStars = 0
    var kissParentsStars = 0
    var bedtimeStars = 0
    
    /*
    @IBAction func SendTest(_ sender: UIButton) {
        print("SendTestMessage Invoked")
        let TextData: String
        TextData="Hi BLE"
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
    } */
    
    // a function for sending text to Basma hardware
    func SendText(_ text: String) {
        print("SendTextMessage Invoked")
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic){
        if(characteristic.value != nil) {
            let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
            print( stringValue)
        }
    }
    


    
    override func viewDidLoad() {
     super.viewDidLoad()
        BleManagerNew.getInstance().delegate=self
        
        
        // set some values for testing only >> DELETE this part later
        UserDefaults.standard.set(6, forKey: "totalStars")
        UserDefaults.standard.set(3, forKey: "morningStars")
        UserDefaults.standard.set(20, forKey: "nightStars")
        UserDefaults.standard.set(10, forKey: "brushTeethStars")
        UserDefaults.standard.set(5, forKey: "kissParentsStars")
        UserDefaults.standard.set(8, forKey: "bedtimeStars")
        UserDefaults.standard.set(2, forKey: "displayedStars")
        
        
        
        // load stars values
        totalStars = UserDefaults.standard.integer(forKey: "totalStars")
        displayedStars = UserDefaults.standard.integer(forKey: "displayedStars")
        morningStars = UserDefaults.standard.integer(forKey: "morningStars")
        nightStars = UserDefaults.standard.integer(forKey: "nightStars")
        brushTeethStars = UserDefaults.standard.integer(forKey: "brushTeethStars")
        kissParentsStars = UserDefaults.standard.integer(forKey: "kissParentsStars")
        bedtimeStars = UserDefaults.standard.integer(forKey: "bedtimeStars")
        
        
        
        // decide the message to be sent to basma based on number of stars
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
        // call method to display stars in Basma's screen
      //  SendText(starsMsg)
        
        
        // create chart and view data
       createChart()
        
        // Date picker
       createDatePicker()
        
        // set switches (on/off) with time
        setSwitches()
        
        //to control add/edit button
        if UserDefaults.standard.bool(forKey: "SaveButton") == false {
            EditChildButton.isHidden=true
            AddChildButton.isHidden=false
        }else{
            EditChildButton.isHidden=false
            AddChildButton.isHidden=true
            ChildNameInParentLabel.text = UserDefaults.standard.string(forKey: "ChildName")
            if UserDefaults.standard.bool(forKey: "Box1") == true {
                AvatarPic.image = UIImage( named: "avatar1")}
            else if UserDefaults.standard.bool(forKey: "Box2") == true {AvatarPic.image = UIImage( named: "avatar2")}
            else if UserDefaults.standard.bool(forKey: "Box3") == true {AvatarPic.image = UIImage( named: "avatar3")}
        }
        

        
    }// End view load
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createChart() {
        
        
        // Chart Code (Child progress)
        var views: [String: AnyObject] = [:]
        
        // simple array of chart values (from database)
        //   let data: [CGFloat] = [5, 4, 3, 11, 13]
        
        // get the stars values from the local storage to display them in the chart
        let data: [CGFloat] = [CGFloat(morningStars), CGFloat(nightStars), CGFloat(brushTeethStars), CGFloat(kissParentsStars), CGFloat(bedtimeStars)]
        
        // simple line with custom x axis labels
        //let xLabels: [String] = ["صباح", "مساء", "تفريش الأسنان", "تقبيل الوالدين", "أذكار النوم"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.x.labels.visible = false
        //    lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.x.grid.visible = false
        lineChart.y.grid.visible = false
        lineChart.dots.color = UIColor.magenta
        lineChart.colors = [UIColor.magenta]
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self as? LineChartDelegate
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        
        // chart display constarints to set position and size
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-74-[chart(==370)]", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[chart(==370)]-125-|", options: [], metrics: nil, views: views))
        
        
    }
    
    // function to update the chart when the stars values change
    func updateChart()  {
        // get the stars values from the local storage to display them in the chart
        let data: [CGFloat] = [CGFloat(morningStars), CGFloat(nightStars), CGFloat(brushTeethStars), CGFloat(kissParentsStars), CGFloat(bedtimeStars)]
        lineChart.addLine(data)
    }
    
       ///////backgeound task for first-1- reminder//////////////////
    //to send to blutooth only one
    var reminderFlag1:Bool = true
    var reminderFlag2:Bool = true
    var reminderFlag3:Bool = true
    var reminderFlag4:Bool = true
    var reminderFlag5:Bool = true
    //start Background Task for first reminder
    func startBackgroundTask() {
        reminderFlag1=true
        //start Background Task
        backgroundTask.startBackgroundTask()
        //start time
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }//end startBackgroundTask

    //stop Background Task for first reminder
    func stopBackgroundTask() {
        reminderFlag1=false
        timer.invalidate()//stop timer
        backgroundTask.stopBackgroundTask()//stop background task
    }//end stopBackgroundTask
    
    //this is the function that will be called in the background every second when first reminder enabeled
    func timerAction() {
        if ((UserDefaults.standard.string(forKey: "switchBtn1Stat") == "on") && (datePickerTxt1.text != "") &&
            (UserDefaults.standard.string(forKey: "switchBtn1Time") != "") && (reminderFlag1)) {
            //to get user input
            let dateFromUserOne = datePickerTxt1.text
            //to get current date
            let dateOne = Date()
            let dateFormatterOne = DateFormatter()
            dateFormatterOne.timeStyle = .short
            dateFormatterOne.dateStyle = .none
            let dateFromSystemOne = dateFormatterOne.string(from: dateOne)
            
            print(dateFromSystemOne+"   system")//for test
            print(dateFromUserOne!+"    user")//for test
            
            //check if current time equal user input time
            if(dateFromSystemOne == dateFromUserOne){
                //send notification to the child by blutooth
                SendT("W:mo1")

                //datePickerTxt5.text="first" //just for test
                reminderFlag1=false
            }//second if
        }//first if
        print("SomeCoolTaskRunning.....1")//just for test
        print(UserDefaults.standard.string(forKey: "switchBtn1Stat") ?? "No1" )//just for test
        //print(UserDefaults.standard.string(forKey: "switchBtn1Time") ?? "No2")//just for test
    }//end timerAction1

    ///////backgeound task for second-2- reminder//////////////////
   
    func startBackgroundTask2() {
        reminderFlag2=true
        backgroundTask2.startBackgroundTask()
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction2), userInfo: nil, repeats: true)
    }//end startBackgroundTask2
    
    func stopBackgroundTask2() {
        reminderFlag2=false
        timer2.invalidate()
        backgroundTask2.stopBackgroundTask()
    }//end stopBackgroundTask2
    
    func timerAction2() {
        
        if ((UserDefaults.standard.string(forKey: "switchBtn2Stat") == "on") && (datePickerTxt2.text != "") &&
            (UserDefaults.standard.string(forKey: "switchBtn2Time") != "") && (reminderFlag2)) {
            //to get user input
            let dateFromUserTwo = datePickerTxt2.text
            //to get current date
            let dateTwo = Date()
            let dateFormatterTwo = DateFormatter()
            dateFormatterTwo.timeStyle = .short
            dateFormatterTwo.dateStyle = .none
            let dateFromSystemTwo = dateFormatterTwo.string(from: dateTwo)

            print(dateFromSystemTwo+"   system")//for test
            print(dateFromUserTwo!+"    user")//for test
            
            //check if current time equal user input time
            if(dateFromSystemTwo == dateFromUserTwo){
                //send notification to the child by blutooth
                SendT("W:ev1")

               // datePickerTxt5.text="second" //just for test
                reminderFlag2=false
            }//second if
        }//first if
        print("SomeCoolTaskRunning.....2")//just for test
        print(UserDefaults.standard.string(forKey: "switchBtn2Stat") ?? "No1" )//just for test
        //print(UserDefaults.standard.string(forKey: "switchBtn2Time") ?? "No2")//just for test
    }//end timerAction2

    ///////backgeound task for third-3- reminder//////////////////
    func startBackgroundTask3() {
        reminderFlag3=true
        backgroundTask3.startBackgroundTask()
        timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction3), userInfo: nil, repeats: true)
    }//end startBackgroundTask3
    
    func stopBackgroundTask3() {
        reminderFlag3=false
        timer3.invalidate()
        backgroundTask3.stopBackgroundTask()
    }//end stopBackgroundTask3
    
    func timerAction3() {
        
        if ((UserDefaults.standard.string(forKey: "switchBtn3Stat") == "on") && (datePickerTxt3.text != "") &&
            (UserDefaults.standard.string(forKey: "switchBtn3Time") != "") && (reminderFlag3)) {
            //to get user input
            let dateFromUserthird = datePickerTxt3.text
            //to get current date
            let datethird = Date()
            let dateFormatterthird = DateFormatter()
            dateFormatterthird.timeStyle = .short
            dateFormatterthird.dateStyle = .none
            let dateFromSystemthird = dateFormatterthird.string(from: datethird)
            
            print(dateFromSystemthird+"   system")//for test
            print(dateFromUserthird!+"    user")//for test
            
            //check if current time equal user input time
            if(dateFromSystemthird == dateFromUserthird){
                SendT("W:te1")
                //datePickerTxt5.text="third" //just for test
                reminderFlag3=false
            }//second if
        }//first if
        print("SomeCoolTaskRunning.....3")//just for test
        print(UserDefaults.standard.string(forKey: "switchBtn3Stat") ?? "No1" )//just for test
        //print(UserDefaults.standard.string(forKey: "switchBtn3Time") ?? "No2")//just for test
    }//end timerAction3
    
    ///////backgeound task for forth-4- reminder//////////////////
    
    func startBackgroundTask4() {
        reminderFlag4=true
        backgroundTask4.startBackgroundTask()
        timer4 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction4), userInfo: nil, repeats: true)
    }//end startBackgroundTask4
    
    func stopBackgroundTask4() {
        reminderFlag4=false
        timer4.invalidate()
        backgroundTask4.stopBackgroundTask()
    }//end stopBackgroundTask4
    
    func timerAction4() {
        
        if ((UserDefaults.standard.string(forKey: "switchBtn4Stat") == "on") && (datePickerTxt4.text != "") &&
            (UserDefaults.standard.string(forKey: "switchBtn4Time") != "") && (reminderFlag4)) {
            //to get user input
            let dateFromUserforth = datePickerTxt4.text
            //to get current date
            let dateforth = Date()
            let dateFormatterforth = DateFormatter()
            dateFormatterforth.timeStyle = .short
            dateFormatterforth.dateStyle = .none
            let dateFromSystemforth = dateFormatterforth.string(from: dateforth)
            
            print(dateFromSystemforth+"   system")//for test
            print(dateFromUserforth!+"    user")//for test
            
            //check if current time equal user input time
            if(dateFromSystemforth == dateFromUserforth){
                //send notification to the child by blutooth
                SendT("W:ki1")

                //datePickerTxt5.text="forth" //just for test
                reminderFlag4=false
            }//second if
        }//first if
        print("SomeCoolTaskRunning.....4")//just for test
        print(UserDefaults.standard.string(forKey: "switchBtn4Stat") ?? "No1" )//just for test
        //print(UserDefaults.standard.string(forKey: "switchBtn4Time") ?? "No2")//just for test
    }//end timerAction4
    
    ///////backgeound task for fifth-5- reminder//////////////////
    
    func startBackgroundTask5() {
        reminderFlag5=true
        backgroundTask5.startBackgroundTask()
        timer5 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction5), userInfo: nil, repeats: true)
    }//end startBackgroundTask5
    
    func stopBackgroundTask5() {
        reminderFlag5=false
        timer5.invalidate()
        backgroundTask5.stopBackgroundTask()
    }//end stopBackgroundTask5
    
    func timerAction5() {
        
        if ((UserDefaults.standard.string(forKey: "switchBtn5Stat") == "on") && (datePickerTxt5.text != "") &&
            (UserDefaults.standard.string(forKey: "switchBtn5Time") != "") && (reminderFlag5)) {
            //to get user input
            let dateFromUserfifth = datePickerTxt5.text
            //to get current date
            let datefifth = Date()
            let dateFormatterfifth = DateFormatter()
            dateFormatterfifth.timeStyle = .short
            dateFormatterfifth.dateStyle = .none
            let dateFromSystemfifth = dateFormatterfifth.string(from: datefifth)
            
            print(dateFromSystemfifth+"   system")//for test
            print(dateFromUserfifth!+"    user")//for test
            
            //check if current time equal user input time
            if(dateFromSystemfifth == dateFromUserfifth){
                //send notification to the child by blutooth
                SendT("W:sl1")

                //datePickerTxt5.text="fifth" //just for test
                reminderFlag5=false
            }//second if
        }//first if
        print("SomeCoolTaskRunning.....5")//just for test
        print(UserDefaults.standard.string(forKey: "switchBtn5Stat") ?? "No1" )//just for test
        //print(UserDefaults.standard.string(forKey: "switchBtn5Time") ?? "No2")//just for test
    }//end timerAction5
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        // label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    
    
    // calculate stars and store them
    
    func calculateStars(action: String) {
        
        totalStars += 1
        
        // set the number of stars that will be displayed on Basma's screen
        if (totalStars == 125) {
            displayedStars = 5
            // unlock new story
        }
        else if (totalStars >= 100) {
            displayedStars = 4
        }
        else if (totalStars >= 75) {
            displayedStars = 3
        }
        else if (totalStars >= 50) {
            displayedStars = 2
        }
        else if (totalStars >= 25) {
            displayedStars = 1
        }
            // if its more than 125, reset the number of stars and start again
        else if (totalStars > 125) {
            displayedStars = 0
            totalStars = 1
            morningStars = 0
            nightStars = 0
            brushTeethStars = 0
            kissParentsStars = 0
            bedtimeStars = 0
            
        }
        
        // decide which action was done by the child, and increment it to view it in the chart
        switch action {
            
        case "morningAthkar" :
            morningStars += 1
        case "nightAthkar" :
            nightStars += 1
        case "brushingTeeth" :
            brushTeethStars += 1
        case "kissingParents" :
            kissParentsStars += 1
        case "bedtimeAthkar" :
            bedtimeStars += 1
        default: break
            
        }
        
        // save all values to local database
        
        UserDefaults.standard.set(totalStars, forKey: "totalStars")
        UserDefaults.standard.set(displayedStars, forKey: "displayedStars")
        UserDefaults.standard.set(morningStars, forKey: "morningStars")
        UserDefaults.standard.set(nightStars, forKey: "nightStars")
        UserDefaults.standard.set(brushTeethStars, forKey: "brushTeethStars")
        UserDefaults.standard.set(kissParentsStars, forKey: "kissParentsStars")
        UserDefaults.standard.set(bedtimeStars, forKey: "bedtimeStars")
        
        // call it to display updated values
        updateChart()
        
        
    } // end calculateStars method
    
    
    @IBAction func GoToChildViewPressed(_ sender: UIButton) {
        if ChildNameInParentLabel.text == ""{
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء تسجيل بيانات طفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }//end GoToChildViewPressed func
    
    
    /**
     * check if the parent create a child profile or not
     */
    func checkChildProfile() -> Bool {
    //if child profile deosent created alert the parent and return false otherwise return true
        if ChildNameInParentLabel.text == ""{
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء تسجيل بيانات طفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false //child profile not created
        }//end if
    return true //child profile created
    }//end checkChildProfile func
    
    
    
    // code for reminders switches
    
    // create date pickers
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    let datePicker3 = UIDatePicker()
    let datePicker4 = UIDatePicker()
    let datePicker5 = UIDatePicker()
    
    
    func createDatePicker() {
        
        // format for picker
        datePicker1.datePickerMode = .time
        datePicker2.datePickerMode = .time
        datePicker3.datePickerMode = .time
        datePicker4.datePickerMode = .time
        datePicker5.datePickerMode = .time
        
        // create toolbar with date picker which contain done button
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        let toolbar4 = UIToolbar()
        toolbar4.sizeToFit()
        let toolbar5 = UIToolbar()
        toolbar5.sizeToFit()
        
        // bar button item
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
        toolbar1.setItems([doneButton1], animated: false)
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolbar2.setItems([doneButton2], animated: false)
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed3))
        toolbar3.setItems([doneButton3], animated: false)
        let doneButton4 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed4))
        toolbar4.setItems([doneButton4], animated: false)
        let doneButton5 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed5))
        toolbar5.setItems([doneButton5], animated: false)
        
        // assigning the toolbars with the text fields to be displayed when the text field is pressed
        datePickerTxt1.inputAccessoryView = toolbar1
        datePickerTxt2.inputAccessoryView = toolbar2
        datePickerTxt3.inputAccessoryView = toolbar3
        datePickerTxt4.inputAccessoryView = toolbar4
        datePickerTxt5.inputAccessoryView = toolbar5
        
        // assigning date picker to text field
        datePickerTxt1.inputView = datePicker1
        datePickerTxt2.inputView = datePicker2
        datePickerTxt3.inputView = datePicker3
        datePickerTxt4.inputView = datePicker4
        datePickerTxt5.inputView = datePicker5
        
    }
    
    
    func setSwitches() {
        // SET switch 1
        let stat1 = UserDefaults.standard.string(forKey: "switchBtn1Stat")
        if ( stat1 == "on") {
            switchBtn1.isOn = true
            datePickerTxt1.isHidden = false
            datePickerTxt1.text = UserDefaults.standard.string(forKey: "switchBtn1Time")
            startBackgroundTask()
        }
        else {
            switchBtn1.isOn = false
            datePickerTxt1.isHidden = true
            
        }
        
        
        // SET switch 2
        let stat2 = UserDefaults.standard.string(forKey: "switchBtn2Stat")
        if ( stat2 == "on") {
            switchBtn2.isOn = true
            datePickerTxt2.isHidden = false
            datePickerTxt2.text = UserDefaults.standard.string(forKey: "switchBtn2Time")
            startBackgroundTask2()
            
        }
        else {
            switchBtn2.isOn = false
            datePickerTxt2.isHidden = true
        }
        
        // SET switch 3
        let stat3 = UserDefaults.standard.string(forKey: "switchBtn3Stat")
        if ( stat3 == "on") {
            switchBtn3.isOn = true
            datePickerTxt3.isHidden = false
            datePickerTxt3.text = UserDefaults.standard.string(forKey: "switchBtn3Time")
            startBackgroundTask3()
        }
        else {
            switchBtn3.isOn = false
            datePickerTxt3.isHidden = true
        }
        
        // SET switch 4
        let stat4 = UserDefaults.standard.string(forKey: "switchBtn4Stat")
        if ( stat4 == "on") {
            switchBtn4.isOn = true
            datePickerTxt4.isHidden = false
            datePickerTxt4.text = UserDefaults.standard.string(forKey: "switchBtn4Time")
            startBackgroundTask4()
        }
        else {
            switchBtn4.isOn = false
            datePickerTxt4.isHidden = true
        }
        
        // SET switch 5
        let stat5 = UserDefaults.standard.string(forKey: "switchBtn5Stat")
        if ( stat5 == "on") {
            switchBtn5.isOn = true
            datePickerTxt5.isHidden = false
            datePickerTxt5.text = UserDefaults.standard.string(forKey: "switchBtn5Time")
            startBackgroundTask5()
        }
        else {
            switchBtn5.isOn = false
            datePickerTxt5.isHidden = true
        }
        
    }

    
    
    
    
    
    @IBAction func switch1Changed(_ sender: UISwitch){
        
        
        
        if switchBtn1.isOn {
            if checkChildProfile() {
                datePickerTxt1.isHidden = false
                UserDefaults.standard.set("on", forKey: "switchBtn1Stat")
                startBackgroundTask()
            }
            else{
                switchBtn1.isOn = false
            }
        }
        else {
            datePickerTxt1.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn1Stat")
            UserDefaults.standard.set("", forKey: "switchBtn1Time")
            stopBackgroundTask()
        }
    }
    
    @IBAction func switch2Changed(_ sender: UISwitch) {
        if switchBtn2.isOn {
            if checkChildProfile() {
                datePickerTxt2.isHidden = false
                UserDefaults.standard.set("on", forKey: "switchBtn2Stat")
                startBackgroundTask2()
                
            }else{
                switchBtn2.isOn = false
            }
        }
        else {
            datePickerTxt2.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn2Stat")
            UserDefaults.standard.set("", forKey: "switchBtn2Time")
            stopBackgroundTask2()
            
        }
    }
    
    
    @IBAction func switch3Changed(_ sender: UISwitch) {
        if switchBtn3.isOn {
            if checkChildProfile() {
                datePickerTxt3.isHidden = false
                UserDefaults.standard.set("on", forKey: "switchBtn3Stat")
                startBackgroundTask3()
            }else{
                switchBtn3.isOn = false
            }
        }
        else {
            datePickerTxt3.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn3Stat")
            UserDefaults.standard.set("", forKey: "switchBtn3Time")
            stopBackgroundTask3()
        }
    }
    
    
    @IBAction func switch4Changed(_ sender: UISwitch) {
        if switchBtn4.isOn {
            if checkChildProfile() {
                datePickerTxt4.isHidden = false
                UserDefaults.standard.set("on", forKey: "switchBtn4Stat")
                startBackgroundTask4()
            }else{
                switchBtn4.isOn = false
            }
        }
        else {
            datePickerTxt4.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn4Stat")
            UserDefaults.standard.set("", forKey: "switchBtn4Time")
            stopBackgroundTask4()
        }
    }
    
    
    @IBAction func switch5Changed(_ sender: UISwitch) {
        if switchBtn5.isOn {
            if checkChildProfile() {
                datePickerTxt5.isHidden = false
                UserDefaults.standard.set("on", forKey: "switchBtn5Stat")
                startBackgroundTask5()
            }else{
                switchBtn5.isOn = false
            }
        }
        else {
            datePickerTxt5.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn5Stat")
            UserDefaults.standard.set("", forKey: "switchBtn5Time")
            stopBackgroundTask5()
        }
    }
    
    
    func donePressed1() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt1.text=dateFormatter.string(from: datePicker1.date)
        self.view.endEditing(true)
        // save time to storage
        let time = dateFormatter.string(from: datePicker1.date)
        UserDefaults.standard.set(time, forKey: "switchBtn1Time")
        
    }
    
    func donePressed2() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt2.text=dateFormatter.string(from: datePicker2.date)
        self.view.endEditing(true)
        // save time to storage
        let time = dateFormatter.string(from: datePicker2.date)
        UserDefaults.standard.set(time, forKey: "switchBtn2Time")
    }
    
    func donePressed3() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt3.text=dateFormatter.string(from: datePicker3.date)
        self.view.endEditing(true)
        // save time to storage
        let time = dateFormatter.string(from: datePicker3.date)
        UserDefaults.standard.set(time, forKey: "switchBtn3Time")
        
    }
    
    func donePressed4() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt4.text=dateFormatter.string(from: datePicker4.date)
        self.view.endEditing(true)
        // save time to storage
        let time = dateFormatter.string(from: datePicker4.date)
        UserDefaults.standard.set(time, forKey: "switchBtn4Time")
        
    }
    
    func donePressed5() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt5.text=dateFormatter.string(from: datePicker5.date)
        self.view.endEditing(true)
        // save time to storage
        let time = dateFormatter.string(from: datePicker5.date)
        UserDefaults.standard.set(time, forKey: "switchBtn5Time")
        
    }
    
    // a function for sending text to Basma hardware
    func SendT(_ text: String) {
        print("SendTextMessage Invoked")
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
    }


}
