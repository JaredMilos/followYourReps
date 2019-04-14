//
//  ViewController.swift
//  Follow Your Reps
//
//  Created by Jared Milos on 11/19/18.
//  Copyright © 2018 Jared Milos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var leftTopStar: UIImageView!
    @IBOutlet weak var rightTopStar: UIImageView!
    @IBOutlet weak var leftBottomStar: UIImageView!
    @IBOutlet weak var rightBottomStar: UIImageView!
    
    @IBOutlet weak var validationAlert: UILabel!
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        let providedZIPCode = inputField.text
        
        let isZIPCodeValid = isValidZIPCode(zipCodeString: providedZIPCode!)
        
        if isZIPCodeValid {
            validationAlert.isHidden = true
            performSegue(withIdentifier: "zipEntered", sender: self)
        } else {
            validationAlert.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTopStar.image = UIImage(named: "USAstar")
        rightTopStar.image = UIImage(named: "USAstar")
        leftBottomStar.image = UIImage(named: "USAstar")
        rightBottomStar.image = UIImage(named: "USAstar")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! APIResultTableViewController
//        destination.zipCode = Int(inputField.text!)!
        
        let navigationController = segue.destination as! UINavigationController
        let zipCodeReceivedViewController = navigationController.topViewController as! APIResultTableViewController
        zipCodeReceivedViewController.zipCode = inputField.text!
    }

    func isValidZIPCode(zipCodeString: String) -> Bool {
        var returnValue = true
        let zipRegEx = "[0-9]{5}"
        
        do {
            let regex = try NSRegularExpression(pattern: zipRegEx)
            let nsString = zipCodeString as NSString
            let results = regex.matches(in: zipCodeString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 || zipCodeString.count > 5  {
                returnValue = false
            }
        } catch let error as NSError {
            print(error)
            returnValue = false
        }
        
        return returnValue
    }
    
}

