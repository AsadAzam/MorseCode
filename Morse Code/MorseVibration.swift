//
//  MorseVibration.swift
//  Morse Code
//
//  Created by Asad Azam on 02/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit
import CoreHaptics

class MorseVibration: UIViewController, UITextViewDelegate {

    @IBOutlet weak var convertFrom: UITextView!
    @IBOutlet weak var convertedTo: UITextView!
    @IBOutlet weak var convertToMorseButton: UIButton!
    @IBOutlet weak var shouldRepeat: UIButton!
    
    var repeatVibration: Bool = false
    var morseCodeText: String!
    var mapMorseCode: [String: String] = MorseCodeManager.getMorseCode()
    var engine: CHHapticEngine!
    var forceStop: Bool = false

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

    
//MARK: Convert Button (Vibration)
    @IBAction func convertToMorse(_ sender: UIButton) {
        forceStop = false
        if convertToMorseButton.currentTitle == "Convert" {
            if (convertFrom.text != ""){
                convertFrom.resignFirstResponder()
                morseCodeText = convertFrom.text
                initializeString(toConvert: &morseCodeText)
                tempConvert()
                if repeatVibration == false {
                    convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode )
                } else {
                    convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                }
            } else {
                showAlertWith(title: "No Input!", message: "Input field cannot be empty")
            }
        } else {
            if repeatVibration == true {
                shouldRepeat.tintColor = .systemGray6
                repeatVibration = false
            }
            forceStop = true
            engine?.stop()
            convertToMorseButton.setTitle("Convert", for: .normal)
        }
    }
    
//MARK: Repeat Button
    @IBAction func enableDisableRepeat(_ sender: Any) {
        repeatVibration.toggle()
        if repeatVibration == true {
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
    
//MARK: Main Convert Function and Logic
    //Converts Text to Morse Code and palys the vibrations
    func convert(morseCodeText: String, mapMorseCode: [String:String]) {
        convertToMorseButton.setTitle("Stop", for: .normal)
        DispatchQueue.global(qos: .utility).async {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            do {
                self.engine = try CHHapticEngine()
                try self.engine?.start()
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription)")
            }
            for index in 0..<morseCodeText.length {
                let tempString = mapMorseCode[morseCodeText[index]] ?? "#"
                
                if (tempString == "/") {
                    do { usleep(720000) }
                }
                if self.forceStop == false {
                    for j in 0..<tempString.length {
                        if (tempString[j] == ".") {
                            do {usleep(30000)}
                            let dot = CHHapticEvent(eventType: .hapticTransient, parameters: [.init(parameterID: .hapticIntensity, value: 1), .init(parameterID: .hapticSharpness, value: 0.55)], relativeTime: 0)
                            do {
                                let pattern = try CHHapticPattern(events: [dot], parameters: [])
                                let player = try self.engine?.makePlayer(with: pattern)
                                try player?.start(atTime: 0)
                            } catch {
                                print("Failed to play pattern: \(error.localizedDescription).")
                            }
                        }
                        else if (tempString[j] == "-") {
                            do {usleep(30000)}
                            let dit = CHHapticEvent(eventType: .hapticContinuous, parameters: [.init(parameterID: .hapticIntensity, value: 0.81), .init(parameterID: .hapticSharpness, value: 0.8)], relativeTime: 0, duration: 0.12)
                            do {
                                let pattern = try CHHapticPattern(events: [dit], parameters: [])
                                let player = try self.engine?.makePlayer(with: pattern)
                                try player?.start(atTime: 0)
                            } catch {
                                print("Failed to play pattern: \(error.localizedDescription).")
                            }
                            do {usleep(60000)}
                        }
                        do { usleep(120000) }
                    }
                }
                do { usleep(240000) }
            }
            DispatchQueue.main.async {
                if self.repeatVibration == true {
                    do { usleep(480000) }
                    self.convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                } else {
                    self.forceStop = false
                    self.convertToMorseButton.setTitle("Convert", for: .normal)
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
    
//MARK: MorseVibration Class END
}
