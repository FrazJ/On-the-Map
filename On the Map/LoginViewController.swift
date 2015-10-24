//
//  ViewController.swift
//  On the Map
//
//  Created by Frazer Hogg on 24/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var onTheMapLabel: UITextField!
    
    
    let textAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "GillSans-SemiBold", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -2.0)
    ]
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update the 
        onTheMapLabel.defaultTextAttributes = textAttributes
        
        //Add gradient to the view
        let firstColour = UIColor(red: 0.102, green: 0.737, blue: 0.612, alpha: 1)
        let secondColour = UIColor(red: 0.086, green: 0.635, blue: 0.529, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = mainView.bounds
        gradient.colors = [secondColour.CGColor,firstColour.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

