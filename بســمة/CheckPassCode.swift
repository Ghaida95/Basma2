//
//  CheckPassCode.swift
//  بســمة
//
//  Created by ShahadR on 4/16/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import Foundation
import UIKit

class CheckPassCode : UIViewController {


    @IBOutlet weak var EnterPassCodeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func EnterButtonPressed(_ sender: UIButton) {
        if EnterPassCodeTextField.text == "" {
            let alert = UIAlertController(title: "تنبيه", message: " الرجاء إدخال الرقم السري", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        
        }
        else if EnterPassCodeTextField.text != UserDefaults.standard.string(forKey: "Passcode"){
        let alert = UIAlertController(title: "تنبيه", message: "تم إدخال رقم سري غير صحيح، الرجاء المحاولة مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
    }//end EnterButtonPressed func
    
    


}
