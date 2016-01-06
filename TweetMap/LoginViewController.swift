//
//  LoginViewController.swift
//  TweetMap
//
//  Created by GLR on 1/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        login()
    }
    
    
    
    func login()    {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                self.performSegueWithIdentifier("login", sender: nil)
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
