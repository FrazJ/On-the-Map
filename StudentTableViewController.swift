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
    
    //MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adjust the tableView so that it's not covered by the tab bar
        let adjustForTabBar = UIEdgeInsetsMake(0, 0, CGRectGetHeight(tabBarController!.tabBar.frame), 0)
        tableView.contentInset = adjustForTabBar
        getStudentData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
        getStudentData()
    }
    
    
    //MARK: - Helper functions
    
    func getStudentData() {
        
        /* Low the alpha of the view */
        let activityView = UIView.init(frame: tableView.frame)
        activityView.backgroundColor = UIColor.grayColor()
        activityView.alpha = 0.8
        view.addSubview(activityView)
        
        //mapView.alpha = 0.3
        
        /* Show activity to show the app is processing data*/
        let activitySpinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activitySpinner.center = view.center
        activitySpinner.startAnimating()
        activityView.addSubview(activitySpinner)
        
        OTMAPIClient.sharedInstance().getStudentLocations {(result, error) in
            
            var studentInformationArray = [StudentInformation]()
            
            guard error == nil else {
                
                if let errorString = error?.userInfo[NSLocalizedDescriptionKey] as? String {
                    
                    /* Display an alert to the user to let them know that there was an error getting the student data */
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showStudentDataDownloadAlert(errorString)
                        
                        /* Show that activity has stoped */
                        activityView.removeFromSuperview()
                        activitySpinner.stopAnimating()
                    })
                }
                return
            }
            
            /* For each student in the return results add it to the array */
            for s in result! {
                studentInformationArray.append(StudentInformation(dictionary: s))
            }
            
            studentInformationArray = studentInformationArray.sort() {$0.updatedAt.compare($1.updatedAt) == NSComparisonResult.OrderedDescending}
            
            self.appDelegate.studentData = studentInformationArray
            
            /* Present the next ViewController showing the student data */
            dispatch_async(dispatch_get_main_queue(), {
                /* Show that activity has stoped */
                activityView.removeFromSuperview()
                activitySpinner.stopAnimating()
                
                /* Reload table data*/
                self.tableView.reloadData()
            })
        }

    }
    
    //MARK: -User interface functions
    ///Function that configures the navigation bar
    func setupNavigationBar() {
        
        let mapViewController = tabBarController?.viewControllers![0]
        
        /* Set the back button on the navigation bar to be log out */
        let customLeftBarButton = UIBarButtonItem(title: "Log out", style: .Plain, target: mapViewController, action: "logOut")
        tabBarController!.navigationItem.setLeftBarButtonItem(customLeftBarButton, animated: false)
        
        /* Create an array of bar button items */
        var customButtons = [UIBarButtonItem]()
        
        /* Create pin button */
        let pinImage = UIImage(named: "pin")
        let pinButton = UIBarButtonItem(image: pinImage, style: .Plain, target: mapViewController, action: "presentInformationPostingViewController")
        
        /* Create refresh button */
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getStudentData")
        
        /* Add the buttons to the array */
        customButtons.append(refreshButton)
        customButtons.append(pinButton)
        
        /* Add the buttons to the nav bar */
        tabBarController!.navigationItem.setRightBarButtonItems(customButtons, animated: false)
    }
    
    func getAttributedText(textToStyle: String) -> NSMutableAttributedString {
        
        let rangeToStyle = NSRange.init(location: 0, length: (textToStyle as NSString).length)
        let attributedText = NSMutableAttributedString(string: textToStyle)
        let font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        attributedText.addAttributes([NSFontAttributeName: font!], range: rangeToStyle)
        
        return attributedText
    }
    
    //MARK: -Error helper functions
    
    ///Function that presents a alert to notify the user that a download of the student data has failed
    func showStudentDataDownloadAlert(errorString: String) {
        showAlert("Download failed", errorString: errorString)
    }
    
    ///Function that configures and shows an alert
    func showAlert(titleString: String, errorString: String) {
        
        /* Configure the alert view to display the error */
        let alert = UIAlertController(title: titleString , message: errorString, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
        
        /* Present the alert view */
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Table view data source

    ///Function for defining the number of rows the table should have.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentData.count
    }

    ///Function for defining the contents of each row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")!
        
        let student = appDelegate.studentData[indexPath.row]
        
        let textForTitle = student.firstName + " " + student.lastName

        cell.textLabel?.attributedText = getAttributedText(textForTitle)
        cell.detailTextLabel!.text = student.mediaURL

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let toOpen = cell.detailTextLabel?.text {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: toOpen)!) {
                    let url = NSURL(string: toOpen)
                    app.openURL(url!)
                } else {
                    showAlert("Unable to load webpage", errorString: "Webpage couldn't be opened because the link was invalid.")
                }
            }
        }
    }
}
