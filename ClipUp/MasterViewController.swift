//
//  MasterViewController.swift
//  ClipUp
//
//  Created by Randhir Singh on 25/08/15.
//  Copyright (c) 2015 Randhir Singh. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundPaper")!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        // Do any additional setup after loading the view, typically from a nib.
        
        var objs = (UIApplication.sharedApplication().delegate as! AppDelegate).objects
        for obj in objs {
            self.objects.insert(obj, atIndex: objects.count)
        }
        println("objects in view did load" + objects.description)
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        var alert = UIAlertController(title: "ClipUp", message: "Enter your clip name", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler{ (textField) in
            textField.placeholder = "Ex: My Address"
        }
        let confirmAction = UIAlertAction(title: "Done", style: .Default) { (_) in
            if let field = alert.textFields![0] as? UITextField {
                
                
                                
                if(field.text != ""){
                    self.objects.insert(field.text, atIndex: self.objects.count)
                    let indexPath = NSIndexPath(forRow: self.objects.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }else{
                    self.objects.insert("Clip "+self.objects.count.description, atIndex: self.objects.count)
                    let indexPath = NSIndexPath(forRow: self.objects.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                
                //Creating User Defaults for the Clip's name with (clip1name, clip2name, ... etc) format
                NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "clip"+(self.objects.count).description+"name")
                //User default for number of clips
                NSUserDefaults.standardUserDefaults().setInteger(self.objects.count, forKey: "clips")
                NSUserDefaults.standardUserDefaults().synchronize()
                
            }
        }
        
        alert.addAction(confirmAction)
        self.presentViewController(alert, animated: true, completion: nil)

    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as? String
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        println("objects "+self.objects.description)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.text = self.objects[indexPath.row] as? String
        
        return cell

    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}

