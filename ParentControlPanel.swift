//
//  ParentControlPanel.swift
//  بســمة
//
//  Created by ShahadR on 4/14/17.
//  Copyright © 2017 iWAN. All rights reserved.
// version 5

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
    var childChoice = ""//sent from bluetooth

    
    // a function for sending text to Basma hardware
    func SendT(_ text: String) {
        let TextData: String
        TextData = text
        BleManagerNew.getInstance().writeValue(data: TextData.data(using: String.Encoding.utf8)!, forCharacteristic: BleManagerNew.getInstance().characteristicForWrite!, type: CBCharacteristicWriteType.withoutResponse)
        print("SendTextMessage Invoked-- Msg: "+text)

    }//end sendT func
    
    

    override func viewDidLoad() {
     super.viewDidLoad()
        // get bluetooth instance
        BleManagerNew.getInstance().delegate=self
        
        // create chart
         lineChart = LineChart()

        // load stars values
        totalStars = UserDefaults.standard.integer(forKey: "totalStars")
        displayedStars = UserDefaults.standard.integer(forKey: "displayedStars")
        morningStars = UserDefaults.standard.integer(forKey: "morningStars")
        nightStars = UserDefaults.standard.integer(forKey: "nightStars")
        brushTeethStars = UserDefaults.standard.integer(forKey: "brushTeethStars")
        kissParentsStars = UserDefaults.standard.integer(forKey: "kissParentsStars")
        bedtimeStars = UserDefaults.standard.integer(forKey: "bedtimeStars")
        
        
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
    
    // method to create the child progress chart based on the stored values
    func createChart() {
        
        // clearprevious chart
        lineChart.clear()
       
        var views: [String: AnyObject] = [:]
        
        // get the stars values from the local storage to display them in the chart
        let data = [CGFloat(morningStars), CGFloat(nightStars), CGFloat(brushTeethStars), CGFloat(kissParentsStars), CGFloat(bedtimeStars)]
    
        // set chart spesific properties
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.x.labels.visible = false
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
        
        
    } // end createChart method
    
    func calculateSeconds (datePickerTxt: UITextField) -> Int {
        
        //to get user input
        let dateFromUserOne = datePickerTxt.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: dateFromUserOne!)
        let calendar1 = Calendar.current
        let userhr = calendar1.component(.hour, from: date!)
        let usermin = calendar1.component(.minute, from: date!)
    
        //to get current date
        let dateOne = Date()
        let dateFormatterOne = DateFormatter()
        dateFormatterOne.timeStyle = .short
        dateFormatterOne.dateStyle = .none
        let dateFromSystemOne = dateFormatterOne.string(from: dateOne)
        let calendar = Calendar.current
        let syshr = calendar.component(.hour, from: dateOne)
        let sysmin = calendar.component(.minute, from: dateOne)
        
        
        let startHours = syshr * 60
        let startMinutes = sysmin + startHours
        let endHours = userhr * 60
        let endMinutes = usermin + endHours
        
        var timeDifference = endMinutes - startMinutes
        
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day // 10
        }
        print ("timeDifference ")
        print ((timeDifference * 60))
        return (timeDifference * 60)
    }
    
    func repeatTimerAfter24 (reminderNo:Int){
        switch (reminderNo){
        case 1:
            timer.invalidate()//stop timer
            first1 = true
            if (UserDefaults.standard.string(forKey: "switchBtn1Stat") == "on")
            {
                //start time after 24 hrs
                print ("start timer 1 after 24 hrs")
                timer = Timer.scheduledTimer(timeInterval:86400, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }else{
                backgroundTask.stopBackgroundTask()//stop background task
            }
        case 2:
            timer2.invalidate()//stop timer
            first2 = true
            if (UserDefaults.standard.string(forKey: "switchBtn2Stat") == "on")
            {
                //start time after 24 hrs
                print ("start timer 2 after 24 hrs")
                timer2 = Timer.scheduledTimer(timeInterval:86400, target: self, selector: #selector(timerAction2), userInfo: nil, repeats: true)
            }else{
                backgroundTask2.stopBackgroundTask()//stop background task
            }
        case 3:
            timer3.invalidate()//stop timer
            first3 = true
            if (UserDefaults.standard.string(forKey: "switchBtn3Stat") == "on")
            {
                //start time after 24 hrs
                print ("start timer 3 after 24 hrs")
                timer3 = Timer.scheduledTimer(timeInterval:86400, target: self, selector: #selector(timerAction3), userInfo: nil, repeats: true)
            }else{
                backgroundTask3.stopBackgroundTask()//stop background task
            }
        case 4:
            timer4.invalidate()//stop timer
            first4 = true
            if (UserDefaults.standard.string(forKey: "switchBtn4Stat") == "on")
            {
                //start time after 24 hrs
                print ("start timer 4 after 24 hrs")
                timer4 = Timer.scheduledTimer(timeInterval:86400, target: self, selector: #selector(timerAction4), userInfo: nil, repeats: true)
            }else{
                backgroundTask4.stopBackgroundTask()//stop background task
            }
        case 5:
            timer5.invalidate()//stop timer
            first5 = true
            if (UserDefaults.standard.string(forKey: "switchBtn5Stat") == "on")
            {
                //start time after 24 hrs
                print ("start timer 5 after 24 hrs")
                timer5 = Timer.scheduledTimer(timeInterval:86400, target: self, selector: #selector(timerAction5), userInfo: nil, repeats: true)
            }else{
                backgroundTask5.stopBackgroundTask()//stop background task
            }
        default:
            print ("in switch default")
        }
    }
    
    
    //stop Background Task for reminder
    func stopBackgroundTask(timer: Timer, backgroundTask: BackgroundTask) {
        timer.invalidate()//stop timer
        backgroundTask.stopBackgroundTask()//stop background task
        
    }//end stopBackgroundTask
    
    ///////background task for first-1- reminder//////////////////
    @IBAction func doneEditingMorning(_ sender: Any)
    {
        timer.invalidate()//stop previous timer
        
        print ("done editing 1")
        if ((UserDefaults.standard.string(forKey: "switchBtn1Stat") == "on") ) {
            
            let sec = calculateSeconds(datePickerTxt: datePickerTxt1)
            
            //start Background Task
            print ("start Background Task 1")
            backgroundTask.startBackgroundTask()
            //start time
            print ("start timer 1")
            timer = Timer.scheduledTimer(timeInterval:TimeInterval(sec), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }

    //this is the function that will be called in the background when morning reminder fires
    var first1 = true;
    func timerAction() {
        if (first1){
            first1 = false
            SendT("A1")
            sleep(3)
            SendT("W:mo1")
            flag = true
            receive1()//(actionName: "morningAthkar", yesSound:"W:en1", noSound:"W:moNo")
        }
        
        print("in timerAction1")//just for test
        repeatTimerAfter24(reminderNo: 1)

    }//end timerAction1
    
    var touchTimer :Timer!
    var flag = true
    func receive1 (){//actionName: String, yesSound: String, noSound: String){
        //"morningAthkar", yesSound:"W:en1", noSound:"W:moNo"
        if( flag )
        {
            touchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(receive1), userInfo: nil, repeats: true)
        }
        sleep(3)
        
        childChoice = BleManagerNew.getInstance().recive
        print("Input recieved " + childChoice)
        
        if (childChoice == "" || childChoice == "9"){
            print("No input recieved")
            if (flag )  {
                flag = false
                SendT("T")
            }
            return
        }//end if
        else{
            print("input recieved. Value: " + childChoice)
            if (childChoice == "0") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                calculateStars(action: "morningAthkar")
            }//end if
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                displayStars()
            }//end else if
            
            
            print("stopping touch timer 1")
            touchTimer.invalidate()
            flag = true
        }//end else
        
        childChoice = ""
    }


    ///////background task for second-2- reminder//////////////////
    @IBAction func doneEditingEvening(_ sender: Any) {
        timer2.invalidate()//stop previous timer
        
        print ("done editing 2")
        if ((UserDefaults.standard.string(forKey: "switchBtn2Stat") == "on") ) {
            
            let sec = calculateSeconds(datePickerTxt: datePickerTxt2)
            
            //start Background Task
            print ("start Background Task 2")
            backgroundTask2.startBackgroundTask()
            //start time
            print ("start timer 2")
            timer2 = Timer.scheduledTimer(timeInterval:TimeInterval(sec), target: self, selector: #selector(timerAction2), userInfo: nil, repeats: true)
        }
    }

    //this is the function that will be called in the background when evening reminder fires
    var first2 = true;
    func timerAction2() {
        if (first2){
            first2 = false
            SendT("A2")
            sleep(3)
            SendT("W:ev1")
            flag = true
            receive2()//(actionName: "nightAthkar", yesSound:"W:en2", noSound:"W:evNo")
        }
        
        print("in timerAction2")//just for test
        repeatTimerAfter24(reminderNo: 2)
        
    }//end timerAction2
    
    
    func receive2 (){
        if( flag )
        {
            touchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(receive2), userInfo: nil, repeats: true)
        }
        sleep(3)
        
        childChoice = BleManagerNew.getInstance().recive
        print("Input recieved " + childChoice)
        
        if (childChoice == "" || childChoice == "9"){
            print("No input recieved")
            if (flag )  {
                flag = false
                SendT("T")
            }
            return
        }//end if
        else{
            print("input recieved. Value: " + childChoice)
            if (childChoice == "0") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                calculateStars(action: "nightAthkar")
            }//end if
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                displayStars()
            }//end else if
            
            
            print("stopping touch timer 2")
            touchTimer.invalidate()
            flag = true
        }//end else
        
        childChoice = ""
    }

    
    ///////backgeound task for third-3- reminder//////////////////
    @IBAction func doneEditingBrush(_ sender: Any) {
        timer3.invalidate()//stop previous timer
        
        print ("done editing 3")
        if ((UserDefaults.standard.string(forKey: "switchBtn3Stat") == "on") ) {
            
            let sec = calculateSeconds(datePickerTxt: datePickerTxt3)
            
            //start Background Task
            print ("start Background Task 3")
            backgroundTask3.startBackgroundTask()
            //start time
            print ("start timer 3")
            timer3 = Timer.scheduledTimer(timeInterval:TimeInterval(sec), target: self, selector: #selector(timerAction3), userInfo: nil, repeats: true)
        }

    }
    
    //this is the function that will be called in the background when brushing reminder fires
    var first3 = true;
    func timerAction3() {
        if (first3){
            first3 = false
            SendT("A3")
            sleep(3)
            SendT("W:te1")
            flag = true
            receive3()//(actionName: "brushingTeeth", yesSound:"W:en3", noSound:"W:TeNo")
        }
        
        print("in timerAction3")//just for test
        repeatTimerAfter24(reminderNo: 3)
        
    }//end timerAction3
    
    func receive3 (){
        if( flag )
        {
            touchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(receive3), userInfo: nil, repeats: true)
        }
        sleep(3)
        
        childChoice = BleManagerNew.getInstance().recive
        print("Input recieved " + childChoice)
        
        if (childChoice == "" || childChoice == "9"){
            print("No input recieved")
            if (flag )  {
                flag = false
                SendT("T")
            }
            return
        }//end if
        else{
            print("input recieved. Value: " + childChoice)
            if (childChoice == "0") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                calculateStars(action: "brushingTeeth")
            }//end if
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                displayStars()
            }//end else if
            
            
            print("stopping touch timer 3")
            touchTimer.invalidate()
            flag = true
        }//end else
        
        childChoice = ""
    }
    
    ///////backgeound task for forth-4- reminder//////////////////
    @IBAction func doneEditingKiss(_ sender: Any) {
        timer4.invalidate()//stop previous timer
        
        print ("done editing 4")
        if ((UserDefaults.standard.string(forKey: "switchBtn4Stat") == "on") ) {
            
            let sec = calculateSeconds(datePickerTxt: datePickerTxt4)
            
            //start Background Task
            print ("start Background Task 4")
            backgroundTask4.startBackgroundTask()
            //start time
            print ("start timer 4")
            timer4 = Timer.scheduledTimer(timeInterval:TimeInterval(sec), target: self, selector: #selector(timerAction4), userInfo: nil, repeats: true)
        }
    }

    //this is the function that will be called in the background when kiss reminder fires
    var first4 = true;
    func timerAction4() {
        if (first4){
            first4 = false
            SendT("A4")
            sleep(3)
            SendT("W:ki1")
            flag = true
            receive4()//(actionName: "kissingParents", yesSound:"W:en4", noSound:"W:kiNo")
        }
        
        print("in timerAction4")//just for test
        repeatTimerAfter24(reminderNo: 4)
        
    }//end timerAction4
    
    func receive4 (){
        if( flag )
        {
            touchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(receive4), userInfo: nil, repeats: true)
        }
        sleep(3)
        
        childChoice = BleManagerNew.getInstance().recive
        print("Input recieved " + childChoice)
        
        if (childChoice == "" || childChoice == "9"){
            print("No input recieved")
            if (flag )  {
                flag = false
                SendT("T")
            }
            return
        }//end if
        else{
            print("input recieved. Value: " + childChoice)
            if (childChoice == "0") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                calculateStars(action: "kissingParents")
            }//end if
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                displayStars()
            }//end else if
            
            
            print("stopping touch timer 4")
            touchTimer.invalidate()
            flag = true
        }//end else
        
        childChoice = ""
    }
    
    ///////backgeound task for fifth-5- reminder//////////////////
    
    @IBAction func doneEditingSleep(_ sender: Any) {
        timer5.invalidate()//stop previous timer
        
        print ("done editing 5")
        if ((UserDefaults.standard.string(forKey: "switchBtn5Stat") == "on") ) {
            
            let sec = calculateSeconds(datePickerTxt: datePickerTxt5)
            
            //start Background Task
            print ("start Background Task 5")
            backgroundTask5.startBackgroundTask()
            //start time
            print ("start timer 5")
            timer5 = Timer.scheduledTimer(timeInterval:TimeInterval(sec), target: self, selector: #selector(timerAction5), userInfo: nil, repeats: true)
        }

    }

    //this is the function that will be called in the background when bedtime reminder fires
    var first5 = true;
    func timerAction5() {
        if (first5){
            first5 = false
            SendT("A5")
            sleep(3)
            SendT("W:Sl1")
            flag = true
            receive5()//(actionName: "bedtimeAthkar", yesSound:"W:Ysle", noSound:"W:Nsle")
        }
        
        print("in timerAction5")//just for test
        repeatTimerAfter24(reminderNo: 5)
        
    }//end timerAction5
    
    func receive5 (){
        if( flag )
        {
            touchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(receive5), userInfo: nil, repeats: true)
        }
        sleep(3)
        
        childChoice = BleManagerNew.getInstance().recive
        print("Input recieved " + childChoice)
        
        if (childChoice == "" || childChoice == "9"){
            print("No input recieved")
            if (flag )  {
                flag = false
                SendT("T")
            }
            return
        }//end if
        else{
            print("input recieved. Value: " + childChoice)
            if (childChoice == "0") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                calculateStars(action: "bedtimeAthkar")
            }//end if
                // take first choice (Left sensor)
            else if (childChoice == "1") {
                
                BleManagerNew.getInstance().recive = ""
                sleep(4)
                displayStars()
            }//end else if
            
            
            print("stopping touch timer5")
            touchTimer.invalidate()
            flag = true
        }//end else
        
        childChoice = ""
    }

    
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
    
    func unlockStory() {
        UserDefaults.standard.set(true, forKey:"story2unlocked")
    }
    
    func displayStars(){
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
        
        SendT(starsMsg)
    }
    // method to calculate stars and store them
    func calculateStars(action: String) {
        
        totalStars += 1
        print( "total stars" + String(totalStars) )
        
        // set the number of stars that will be displayed on Basma's screen
        // if its more than 125, reset the number of stars and start again
        if (totalStars > 125) {
            displayedStars = 0
            totalStars = 1
            morningStars = 0
            nightStars = 0
            brushTeethStars = 0
            kissParentsStars = 0
            bedtimeStars = 0
            SendT("S0")
            
        }
        else if (totalStars == 125) {
            SendT("S5")
            sleep(4)
            displayedStars = 5
            SendT("W:5s") //send to wave
            
            // unlock new story
            unlockStory()
        }
        else if (totalStars >= 100) {
            displayedStars = 4
            if(totalStars==100){SendT("W:newS")
                sleep(4)
                SendT("S4")}//send to wave
        }
        else if (totalStars >= 75) {
            displayedStars = 3
            if(totalStars==75){SendT("W:newS")
                sleep(4)
                SendT("S3")}//send to wave
        }
        else if (totalStars >= 50) {
            displayedStars = 2
            if(totalStars==50){SendT("W:newS")
                sleep(4)
                SendT("S2")}//send to wave
        }
        else if (totalStars >= 25) {
            displayedStars = 1
            if(totalStars==25){SendT("W:newS")
            sleep(4)
            SendT("S1")}//send to wave
        }
        else {
        displayedStars = 0
            print("0 stars")
            SendT("S0")
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
        // update chart
        createChart()
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
                datePickerTxt1.text = ""
                UserDefaults.standard.set("on", forKey: "switchBtn1Stat")
            }
            else{
                switchBtn1.isOn = false
            }
        }
        else {
            datePickerTxt1.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn1Stat")
            UserDefaults.standard.set("", forKey: "switchBtn1Time")
            stopBackgroundTask(timer: timer, backgroundTask: backgroundTask )
        }
    }
    
    @IBAction func switch2Changed(_ sender: UISwitch) {
        if switchBtn2.isOn {
            if checkChildProfile() {
                datePickerTxt2.isHidden = false
                datePickerTxt2.text = ""
                UserDefaults.standard.set("on", forKey: "switchBtn2Stat")
            }else{
                switchBtn2.isOn = false
            }
        }
        else {
            datePickerTxt2.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn2Stat")
            UserDefaults.standard.set("", forKey: "switchBtn2Time")
            stopBackgroundTask(timer: timer2, backgroundTask: backgroundTask2)
            
        }
    }
    
    
    @IBAction func switch3Changed(_ sender: UISwitch) {
        if switchBtn3.isOn {
            if checkChildProfile() {
                datePickerTxt3.isHidden = false
                datePickerTxt3.text = ""
                UserDefaults.standard.set("on", forKey: "switchBtn3Stat")
            }else{
                switchBtn3.isOn = false
            }
        }
        else {
            datePickerTxt3.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn3Stat")
            UserDefaults.standard.set("", forKey: "switchBtn3Time")
            stopBackgroundTask(timer: timer3, backgroundTask: backgroundTask3)
        }
    }
    
    
    @IBAction func switch4Changed(_ sender: UISwitch) {
        if switchBtn4.isOn {
            if checkChildProfile() {
                datePickerTxt4.isHidden = false
                datePickerTxt4.text = ""
                UserDefaults.standard.set("on", forKey: "switchBtn4Stat")
            }else{
                switchBtn4.isOn = false
            }
        }
        else {
            datePickerTxt4.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn4Stat")
            UserDefaults.standard.set("", forKey: "switchBtn4Time")
            stopBackgroundTask(timer: timer4, backgroundTask: backgroundTask4)
        }
    }
    
    
    @IBAction func switch5Changed(_ sender: UISwitch) {
        if switchBtn5.isOn {
            if checkChildProfile() {
                datePickerTxt5.isHidden = false
                datePickerTxt5.text = ""
                UserDefaults.standard.set("on", forKey: "switchBtn5Stat")
            }else{
                switchBtn5.isOn = false
            }
        }
        else {
            datePickerTxt5.isHidden = true
            UserDefaults.standard.set("off", forKey: "switchBtn5Stat")
            UserDefaults.standard.set("", forKey: "switchBtn5Time")
            stopBackgroundTask(timer: timer5, backgroundTask: backgroundTask5)
        }
    }
    
    
    func donePressed1() {
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt1.text=dateFormatter.string(from: datePicker1.date)
        // save time to storage
        let time = dateFormatter.string(from: datePicker1.date)
        
        if ((UserDefaults.standard.string(forKey: "switchBtn2Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn3Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn4Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn5Time")==time))
        {
            let alertController = UIAlertController(title: "وقت مكرر", message: "رجاءً قم باختيار وقت اخر", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "اخفاء", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.view.endEditing(true)
            UserDefaults.standard.set(time, forKey: "switchBtn1Time")
        }
    }
    
    func donePressed2() {
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt2.text=dateFormatter.string(from: datePicker2.date)
        // save time to storage
        let time = dateFormatter.string(from: datePicker2.date)
        
        if ((UserDefaults.standard.string(forKey: "switchBtn1Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn3Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn4Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn5Time")==time))
        {
            let alertController = UIAlertController(title: "وقت مكرر", message: "رجاءً قم باختيار وقت اخر", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "اخفاء", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.view.endEditing(true)
            UserDefaults.standard.set(time, forKey: "switchBtn2Time")
        }
    }
    
    func donePressed3() {
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt3.text=dateFormatter.string(from: datePicker3.date)
        // save time to storage
        let time = dateFormatter.string(from: datePicker3.date)
        
        if ((UserDefaults.standard.string(forKey: "switchBtn1Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn2Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn4Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn5Time")==time))
        {
            let alertController = UIAlertController(title: "وقت مكرر", message: "رجاءً قم باختيار وقت اخر", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "اخفاء", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.view.endEditing(true)
            UserDefaults.standard.set(time, forKey: "switchBtn3Time")
        }
        
    }
    
    func donePressed4() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt4.text=dateFormatter.string(from: datePicker4.date)
        // save time to storage
        let time = dateFormatter.string(from: datePicker4.date)
        
        if ((UserDefaults.standard.string(forKey: "switchBtn1Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn2Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn3Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn5Time")==time))
        {
            let alertController = UIAlertController(title: "وقت مكرر", message: "رجاءً قم باختيار وقت اخر", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "اخفاء", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.view.endEditing(true)
            UserDefaults.standard.set(time, forKey: "switchBtn4Time")
        }
    }
    
    func donePressed5() {
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        datePickerTxt5.text=dateFormatter.string(from: datePicker5.date)
        // save time to storage
        let time = dateFormatter.string(from: datePicker5.date)
        
        if ((UserDefaults.standard.string(forKey: "switchBtn1Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn2Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn3Time")==time) ||
            (UserDefaults.standard.string(forKey: "switchBtn4Time")==time))
        {
            let alertController = UIAlertController(title: "وقت مكرر", message: "رجاءً قم باختيار وقت اخر", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "اخفاء", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.view.endEditing(true)
            UserDefaults.standard.set(time, forKey: "switchBtn5Time")
        }
    }
    

}
