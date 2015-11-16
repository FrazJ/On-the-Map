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
        
        cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        
        studyingLabel.hidden = true
        locationPromptView.hidden = true
        
        configurePlaceholderText("Enter a link to share here", textField: urlTextField)
        
        
        urlTextField.hidden = false
        
        submitButton.hidden = false
        roundButtonCorner(submitButton)
        
        
        view.backgroundColor = UIColor(red: 65.0/255.0, green: 117.0/255, blue: 164.0/255.0, alpha: 1)
        
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
    
}
