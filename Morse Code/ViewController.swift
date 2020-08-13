//
//  ViewController.swift
//  Morse Code
//
//  Created by Asad Azam on 01/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var callMorseSound: UIButton!
    @IBOutlet weak var callMorseVibration: UIButton!
    @IBOutlet weak var callMorseFlash: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callMorseSound.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        callMorseSound.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        callMorseSound.layer.shadowOpacity = 1.0
        callMorseSound.layer.shadowRadius = 15.0
        callMorseSound.layer.masksToBounds = false
        callMorseSound.layer.cornerRadius = 15
        
        callMorseVibration.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        callMorseVibration.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        callMorseVibration.layer.shadowOpacity = 1.0
        callMorseVibration.layer.shadowRadius = 15.0
        callMorseVibration.layer.masksToBounds = false
        callMorseVibration.layer.cornerRadius = 15
        
        callMorseFlash.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        callMorseFlash.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        callMorseFlash.layer.shadowOpacity = 1.0
        callMorseFlash.layer.shadowRadius = 15.0
        callMorseFlash.layer.masksToBounds = false
        callMorseFlash.layer.cornerRadius = 15
    }
//MARK: END
}
