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
        
        populateMapWithStudentData()
        setupMapViewConstraints()
        setupNavigationBar()
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
    
    ///Function that populates the map with data
    func populateMapWithStudentData() {
        
        /* Get the student data */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        
        /* Set the pin button to be in the right corner of the navigation bar */
        let pinImage = UIImage(named: "pin")
        let customRightBarButton = UIBarButtonItem(image: pinImage, style: .Plain, target: self, action: "presentInformationPostingViewController")
        tabBarController!.navigationItem.setRightBarButtonItem(customRightBarButton, animated: false)
        
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
    
}
