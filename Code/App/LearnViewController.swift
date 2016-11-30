//
//  LearnViewController.swift
//  Oscar
//
//  Created by Michelle Valente on 04/09/16.
//

import Foundation
import UIKit

class LearnViewController: UIViewController {
    
    @IBOutlet weak var Sample1: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! RBLAppDelegate
    
    @IBAction func sample1Action(sender: AnyObject){
        appDelegate.sample = 1
    }
    @IBAction func sample2Action(sender: AnyObject) {
        appDelegate.sample = 2
    }
    @IBAction func sample3Action(sender: AnyObject) {
        appDelegate.sample = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
