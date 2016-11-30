//
//  SampleViewController.swift
//  Oscar
//
//  Created by Michelle Valente on 28/07/16.
//


import UIKit

class SampleViewController: UIViewController {
    
    //@IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var CleanCodeButton: UIButton!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var TabButtons: UISegmentedControl!
    let defaults = NSUserDefaults.standardUserDefaults()
    var commandList = Dictionary<String, Array<Command>>()
    
    let appDelegate = UIApplication.sharedApplication().delegate
                     as! RBLAppDelegate
    
    var currentTab = "Main"
    
    var typeCommand = ""
    var typeParam = ""
    
    func reloadTable()
    {
        let tv : TableViewController =
            self.childViewControllers[0] as! TableViewController
        tv.commandList = commandList
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
    }
    
    @IBAction func CleanCodeAction(sender: AnyObject) {
        commandList[currentTab]!.removeAll()
        reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [ NSForegroundColorAttributeName :
                          UIColor.whiteColor(),
                           NSFontAttributeName :
                            UIFont(name: "Helvetica-Bold",
                                   size: 12.0)!];
        let attributesSelected = [ NSForegroundColorAttributeName :
                                   UIColor.whiteColor(),
                                   NSFontAttributeName :
                                   UIFont(name: "Helvetica-Bold",
                                          size: 12.0)!];
        self.TabButtons.setTitleTextAttributes(attributes,
                                               forState:
                                               UIControlState.Normal)
        self.TabButtons.setTitleTextAttributes(attributesSelected,
                                               forState:
                                               UIControlState.Selected)
        
        self.TabButtons.layer.cornerRadius = 0.0;
        self.TabButtons.layer.borderColor = UIColor(red:0.916,
                                                    green:0.600 ,
                                                    blue:0.168 ,
                                                    alpha:1.00).CGColor
        self.TabButtons.layer.borderWidth = 1;
        
        commandList["Main"] = []
        commandList["Sensor"] = []
        
        if(appDelegate.sample == 1)
        {
            commandList["Main"]?.append(Command(type: "loop", param: -1))
            commandList["Main"]?.append(Command(type: "ledr", param: 1))
            commandList["Main"]?.append(Command(type: "ledb", param: 0))
            commandList["Main"]?.append(Command(type: "buzz", param: 500))
            commandList["Main"]?.append(Command(type: "wait", param: 1000))
            commandList["Main"]?.append(Command(type: "ledr", param: 0))
            commandList["Main"]?.append(Command(type: "ledb", param: 1))
            commandList["Main"]?.append(Command(type: "buzz", param: 500))
            commandList["Main"]?.append(Command(type: "wait", param: 1000))
            reloadTable()
        }
        if(appDelegate.sample == 2)
        {
            commandList["Main"]?.append(Command(type: "loop", param: -1))
            commandList["Main"]?.append(Command(type: "ledr", param: 1))
            commandList["Main"]?.append(Command(type: "ledb", param: 0))
            commandList["Sensor"]?.append(Command(type: "ledr", param: 0))
            commandList["Sensor"]?.append(Command(type: "ledb", param: 1))
            commandList["Sensor"]?.append(Command(type: "buzz", param: 500))
            commandList["Sensor"]?.append(Command(type: "wait", param: 1000))
            reloadTable()
        }
        if(appDelegate.sample == 3)
        {
            commandList["Main"]?.append(Command(type: "loop", param: -1))
            commandList["Main"]?.append(Command(type: "move", param: 1))
            commandList["Sensor"]?.append(Command(type: "stop", param: -1))
            commandList["Sensor"]?.append(Command(type: "wait", param: 1000))
            commandList["Sensor"]?.append(Command(type: "turn", param: 1))

            reloadTable()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
                                  sender: AnyObject?) {
        if (segue.identifier == "TransitionToTableView") {
            let childViewController = segue.destinationViewController
                as! TableViewController
            childViewController.commandList = commandList
        }
    }
    
    func saveCommand(action: UIAlertAction, _ alert:UIAlertController,
                     param:String) {
        
        let newCommand = Command(type: typeCommand,
                                 param: Int(param)!)
        
        commandList[currentTab]!.append(newCommand)
        
        reloadTable()
    }
    
    @IBAction func CleanCode(sender: AnyObject) {
        commandList[currentTab]!.removeAll()
        let tv : TableViewController = self.childViewControllers[0]
            as! TableViewController
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
    }
    
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
    
    @IBAction func ChangeTab(sender: AnyObject) {

        if(TabButtons.selectedSegmentIndex == 0){
            currentTab = "Main"
        }
        else if(TabButtons.selectedSegmentIndex == 2){
            let alert = UIAlertController(title: "Wait reaction",
                                          message: "Enter how many" +
                                                  " seconds you want oscar" +
                                                  " to wait to start executing" +
                                                  " this part",
                                                  preferredStyle: .Alert)
            
            if(commandList["Timer"]?.count == 0)
            {
                alert.addTextFieldWithConfigurationHandler({
                    (textField) -> Void in
                    textField.text = "0"
                })
                
                alert.addAction(UIAlertAction(title: "OK",
                    style: .Default, handler: { (action) -> Void in
                    let textField = alert.textFields![0] as UITextField
                    self.appDelegate.reload = "1"
                    self.appDelegate.command = "wait"
                    self.appDelegate.param = textField.text! + "000"
                }))
                
                self.presentViewController(alert, animated: true,
                                           completion: nil)
            }
            
            currentTab = "Timer"
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
    
}

