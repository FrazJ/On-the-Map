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
    
    //MARK: - View life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        
        configurePlaceholderText("Enter your location here", textField: locationTextField)
        roundButtonCorner(findOnTheMapButton)
        
        boldText()
    }

    
    //MARK: - Actions
    
    ///Function dismisses the informatio posting view controller when 'Cancel' button is pressed.
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
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
            
            print("This is the string to geocode: \(stringToGeocode)")
            
            geocoder.geocodeAddressString(stringToGeocode) { (placemark, error) in
                
                /* GAURD: Was there an error while fetching the users location? */
                guard error == nil else {
                    
                    /* Make the strings for the alert */
                    let alertTitle = "Couldn't get your location"
                    let alertMessage = "There was an error while fetching your location: \(error)"
                    let actionTitle = "Try again"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                    })
                    
                    return
                }
                
                /* Assign the returned location to the userLocation property */
                self.userLocation = placemark!
                
                print("The user location: \(self.userLocation)")
                
                /* Make the annotation from the placemark results */
                let topPlacemarkResult = self.userLocation[0]
                let placemarkToPlace = MKPlacemark(placemark: topPlacemarkResult)
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemarkToPlace.coordinate
                
                
                /* Centre the map */
                let pinLatitude = annotation.coordinate.latitude
                let pinLongitude = annotation.coordinate.longitude
                let pinCoordiant = CLLocationCoordinate2DMake(pinLatitude, pinLongitude)
                
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegionMake(pinCoordiant, span)
                
                dispatch_async(dispatch_get_main_queue(), {
                    /* Add the annotation to the map */
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.regionThatFits(region)
                })
                
                //Change the text colour of the cancel button
                self.cancelButton.titleLabel?.textColor = UIColor.whiteColor()
                
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
    
    //MARK: -Error helper functions
    ///Function that configures and shows an alert
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String) {
        
        /* Configure the alert view to display the error */
        let alert = UIAlertController(title: alertTitle  , message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        
        /* Present the alert view */
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
