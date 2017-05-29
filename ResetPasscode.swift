//
//  ResetPasscode.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/15/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import Foundation
import UIKit


class ResetPasscode: UIViewController {
    
 
    @IBOutlet weak var SecondPasscodeTextField: UITextField!

    @IBOutlet weak var FirstPasscodeTextField: UITextField!
    
    @IBOutlet weak var Answer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set( "" , forKey: "Passcode")
        
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
            
        }
        else if ( (Answer.text != "رياض ") && (Answer.text != "رياض") && (Answer.text != "الرياض") && (Answer.text != "الرياض ") ){
            let alert = UIAlertController(title: "تنبيه", message: "إجابة السؤال خاطئة ،الرجاء المحاول مرة أخرى" + Answer.text!, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            UserDefaults.standard.set( FirstPasscodeTextField.text , forKey: "Passcode")
            UserDefaults.standard.synchronize()
            
        }
        
        
    }//end AfterEnterPasscodeNextButtonPressed func
    
   }
