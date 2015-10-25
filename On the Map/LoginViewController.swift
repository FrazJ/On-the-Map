//
//  ViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 24/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Add set and add gradientLayer to the view
        setGradientLayerColours()
        setGradientLayerFrame()
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        //Configure the textFields to each have an indent
        indentTextInTextfield(emailTextField)
        indentTextInTextfield(passwordTextField)
        
        //Round the corners of the buttons
        roundButtonCorner(loginButton)
        roundButtonCorner(facebookLoginButton)
        
    }

    override func viewWillLayoutSubviews() {
        setGradientLayerFrame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Gradient layer helper functions
    
    ///Function that sets the frame of the gradient layer to the bounds of the mainView
    func setGradientLayerFrame() {
        gradientLayer.frame = mainView.bounds
    }

    ///Function that sets the colours of the gradient layer
    func setGradientLayerColours() {
        
        //Light organge #FD972A
        let firstColour = UIColor(red: 0.992, green: 0.592, blue: 0.165, alpha: 1)
        //Dark organse #FD6F21
        let secondColour = UIColor(red: 0.992, green: 0.435, blue: 0.129, alpha: 1)
        gradientLayer.colors = [firstColour.CGColor,secondColour.CGColor]
    }
    
    
    //MARK: -Text field helper functions
    
    ///Function that indents the text in the provided text field
    func indentTextInTextfield(textField: UITextField) {
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.leftView = spacerView
    }
    
    
    //MARK: -Button helper functions
    
    ///Function that rounds the corners of the button
    func roundButtonCorner(button: UIButton) {
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
    }
}

