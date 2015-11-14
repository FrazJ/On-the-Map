//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 08/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    //MARK: - Properties
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var sortedStudentData = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adjust the tableView so that it's not covered by the tab bar
        let adjustForTabBar = UIEdgeInsetsMake(0, 0, CGRectGetHeight(tabBarController!.tabBar.frame), 0)
        tableView.contentInset = adjustForTabBar
        
        //Sort the student data so that it is in order of latest to oldest created
        sortedStudentData = appDelegate.studentData.sort() {$0.createdAt.compare($1.createdAt) == NSComparisonResult.OrderedDescending}
    }

    // MARK: - Table view data source

    ///Function for defining the number of rows the table should have.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentData.count
    }

    ///Function for defining the contents of each row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")!
        
        let student = sortedStudentData[indexPath.row]
        
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.mediaURL


        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let toOpen = cell.detailTextLabel?.text {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}
