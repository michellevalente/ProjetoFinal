
//  DriverController.swift
//  Oscar
//
//  Created by Michelle Valente on 20/08/16.

import UIKit

class DriverViewController: UIViewController {
    
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var BuzzButton: UIButton!
    @IBOutlet weak var BlueLedButton: UIButton!
    @IBOutlet weak var RedLedButton: UIButton!
    @IBOutlet weak var ForwardButton: UIButton!
    @IBOutlet weak var LeftButton: UIButton!
    @IBOutlet weak var RightButton: UIButton!
    @IBOutlet weak var BackwardButton: UIButton!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Send code to robot
    func SendCode(command: Command) {
        
        let sendCode: RBLSendCode = RBLSendCode()
        sendCode.text = "0" + command.serialize() + "/";
        sendCode.sendCodeArduino()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Stop Button Pressed
    @IBAction func StopButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "stop");
        SendCode(newCommand);
    }
    
    // Move Forward Button Pressed
    @IBAction func ForwardButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "move", param: 1);
        SendCode(newCommand);
    }
    
    // Turn Left Button Pressed
    @IBAction func LeftButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "turn", param: 0);
        SendCode(newCommand);
    }
    
    // Move Backwards Button Pressed
    @IBAction func BackwardButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "move", param: 0);
        SendCode(newCommand);
    }
    
    // Turn Right Button Pressed
    @IBAction func RightButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "turn", param: 1);
        SendCode(newCommand);
    }
    
    // Blue LED Button Pressed
    @IBAction func BlueLedButtonAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Led command for Oscar",
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "ON", style: .Default,
            handler: { (action: UIAlertAction!) in
            let newCommand = Command(type: "ledb", param: 1);
            self.SendCode(newCommand);
        }))
        
        alert.addAction(UIAlertAction(title: "OFF", style: .Default,
            handler: { (action: UIAlertAction!) in
            
            let newCommand = Command(type: "ledb", param: 0);
            self.SendCode(newCommand);
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Red LED Button Pressed
    @IBAction func RedLedButtonAction(sender: AnyObject) {

        let alert = UIAlertController(title: "Led command for Oscar",
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "ON", style: .Default,
            handler: { (action: UIAlertAction!) in
            let newCommand = Command(type: "ledr", param: 1);
            self.SendCode(newCommand);
        }))
        
        alert.addAction(UIAlertAction(title: "OFF", style: .Default,
            handler: { (action: UIAlertAction!) in
 
            let newCommand = Command(type: "ledr", param: 0);
            self.SendCode(newCommand);
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Time Wait Button Pressed
    @IBAction func WaitButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "wait", param: 500);
        SendCode(newCommand);
    }
    
    // Buzz Button Pressed
    @IBAction func BuzzButtonAction(sender: AnyObject) {
        let newCommand = Command(type: "buzz", param: 500);
        SendCode(newCommand);
        
    }
}

