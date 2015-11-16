//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 15/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    
    //MARK: - View life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        
        configurePlaceHolderText()
        
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
    
}
