//
//  MapViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 08/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    //MARK: - Properties
    var appDelegate : AppDelegate!
    var studentData : [StudentInformation]!
    
    //MARK: - Oulets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - View life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        setupMapViewConstraints()
        setupNavigationBar()
        getStudentData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupMapViewConstraints()
    }
    
    ///Function that presents the Information Posting View Controller
    func presentInformationPostingViewController() {
        
        /* instantiate and then present the view controller */
        let informationPostViewController = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController")
        presentViewController(informationPostViewController, animated: true, completion: nil)
    }
    
    ///Function that is called when the logout button is pressed
    func logOut() {
        
        OTMAPIClient.sharedInstance().deleteSession() {(result, error) in
            
            guard error == nil else {
                
                /* Configure the alert view to display the error */
                let errorString = error?.userInfo[NSLocalizedDescriptionKey] as? String
                let alert = UIAlertController(title: "Couldn't log out!" , message: errorString, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
        }
        
        /* Show the log in view controller */
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    //MARK: Helper functions
    
    ///Function that gets the student data 
    func getStudentData() {
        
        /* Low the alpha of the view */
        //TODO: Stuff
        
        /* Show activity to show the app is processing data*/
        let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityView.center = view.center
        activityView.startAnimating()
        view.addSubview(activityView)
        
        OTMAPIClient.sharedInstance().getStudentLocations {(result, error) in
            
            var studentInformationArray = [StudentInformation]()
            
            guard error == nil else {
                
                if let errorString = error?.userInfo[NSLocalizedDescriptionKey] as? String {
                    
                    /* Display an alert to the user to let them know that there was an error getting the student data */
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.showStudentDataDownloadAlert(errorString)
                        
                        /* Reset the view alpha and stop the activity spinner */
                        //TODO: Stuff
                        activityView.stopAnimating()
                    })
                }
                return
            }
            
            /* For each student in the return results add it to the array */
            for s in result! {
                studentInformationArray.append(StudentInformation(dictionary: s))
            }
            
            self.appDelegate.studentData = studentInformationArray
            
            /* Present the next ViewController showing the student data */
            dispatch_async(dispatch_get_main_queue(), {
                
                self.populateMapWithStudentData()
                
                /* stop the activity spinner */
                self.view.alpha = 1.0
                activityView.stopAnimating()
            })
        }
    }
    
    ///Function that populates the map with data
    func populateMapWithStudentData() {
        
        /* Get the student data */
        studentData = appDelegate.studentData
        
        /* Make an array of MKPointAnnoations */
        var annotations = [MKPointAnnotation]()
        
        /* For each student in the data... */
        for s in studentData {
            
            /* Get the lat and lon values to create a coordiante */
            let lat = CLLocationDegrees(s.latitude)
            let lon = CLLocationDegrees(s.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            /* Make the map annotation with the coordinate and other student data */
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(s.firstName) \(s.lastName)"
            annotation.subtitle = s.mediaURL
            
            /* Add the annotation to the array */
            annotations.append(annotation)
        }
        /* Add the annotations to the map */
        mapView.addAnnotations(annotations)
    }
    
    
    //MARK: -User interface helper functions
    
    ///Function that configures the map view contraints
    func setupMapViewConstraints() {
        
        /* Setup the top constraint */
        var mapViewConstraint = NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: CGRectGetHeight(navigationController!.navigationBar.frame))
        
        view.addConstraint(mapViewConstraint)
        
        /* Setup the bottom constraint */
        let tabBarHeight = CGRectGetHeight(tabBarController!.tabBar.frame)
        
        mapViewConstraint = NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -tabBarHeight)
        
        view.addConstraint(mapViewConstraint)
    }
    
    
    ///Function that configures the navigation bar
    func setupNavigationBar() {
        
        /* Set the back button on the navigation bar to be log out */
        let customLeftBarButton = UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: "logOut")
        tabBarController!.navigationItem.setLeftBarButtonItem(customLeftBarButton, animated: false)
        
        /* Set the tile of the navigation bar to be On The Map */
        tabBarController!.navigationItem.title = "On The Map"
        
        /* Create an array of bar button items */
        var customButtons = [UIBarButtonItem]()
        
        /* Create pin button */
        let pinImage = UIImage(named: "pin")
        let pinButton = UIBarButtonItem(image: pinImage, style: .Plain, target: self, action: "presentInformationPostingViewController")
        
        /* Create refresh button */
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getStudentData")
        
        /* Add the buttons to the array */
        customButtons.append(refreshButton)
        customButtons.append(pinButton)
        
        /* Add the buttons to the nav bar */
        tabBarController!.navigationItem.setRightBarButtonItems(customButtons, animated: false)
    }
    
    
    //MARK: -Map delegate helper functions
    
    ///Function that adds pins to the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    ///Function that opens the URL a student has provided when the pin detail is clicked
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
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
}
