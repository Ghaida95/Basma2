//
//  EditAddChild.swift
//  بســمة
//
//  Created by ShahadR on 4/15/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import UIKit
/*protocol DataSentDelegate{
    func userDidEnterData(data: String)
}*/

class EditAddChild: UIViewController {
    
   // var delegate: DataSentDelegate? = nil
 
    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var SaveChildButton: UIButton!
    @IBOutlet weak var Box2: UIButton!
    @IBOutlet weak var Box3: UIButton!
    @IBOutlet weak var Box1: UIButton!
    
    
    //to upload checked/unchecked image
    var BoxOn = UIImage(named: "checked" )
    var BoxOff = UIImage(named: "unchecked" )
    //to set value if one of boxes choosen
    var IsBoxClicked1: Bool!
    var IsBoxClicked2: Bool!
    var IsBoxClicked3: Bool!
    var IsBoxClicked4: Bool!
    
    @IBOutlet weak var childName: UITextField!
    var childN: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        //unchecked Box
        IsBoxClicked1 = false
        IsBoxClicked2 = false
        IsBoxClicked3 = false
        //save and edit button
        if UserDefaults.standard.bool(forKey: "SaveButton") == false {
            EditButton.isHidden = true
            SaveChildButton.isHidden = false
        }else{
            EditButton.isHidden = false
            SaveChildButton.isHidden = true
            childName.text = UserDefaults.standard.string(forKey: "ChildName")
            if UserDefaults.standard.bool(forKey: "Box1") == true {Box1.setImage(BoxOn, for: UIControlState.normal)}
            else if UserDefaults.standard.bool(forKey: "Box2") == true {Box2.setImage(BoxOn, for: UIControlState.normal)}
            else if UserDefaults.standard.bool(forKey: "Box3") == true {Box3.setImage(BoxOn, for: UIControlState.normal)}
            
        }
    
    }
    
    @IBAction func avatarO(_ sender: UIButton) {
        
        if IsBoxClicked1 == true {
            IsBoxClicked1 = false
        }else{
            IsBoxClicked1 = true
            IsBoxClicked2 = false
            IsBoxClicked3 = false
        }
        
        if IsBoxClicked1 == true {
            Box1.setImage(BoxOn, for: UIControlState.normal)
            Box2.setImage(BoxOff, for: UIControlState.normal)
            Box3.setImage(BoxOff, for: UIControlState.normal)
        }else{
            Box1.setImage(BoxOff, for: UIControlState.normal)
        }
    }//end avatarO func
    
    @IBAction func avatarTwo(_ sender: UIButton) {
        
        if IsBoxClicked2 == true {
            IsBoxClicked2 = false
        }else{
            IsBoxClicked2 = true
            IsBoxClicked3 = false
            IsBoxClicked1 = false
        }
        
        if IsBoxClicked2 == true {
            Box2.setImage(BoxOn, for: UIControlState.normal)
            Box1.setImage(BoxOff, for: UIControlState.normal)
            Box3.setImage(BoxOff, for: UIControlState.normal)
        }else{
            Box2.setImage(BoxOff, for: UIControlState.normal)
        }
    }//end avatar2 func
    
    @IBAction func avatarThree(_ sender: UIButton) {
        
        if IsBoxClicked3 == true {
            IsBoxClicked3 = false
        }else{
            IsBoxClicked3 = true
            IsBoxClicked2 = false
            IsBoxClicked1 = false
        }
        
        if IsBoxClicked3 == true {
            Box3.setImage(BoxOn, for: UIControlState.normal)
            Box1.setImage(BoxOff, for: UIControlState.normal)
            Box2.setImage(BoxOff, for: UIControlState.normal)
        }else{
            Box3.setImage(BoxOff, for: UIControlState.normal)
        }
    }//end avatar3 func
    


       @IBAction func SaveButtonWasPressed(_ sender: UIButton) {
        if ( childName.text == "" && !(IsBoxClicked1 || IsBoxClicked2 || IsBoxClicked3) ) {
            
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال اسم طفلتك واختيار صورة رمزية لها", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ( childName.text == "" ) {
            
            
            let alert = UIAlertController(title: "تنبيه", message: "الرجاء إدخال اسم طفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if( !(IsBoxClicked1 || IsBoxClicked2 || IsBoxClicked3) ){
            let alert = UIAlertController(title: "تنبيه", message: "الرجاء اختيار صورة رمزية لطفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ( (childName.text)!.characters.count > 30  ){
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال اسم لطفلتك لايتجاوز ال٣٠ حرفاً", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //saveButton.isHidden=true
            UserDefaults.standard.set(childName.text, forKey: "ChildName")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: "SaveButton")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked1, forKey: "Box1")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked2, forKey: "Box2")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked3, forKey: "Box3")
            UserDefaults.standard.synchronize()
            /*
             if delegate != nil{
             if childName.text != nil{
             let data = childName.text
             delegate?.userDidEnterData(data: data!)
             dismiss(animated: true, completion: nil)
             }
             
             }
             */
            
            
        }
    }//end SaveButtonWasPressed func
    
    
    @IBAction func EditButtonWasPressed(_ sender: UIButton) {
        if ( childName.text == "" && !(IsBoxClicked1 || IsBoxClicked2 || IsBoxClicked3) ) {
            
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال اسم طفلتك واختيار صورة رمزية لها", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ( childName.text == "" ) {
            
            
            let alert = UIAlertController(title: "تنبيه", message: "الرجاء إدخال اسم طفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if( !(IsBoxClicked1 || IsBoxClicked2 || IsBoxClicked3) ){
            let alert = UIAlertController(title: "تنبيه", message: "الرجاء اختيار صورة رمزية لطفلتك", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ( (childName.text)!.characters.count > 30  ){
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال اسم لطفلتك لايتجاوز ال٣٠ حرفاً", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //saveButton.isHidden=true
            UserDefaults.standard.set(childName.text, forKey: "ChildName")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: "SaveButton")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked1, forKey: "Box1")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked2, forKey: "Box2")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(IsBoxClicked3, forKey: "Box3")
            UserDefaults.standard.synchronize()
            /*
             if delegate != nil{
             if childName.text != nil{
             let data = childName.text
             delegate?.userDidEnterData(data: data!)
             dismiss(animated: true, completion: nil)
             }
             
             }
             */
            
            
        }
    }//end EditButtonWasPressed func
    
}
