//
//  UnlockStories.swift
//  بســمة
//
//  Created by Ghada&Hadeel on 5/16/17.
//  Copyright © 2017 iWAN. All rights reserved.
//

import UIKit

class UnlockStories: UIViewController {

    @IBOutlet weak var lock: UIImageView!
  // @IBOutlet var lock: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if the second story is locked or not
        let story2unlocked = UserDefaults.standard.bool(forKey: "story2unlocked")
        
        if (story2unlocked == true) {
        // remove the lock from the story
            lock.isHidden = true
        }
        else {
          lock.isHidden = false
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
