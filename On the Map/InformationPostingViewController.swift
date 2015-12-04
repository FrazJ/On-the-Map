//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 15/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var locationPromptView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: Properties
    var userLocation = [CLPlacemark]()
    var appDelegate : AppDelegate!
    
    /* Student location details */
    var studentLat = CLLocationDegrees()
    var studentLon = CLLocationDegrees()
    var studentLocationName = ""
    
    
    //MARK: - View life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Make this view controller the delegate of the text fields */
        locationTextField.delegate = self
        urlTextField.delegate = self
        
        /* Setup the textfield and buttons */
        configurePlaceholderText("Enter your location here", textField: locationTextField)
        roundButtonCorner(findOnTheMapButton)
        
        /* Bold the word "studying" in the label */
        boldText()
    }

    
    //MARK: - Actions
    
    ///Function dismisses the informatio posting view controller when 'Cancel' button is pressed.
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    ///Function that is called after the user presses the 'Find on the Map' button, which takes the string the user has entered and locates it on a map.
    @IBAction func findOnTheMap(sender: UIButton) {
        
        let geocoder = CLGeocoder()
        
        if let stringToGeocode = locationTextField.text {
            
            /* GAURD: Did the user provide a location? */
            guard stringToGeocode != "" else {
                
                /* Make the strings for the alert */
                let alertTitle = "No location provided"
                let alertMessage = "You must enter your location before proceeding"
                let actionTitle = "OK"
                showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                return
            }
            
            /* Show activity to show the app is processing data*/
            let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            activityView.center = view.center
            activityView.startAnimating()
            view.addSubview(activityView)

            
            /* Make the user interface appear disabled */
            let views = [cancelButton!, studyingLabel!, locationTextField!, locationPromptView!, findOnTheMapButton!]
            changeAlphaFor(views, alpha: 0.5)
            
            /* Geocode the provided string */
            geocoder.geocodeAddressString(stringToGeocode) { (placemark, error) in
                
                /* GAURD: Was there an error while fetching the users location? */
                guard error == nil else {
                    
                    /* Make the strings for the alert */
                    let alertTitle = "Couldn't get your location"
                    let alertMessage = "There was an error while fetching your location."
                    let actionTitle = "Try again"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                        self.changeAlphaFor(views, alpha: 1.0)
                        activityView.stopAnimating()
                    })
                    
                    return
                }
                
                /* Assign the returned location to the userLocation property */
                self.userLocation = placemark!
                
                /* Setup the map with the pin cooresponding to the placemark */
                self.configureMap()
                
                /* Makes the appropriate changes to the UI after getting a successful placemark */
                self.changeUserInterface()
                
                //Stop the activity spinner
                activityView.stopAnimating()
                
            }
        }
    }
    
    @IBAction func sumbitStudentLocation(sender: UIButton) {
        
        /* GUARD: Did the user provde a URL */
        guard urlTextField.text! != "" else{
            
            /* Make the strings for the alert */
            let alertTitle = "No URL provided"
            let alertMessage = "You must enter a URL before proceeding"
            let actionTitle = "OK"
            showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
            return
        }
        
        /* GUARD: Did the user provide a valid URL? */
        guard UIApplication.sharedApplication().canOpenURL(NSURL(string: urlTextField.text!)!) else {
            /* Make the strings for the alert */
            let alertTitle = "Invalid URL provided"
            let alertMessage = "You must enter a valid URL before proceeding. Ensure you include http:// or https://"
            let actionTitle = "OK"
            showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
            return
        }
        
        /* Prepare the data to POST to the Parse API */
        let studentLocationArray : [String:AnyObject] = [
            ParseClient.JSONBodyKeys.UniqueKey: appDelegate.userID,
            ParseClient.JSONBodyKeys.FirstName: appDelegate.userData[0],
            ParseClient.JSONBodyKeys.LastName: appDelegate.userData[1],
            ParseClient.JSONBodyKeys.MapString: studentLocationName,
            ParseClient.JSONBodyKeys.MediaURL: urlTextField.text!,
            ParseClient.JSONBodyKeys.Latitude: studentLat,
            ParseClient.JSONBodyKeys.Longitude:studentLon
            ]
    
        if appDelegate.objectID == "" {
            
            //Post the new student location
            ParseClient.sharedInstance().postStudentLocation(studentLocationArray) {(result, error) in
                /* GUARD: Was the data POSTed successfully? */
                guard error == nil else {
                    /* Make the strings for the alert */
                    let alertTitle = "Couldn't submit your location"
                    let alertMessage = "There was an error while trying to post your location to the server."
                    let actionTitle = "Try again"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                    })
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        } else {
            
            ParseClient.sharedInstance().putStudentLocation(appDelegate.objectID, jsonBody: studentLocationArray) {(result, error) in
                /* GUARD: Was the data POSTed successfully? */
                guard error == nil else {
                    /* Make the strings for the alert */
                    let alertTitle = "Couldn't update your location"
                    let alertMessage = "There was an error while trying to update your location on the server."
                    let actionTitle = "Try again"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                    })
                    
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    
    //MARK: - Helper functions
    
    //MARK: -User interface helper functions
    
    ///Function that sets the colour and placeholder text for locationTextField
    func configurePlaceholderText(text: String, textField: UITextField) {
        let attributedString = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        textField.attributedPlaceholder = attributedString
    }
    
    ///Function that rounds the corners of the button
    func roundButtonCorner(button: UIButton) {
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
    }
    
    ///Function that makes the word "studying" in the label bold
    func boldText() {
        
        /* Get the text from the label */
        let text = studyingLabel.text!
    
        /* Create an NSMutableAttributeString from the label text */
        let attributedText = NSMutableAttributedString(string: text)
        
        /* Font to make the word bold */
        let font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        
        /* Make only the word "studying" bold from the text */
        attributedText.addAttributes([NSFontAttributeName: font!], range: NSRange.init(location: 14, length: 8))
        
        /* Update the label text */
        studyingLabel.attributedText = attributedText
        
    }
    
    ///Function that takers an array of UIView objects and alters their alpha property
    func changeAlphaFor(views: [UIView], alpha: CGFloat) {
        
        /* For each view in the array change the alpha */
        for view in views {
            view.alpha = alpha
        }
    }
    
    ///Function that changes the user interface after getting a successful placemark
    func changeUserInterface() {
        
        //Change the text colour and alpha of the cancel button
        self.cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        self.changeAlphaFor([self.cancelButton], alpha: 1.0)
        
        //Hide the components that arn't needed
        self.studyingLabel.hidden = true
        self.locationPromptView.hidden = true
        self.findOnTheMapButton.hidden = true
        
        //Unhide the urlTextfiend and update the placeholder colour
        self.configurePlaceholderText("Enter a link to share here", textField: self.urlTextField)
        self.urlTextField.hidden = false
        
        //Unhide the submit button and round its corners
        self.submitButton.hidden = false
        self.roundButtonCorner(self.submitButton)
        
        //Unide the map view
        self.mapView.hidden = false
        
        //Change the colour of the background
        self.view.backgroundColor = UIColor(red: 65.0/255.0, green: 117.0/255, blue: 164.0/255.0, alpha: 1)
    }
    
    ///Function that configures a map view with a placemark
    func configureMap() {
        
        /* Make the annotation from the placemark results */
        let topPlacemarkResult = self.userLocation[0]
        let placemarkToPlace = MKPlacemark(placemark: topPlacemarkResult)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemarkToPlace.coordinate
        
        studentLocationName = placemarkToPlace.name!
        
        /* Centre the map */
        studentLat = annotation.coordinate.latitude
        studentLon = annotation.coordinate.longitude
        let pinCoordiant = CLLocationCoordinate2DMake(studentLat, studentLon)
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(pinCoordiant, span)
        
        dispatch_async(dispatch_get_main_queue(), {
            /* Add the annotation to the map */
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        })
    }
    
    
    //MARK: -Error helper functions
    
    ///Function that configures and shows an alert
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String) {
        
        /* Configure the alert view to display the error */
        let alert = UIAlertController(title: alertTitle  , message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        
        /* Present the alert view */
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Textfield delegate functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
