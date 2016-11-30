
//  PlayViewController.swift
//  Oscar
//
//  Created by Michelle Valente on 28/07/16.

import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var CleanCodeButton: UIButton!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var TabButtons: UISegmentedControl!
    var commandList = Dictionary<String, Array<Command>>()
    let appDelegate = UIApplication.sharedApplication().delegate
                      as! RBLAppDelegate
    
    var currentTab = "Main"
    var typeCommand = ""
    var typeParam = ""
    
    // Update table of commands
    func reloadTable()
    {
        let tv : TableViewController = self.childViewControllers[0]
                                       as! TableViewController
        tv.commandList = commandList
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
    }

    // Clean all the table
    @IBAction func CleanCodeAction(sender: AnyObject) {
        commandList[currentTab]!.removeAll()
        reloadTable()
    }
    
    // Save new command to the table
    func saveCommand()
    {
        let type = appDelegate.command
        let param = appDelegate.param
        let newCommand = Command(type: type!, param: Int(param!)!)
        commandList[currentTab]?.append(newCommand)
        reloadTable()
    }
    func saveCommand(action: UIAlertAction, _ alert:UIAlertController,
                    param:String) {
        let newCommand = Command(type: typeCommand, param: Int(param)!)
        commandList[currentTab]!.append(newCommand)
        reloadTable()
    }
    
    // Come back from previous screen
    override func viewDidAppear(animated: Bool) {
        if(appDelegate.reload == "1" )
        {
            saveCommand()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [ NSForegroundColorAttributeName : UIColor.whiteColor(),
                           NSFontAttributeName : UIFont(name: "Helvetica-Bold",
                                                        size: 12.0)!];
        let attributesSelected = [ NSForegroundColorAttributeName :
                                   UIColor.whiteColor(),
                                   NSFontAttributeName :
                                   UIFont(name: "Helvetica-Bold", size: 12.0)!];
        self.TabButtons.setTitleTextAttributes(attributes,
                                               forState: UIControlState.Normal)
        self.TabButtons.setTitleTextAttributes(attributesSelected,
                                               forState: UIControlState.Selected)
        
        self.TabButtons.layer.cornerRadius = 0.0;
        self.TabButtons.layer.borderColor = UIColor(red:0.916,
                                                    green:0.600 ,
                                                    blue:0.168 ,
                                                    alpha:1.00).CGColor
        self.TabButtons.layer.borderWidth = 1;
        
        if(appDelegate.reload == "1")
        {
            saveCommand()
            appDelegate.reload = "0"
        }
        else{
            commandList["Main"] = []
            commandList["Timer"] = []
            commandList["Sensor"] = []
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Prepare to go to next screen
    override func prepareForSegue(segue: UIStoryboardSegue,
                                  sender: AnyObject?) {
        if (segue.identifier == "TransitionToTableView") {
            let childViewController = segue.destinationViewController
                                      as! TableViewController
            childViewController.commandList = commandList
        }
    }

    // Send Code to Robot
    @IBAction func SendCode(sender: AnyObject) {

        
        let sendCode: RBLSendCode = RBLSendCode()
        sendCode.text = "0";
        for command in commandList["Main"]!{
            sendCode.text = sendCode.text + command.serialize()
        }
        if(commandList["Sensor"]?.count > 0)
        {
            sendCode.text = sendCode.text + "|1";
            for command in commandList["Sensor"]!{
                sendCode.text = sendCode.text + command.serialize()
            }
        }

        sendCode.text = sendCode.text + "/"
        
        // Break the code for the bluetooth
        if (sendCode.text.characters.count > 16){
            let array_code = Array( sendCode.text.characters)
            for index in 0.stride(to: array_code.count, by: 16) {
                sendCode.text  = String(array_code[index..<min(index+16,
                                        array_code.count)])
                sendCode.sendCodeArduino()
            }
        }
        else{
            sendCode.sendCodeArduino()
        }
        
    }
    
    // Change reaction tab
    @IBAction func ChangeTab(sender: AnyObject) {
        if(TabButtons.selectedSegmentIndex == 0){
            currentTab = "Main"
        }
        else{
            currentTab = "Sensor"
        }
        let tv : TableViewController = self.childViewControllers[0]
                                       as! TableViewController
        tv.commandList = commandList
        tv.currentTab = currentTab
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
    }
    
    // Stop Robot from executing any command
    @IBAction func StopOscarAction(sender: AnyObject) {
        
        let newCommand = Command(type: "stop");
        let sendCode: RBLSendCode = RBLSendCode()
        sendCode.text = "0" + newCommand.serialize() + "/";
        sendCode.sendCodeArduino()
    }
    
}

