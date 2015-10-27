//
//  LoginViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 24/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    let gradientLayer = CAGradientLayer()
    var session: NSURLSession!
    
    //MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    //MARK: View lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the look and feel of the user interface */
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        setGradientLayerFrame()
    }
    
    
    //MARK: Actions
    
    ///Function is called when a user presses the log in button; it authenticates with Udacity
    @IBAction func logInButton(sender: UIButton) {
        
        /* POST a new session */
        UdacityAPIClient.sharedInstance().postSession(emailTextField.text!, password: passwordTextField.text!) { (result, error) in
           
            /* GUARD: Was there an error? */
            guard error == nil else {
                
                /* Check to see what type of error occured */
                if var errorString = error?.userInfo[NSLocalizedDescriptionKey] as? String {
                    if errorString.rangeOfString("400") != nil {
                        errorString = "Please enter your email address and password."
                    } else if errorString.rangeOfString("403") != nil {
                        errorString = "Wrong email address or password entered."
                    } else if errorString.rangeOfString("1009") != nil {
                        errorString = "The internet connection appears to be offline."
                    } else {
                        errorString = "Something went wrong! Try again"
                    }
                    
                    /* Configure the alert view to display the error */
                    let alert = UIAlertController(title: "Authentication failed!", message: errorString, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
                    
                    /* Configure a shake animation */
                    let shakeAnimation = CABasicAnimation(keyPath: "position")
                    shakeAnimation.duration = 0.07
                    shakeAnimation.repeatCount = 4
                    shakeAnimation.autoreverses = true
                    shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(self.mainView.center.x - 10, self.mainView.center.y - 10))
                    shakeAnimation.toValue = NSValue(CGPoint: CGPointMake(self.mainView.center.x + 10, self.mainView.center.y + 10))
                    
                    
                    /* Display an alert and shake the vie letting the user know the authentication failed */
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        /* Present the alert view */
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        /* Shake the screen */
                        self.mainView.layer.addAnimation(shakeAnimation, forKey: "position")
                    })
                }
                return
            }
            
            print("The session ID is : \(result)")
            
        }
    }
    
    ///Function is called when a user presses the sign up button; opens the Udacity sign in page in safari
    @IBAction func signUpButton(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
        
    }
    
    
    //MARK: Helper functions
    
    //MARK: -Set up the user interface
    
    ///Function sets up the user interface
    func configureUI() {
        
        //Add set and add gradientLayer to the view
        setGradientLayerColours()
        setGradientLayerFrame()
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        //Configure the textFields to each have an indent
        indentTextInTextfield(emailTextField)
        indentTextInTextfield(passwordTextField)
        
        //Make the ViewController the delegate of the text fields
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Round the corners of the buttons
        roundButtonCorner(loginButton)
        roundButtonCorner(facebookLoginButton)
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
        //Dark organge #FD6F21
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
    
    //MARK: Text field delegate functions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

