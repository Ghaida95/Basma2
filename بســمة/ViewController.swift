//
//  ViewController.swift
//  بســمة
//
//  Created by ShahadR on 3/16/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import UIKit


class ViewController: UIViewController{


    @IBOutlet weak var FirstPasscodeTextField: UITextField!
    
    @IBOutlet weak var SecondPasscodeTextField: UITextField!


    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        
    }


    
    
    @IBAction func AfterEnterPasscodeNextButtonPressed(_ sender: UIButton) {

        if (FirstPasscodeTextField.text == "" || SecondPasscodeTextField.text == "") {
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال الرقم السري في كلا الخانتين", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if FirstPasscodeTextField.text != SecondPasscodeTextField.text {
            let alert = UIAlertController(title: "تنبيه", message: " الرقم السري المدخل غير متطابق، الرجاء المحاولة مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            UserDefaults.standard.set( FirstPasscodeTextField.text , forKey: "Passcode")
            UserDefaults.standard.synchronize()
            
        }
        

    }//end AfterEnterPasscodeNextButtonPressed func
    
}

