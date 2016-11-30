

//  TableViewController.swift
//  Oscar
//
//  Created by Michelle Valente on 20/08/16.

import UIKit

class TableViewController: UIViewController,
                           UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate
                      as! RBLAppDelegate
    
    var commandList = Dictionary<String, Array<Command>>()
    
    var currentTab = "Main"
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self,
                     forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if(appDelegate.reload == "1")
        {
            appDelegate.reload = "0"
        }
        else{
            commandList["Main"] = []
            commandList["Timer"] = []
            commandList["Sensor"] = []
        }
    }
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if(commandList.isEmpty)
        {
            commandList["Main"] = []
            commandList["Timer"] = []
            commandList["Sensor"] = []
        }
        return self.commandList[currentTab]!.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
                    -> UITableViewCell {
        
        let cell:UITableViewCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell")!
        as UITableViewCell
        
        cell.textLabel!.font = UIFont(name:"Helvetica-bold", size:14)
        cell.textLabel!.textColor = UIColor(red:0.916,
                                            green:0.600 ,
                                            blue:0.168 ,
                                            alpha:1.00)
        
        let current = commandList[currentTab]![indexPath.row] as Command
        
        if(current.type == "stop")
        {
            let image : UIImage = UIImage(named: "pare.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "loop")
        {
            let image : UIImage = UIImage(named: "loop.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "buzz")
        {
            let image : UIImage = UIImage(named: "honk.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "ledb")
        {
            let image : UIImage = UIImage(named: "led_azul.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "ledr")
        {
            let image : UIImage = UIImage(named: "led_vermelho.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "wait")
        {
            let image : UIImage = UIImage(named: "relogio.png")!
            cell.imageView?.image = image
        }
        else if(current.type == "move")
        {
            let image : UIImage
            if(current.param == 1){
                image = UIImage(named: "cima.png")!
            }else{
                image = UIImage(named: "baixo.png")!
            }
            cell.imageView?.image = image
        }
        else if(current.type == "turn")
        {
            let image : UIImage
            if(current.param == 1){
                image = UIImage(named: "direita.png")!
            }else{
                image = UIImage(named: "esquerda.png")!
            }
            cell.imageView?.image = image
        }
        cell.textLabel?.text = commandList[currentTab]![indexPath.row].toString()
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView,
                   canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView,
                   commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                   forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let tv : PlayViewController = self.childViewControllers[0]
                as! PlayViewController
            tv.commandList[currentTab]!.removeAtIndex(indexPath.row)
            commandList = tv.commandList
            self.tableView.reloadData()
        }
    }
    
}
