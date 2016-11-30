//
//  ViewController.swift
//  OscarTheCar
//
//  Created by Michelle Valente on 20/08/16.
//  Copyright © 2016 Michelle Valente. All rights reserved.
//

import UIKit

class CommandViewController: UIViewController {
    
    @IBOutlet weak var LoopButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var BuzzButton: UIButton!
    @IBOutlet weak var BlueLedButton: UIButton!
    @IBOutlet weak var WaitButton: UIButton!
    @IBOutlet weak var RedLedButton: UIButton!
    @IBOutlet weak var ForwardButton: UIButton!
    @IBOutlet weak var LeftButton: UIButton!
    @IBOutlet weak var RightButton: UIButton!
    @IBOutlet weak var BackwardButton: UIButton!
    let appDelegate = UIApplication.sharedApplication().delegate
                      as! RBLAppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Return to previous screen
    @IBAction func ReturnMainMenu() {
        appDelegate.reload = "1"
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Stop Button Pressed
    @IBAction func StopButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "stop"
        appDelegate.param = "-1"
        ReturnMainMenu()
        
    }
    
    // Move Forward Button Pressed
    @IBAction func ForwardButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "move"
        appDelegate.param = "1"
        ReturnMainMenu()
    }
    
    // Turn Left Button Pressed
    @IBAction func LeftButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "turn"
        appDelegate.param = "0"
        ReturnMainMenu()
    }
    
    @IBAction func BackwardButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "move"
        appDelegate.param = "0"
        ReturnMainMenu()
    }
    
    // Turn Right Button Pressed
    @IBAction func RightButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "turn"
        appDelegate.param = "1"
        ReturnMainMenu()
    }
    
    // Loop Button Pressed
    @IBAction func LoopButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "loop"
        appDelegate.param = "-1"
        ReturnMainMenu()
    }
    
    // Blue LED Button Pressed
    @IBAction func BlueLedButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "ledb"
        let alert = UIAlertController(title: "Led command for Oscar",
                                      message: "Do you want to turn " +
                                        "on or turn off Oscar's blue light?",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Turn on", style: .Default,
            handler: { (action: UIAlertAction!) in
            self.appDelegate.param = "1"
            self.ReturnMainMenu()
        }))
        
        alert.addAction(UIAlertAction(title: "Turn off", style: .Default,
            handler: { (action: UIAlertAction!) in
            self.appDelegate.param = "0"
            self.ReturnMainMenu()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        ReturnMainMenu()
    }
    
    // Red LED Button Pressed
    @IBAction func RedLedButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "ledr"
        
        let alert = UIAlertController(title: "Led command for Oscar",
                                      message: "Do you want to turn " +
                                    "on or turn off Oscar's red light?",
                                    preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Turn on", style: .Default,
            handler: { (action: UIAlertAction!) in
            self.appDelegate.param = "1"
            self.ReturnMainMenu()
        }))
        
        alert.addAction(UIAlertAction(title: "Turn off", style: .Default,
            handler: { (action: UIAlertAction!) in
            self.appDelegate.param = "0"
            self.ReturnMainMenu()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Wait Button Pressed
    @IBAction func WaitButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "wait"
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Wait command for Oscar",
                                      message: "Enter how many seconds" +
                                      "you want oscar to wait",
                                      preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.keyboardType = UIKeyboardType.NumberPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default,
            handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.appDelegate.param = textField.text! + "000"
            self.ReturnMainMenu()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Buzz Button Pressed
    @IBAction func BuzzButtonAction(sender: AnyObject) {
        appDelegate.reload = "1"
        appDelegate.command = "buzz"
        let alert = UIAlertController(title: "Buzz command for Oscar",
                                      message: "Enter how many seconds" +
                                      "you want oscar to buzz",
                                      preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "0"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default,
            handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.appDelegate.param = textField.text! + "000"
            self.ReturnMainMenu()
        }))
        appDelegate.param = "500"
        ReturnMainMenu()
    }
    
}

