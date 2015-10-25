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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add set and add gradientLayer to the view
        setGradientLayerColours()
        setGradientLayerFrame()
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

    override func viewWillLayoutSubviews() {
        setGradientLayerFrame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
}

