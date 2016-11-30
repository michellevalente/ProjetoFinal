//
//  Command.swift
//  Oscar
//
//  Created by Michelle Valente on 29/07/16.
//

import UIKit

class Command: NSObject {
    
    var children = [Command]()
    var type = String()
    var param = Int()
    
    // Constructors
    init(type:String, param: Int) {
        self.type = type
        self.param = param
    }
    convenience init(type:String) {
        self.init(type: type, param: -1)
    }
    
    // New command
    func addCommand(c : Command) -> Bool {
        if (type == "loop" && !(c.type == "loop")) {
            children.append(c)
            return true
        }
        return false;
    }
    
    // Delete command
    func removeCommand(index:Int) -> Bool {
        if (index > children.count){
            return false;
        }
        children.removeAtIndex(index);
        return true;
    }
    
    // Format to send the command to robot
    func serialize() -> String{
        var str = self.type
        if(type == "loop")
        {
            for (_,c) in children.enumerate() {
                str += c.toString()
            }
        }
        else if (param != -1)
        {
            str += String(param)
        }
        
        return str
    }
    
    // Format to print the command in the list of commands
    func toString() -> String {
        var str = ""
        
        if(type == "move"){
            str += "    Move "
            if(param == 1)
            {
                str += "forward"
            }
            else if(param == 0)
            {
                str += "backward"
            }
        }
        else if(type == "turn")
        {
            str += "  Turn "
            if(param == 1)
            {
                str += "right"
            }
            else if(param == 0)
            {
                str += "left"
            }
        }
        else if(type.lowercaseString.rangeOfString("led") != nil)
        {
            if(type == "ledr")
            {
                str = "Red light"
            }
            else if(type == "ledb")
            {
                str = "Blue light"
            }
            
            str += " "
            
            if(param == 1)
            {
                str += "on"
            }
            else if(param == 0)
            {
                str += "off"
            }
        }
        else if(type == "wait")
        {
            str += "   Wait "
            str += String(param/1000) + " s"
        }
        else if(type == "buzz")
        {
            str += "  Honk "
        }
        else if(type == "stop")
        {
            str += "  Stop "
        }
        else if(type == "loop")
        {
            str += "Repeat "
        }
        
        return str
        
    }
}
