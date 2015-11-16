//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 15/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    
    //MARK: - View life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        
        configurePlaceHolderText()
        roundButtonCorner(findOnTheMapButton)
        
        boldText()
    }

    
    //MARK: - Actions
    
    ///Function dismisses the informatio posting view controller when 'Cancel' button is pressed.
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //MARK: - Helper functions
    
    //MARK: -User interface helper functions
    
    ///Function that sets the colour and placeholder text for locationTextField
    func configurePlaceHolderText() {
        let attributedString = NSAttributedString(string: "Enter your location here", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        locationTextField.attributedPlaceholder = attributedString
    }
    
    ///Function that rounds the corners of the button
    func roundButtonCorner(button: UIButton) {
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
    }
    
    func boldText() {
        
        //TODO: Fix bold text issue 
        
        let text = studyingLabel.text! as NSString
        let rangeOfStringToBold = text.rangeOfString("studying")
        
        let attributedText = NSMutableAttributedString(string: text as String)
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        
        attributedText.addAttributes([NSFontAttributeName: font!], range: rangeOfStringToBold)
        
        let newString = String(attributedText)
        
        studyingLabel.text = newString
        
    }
    
}
