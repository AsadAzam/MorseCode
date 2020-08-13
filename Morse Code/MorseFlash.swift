//
//  MorseFlash.swift
//  Morse Code
//
//  Created by Asad Azam on 02/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit
import AVFoundation

class MorseFlash: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var convertFrom: UITextView!
    @IBOutlet weak var convertedTo: UITextView!
    @IBOutlet weak var convertToMorseButton: UIButton!
    @IBOutlet weak var shouldRepeat: UIButton!
    
    var repeatFlash: Bool = false
    var forceFlashStop: Bool = false
    var morseCodeText: String!
    var mapMorseCode: [String: String] = MorseCodeManager.getMorseCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        convertFrom.delegate = self
                
        convertFrom.layer.cornerRadius = 15
        convertFrom.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        convertFrom.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        convertFrom.layer.shadowOpacity = 1.0
        convertFrom.layer.shadowRadius = 5.0
        convertFrom.layer.masksToBounds = false
        convertFrom.layer.cornerRadius = 15
        
        convertedTo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        convertedTo.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        convertedTo.layer.shadowOpacity = 1.0
        convertedTo.layer.shadowRadius = 5.0
        convertedTo.layer.masksToBounds = false
        convertedTo.layer.cornerRadius = 15
        
        convertToMorseButton.layer.cornerRadius = 15
        
        shouldRepeat.tintColor = .systemGray6
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: Convert Button (Flash)
    @IBAction func convertToMorse(_ sender: UIButton) {
        if convertToMorseButton.currentTitle == "Convert" {
            if (convertFrom.text != "") {
                convertFrom.resignFirstResponder()
                morseCodeText = convertFrom.text
                initializeString(toConvert: &morseCodeText)
                tempConvert()
                if repeatFlash == false {
                    convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode )
                } else {
                    convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                }
            } else {
                showAlertWith(title: "No Input!", message: "Input field cannot be empty")
            }
        } else {
            if repeatFlash == true {
                shouldRepeat.tintColor = .systemGray6
                repeatFlash = false
            }
            forceFlashStop = true
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = AVCaptureDevice.TorchMode.off
            } catch {
                print("There was an error : \(error.localizedDescription)")
            }
            convertToMorseButton.setTitle("Convert", for: .normal)
        }
    }
    
//MARK: Repeat Button
    @IBAction func enableDisableRepeat(_ sender: UIButton) {
        repeatFlash.toggle()
        if repeatFlash == true {
            shouldRepeat.tintColor = .systemBlue
        } else {
            shouldRepeat.tintColor = .systemGray6
        }
    }
    
//MARK: Support Function(s)
    //Modifies Morse to display in correct format to display
    func tempConvert() {
        convertedTo.text = ""
        for index in 0..<morseCodeText.length {
            let tempString = mapMorseCode[morseCodeText[index]] ?? "#"
            convertedTo.text = convertedTo.text + " " + tempString
        }
    }
    
    //Hides keyboard when enter/done is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            convertFrom.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Alerter
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //Toggles the flash on or off
    func toggleFlash() {
        if forceFlashStop == false {
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
            guard device.hasTorch else { return }

            do {
                try device.lockForConfiguration()

                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device.setTorchModeOn(level: 1.0)
                    } catch {
                        print("There was an error : \(error.localizedDescription)")
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("There was an error : \(error.localizedDescription)")
            }
        }
    }

//MARK: Main Convert Function and Logic
    //Converts Text to Morse Code and starts the flashlight
    func convert(morseCodeText: String, mapMorseCode: [String:String]){
        convertToMorseButton.setTitle("Stop", for: .normal)
        DispatchQueue.global(qos: .utility).async {
            for index in 0..<morseCodeText.length {
                let tempString = mapMorseCode[morseCodeText[index]] ?? "#"
                if (tempString == "/") {
                    do { usleep(360000) }
                }
                for j in 0..<tempString.length {
                    if (tempString[j] == ".") {
                        self.toggleFlash()
                        do { usleep(60000) }
                        self.toggleFlash()
                    }
                    else if (tempString[j] == "-") {
                        self.toggleFlash()
                        do { usleep(180000) }
                        self.toggleFlash()
                        do {usleep(60000)}
                    }
                    do { usleep(60000) }
                }
                do { usleep(120000) }
            }
            DispatchQueue.main.async {
                self.forceFlashStop = false
                if self.repeatFlash == true {
                    do { usleep(480000) }
                    self.convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                } else {
                    self.convertToMorseButton.setTitle("Convert", for: .normal)
                }
                guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
                do {
                    try device.lockForConfiguration()
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } catch {
                    print("There was an error : \(error.localizedDescription)")
                }
            }
        }
    }

//MARK: objC Function(s)
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            if notification.name == UIResponder.keyboardWillShowNotification {
                convertFrom.frame.origin.y -= keyboardFrame.height
                convertFrom.frame.origin.y += 10
            }
            else if notification.name == UIResponder.keyboardWillHideNotification {
                convertFrom.frame.origin.y += keyboardFrame.height
                convertFrom.frame.origin.y -= 10
            }
        }
    }
    
//MARK: Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK: MorseFlash Class END
}
