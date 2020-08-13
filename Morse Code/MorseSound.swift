//
//  MorseSound.swift
//  Morse Code
//
//  Created by Asad Azam on 31/07/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import UIKit
import AVFoundation

class MorseCodeManager {
    static func getMorseCode() -> [String: String] {
        var mapMorseCode : [String: String] = [:]
        //MARK: Morse Code Start
        mapMorseCode["a"] = ".-"
        mapMorseCode["b"] = "-..."
        mapMorseCode["c"] = "-.-."
        mapMorseCode["d"] = "-.."
        mapMorseCode["e"] = "."
        mapMorseCode["f"] = "..-."
        mapMorseCode["g"] = "--."
        mapMorseCode["h"] = "...."
        mapMorseCode["i"] = ".."
        mapMorseCode["j"] = ".---"
        mapMorseCode["k"] = "-.-"
        mapMorseCode["l"] = ".-.."
        mapMorseCode["m"] = "--"
        mapMorseCode["n"] = "-."
        mapMorseCode["o"] = "---"
        mapMorseCode["p"] = ".--."
        mapMorseCode["q"] = "--.-"
        mapMorseCode["r"] = ".-."
        mapMorseCode["s"] = "..."
        mapMorseCode["t"] = "-"
        mapMorseCode["u"] = "..-"
        mapMorseCode["v"] = "...-"
        mapMorseCode["w"] = ".--"
        mapMorseCode["x"] = "-..-"
        mapMorseCode["y"] = "-.--"
        mapMorseCode["z"] = "--.."
        mapMorseCode["1"] = ".----"
        mapMorseCode["2"] = "..---"
        mapMorseCode["3"] = "...--"
        mapMorseCode["4"] = "....-"
        mapMorseCode["5"] = "....."
        mapMorseCode["6"] = "-...."
        mapMorseCode["7"] = "--..."
        mapMorseCode["8"] = "---.."
        mapMorseCode["9"] = "----."
        mapMorseCode["0"] = "-----"
        mapMorseCode["."] = ".-.-.-"
        mapMorseCode[","] = "--..--"
        mapMorseCode["?"] = "..--.."
        mapMorseCode["\'"] = ".----."
        mapMorseCode["!"] = "-.-.--"
        mapMorseCode["/"] = "-..-."
        mapMorseCode["("] = "-.--."
        mapMorseCode[")"] = "-.--.-"
        mapMorseCode["&"] = ".-..."
        mapMorseCode[":"] = "---..."
        mapMorseCode[";"] = "-.-.-."
        mapMorseCode["="] = "-...-"
        mapMorseCode["+"] = ".-.-."
        mapMorseCode["-"] = "-...-"
        mapMorseCode["_"] = "..--.-"
        mapMorseCode["\""] = ".-..-."
        mapMorseCode["$"] = "...-..-"
        mapMorseCode["@"] = ".--.-."
        mapMorseCode[" "] = "/"
        mapMorseCode[" # "] = "#"
        //MARK: Morse Code END
        return mapMorseCode
    }
}

class MorseSound: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var convertFrom: UITextView!
    @IBOutlet weak var convertedTo: UITextView!
    @IBOutlet weak var convertToMorseButton: UIButton!
    @IBOutlet weak var shouldRepeat: UIButton!
    @IBOutlet weak var wpmPicker: UIPickerView!
    
    var wpm: Double = 20.0
    private let dataSource = ["20", "19", "18", "17", "16", "15"]
    var repeatSound: Bool = false
    var morseCodeText: String!
    var mapMorseCode: [String: String] = MorseCodeManager.getMorseCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wpmPicker.dataSource = self
        wpmPicker.delegate = self
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

    
//MARK: Convert Button (Sound)
    @IBAction func convertToMorse(_ sender: UIButton) {
        if (convertToMorseButton.currentTitle == "Convert") {
            engine.attach(srcNode)
            engine.connect(srcNode, to: mainMixer, format: inputFormat)
            engine.connect(mainMixer, to: output, format: outputFormat)
            mainMixer.outputVolume = 0.5
            if (convertFrom.text != "") {
                wpmPicker.isUserInteractionEnabled = false
                convertFrom.resignFirstResponder()
                morseCodeText = convertFrom.text
                initializeString(toConvert: &morseCodeText)
                tempConvert()
                if (repeatSound == false) {
                    convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                } else {
                    while repeatSound == true {
                        convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                        do { usleep(480000) }
                    }
                }
            } else {
                showAlertWith(title: "No Input!", message: "Input field cannot be empty")
            }
        } else {
            if repeatSound == true {
                shouldRepeat.tintColor = .systemGray6
                repeatSound = false
            }
            engine.detach(srcNode)
            wpmPicker.isUserInteractionEnabled = true
            convertToMorseButton.setTitle("Convert", for: .normal)
        }
    }

//MARK: Repeat Button
    @IBAction func enableDisableRepeat(_ sender: Any) {
        repeatSound.toggle()
        if repeatSound == true {
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
    
    //Initializes engine to play sound
    func playSound(duration: Float) {
        do {
            try engine.start()
            CFRunLoopRunInMode(.defaultMode, CFTimeInterval(duration), false)
            engine.stop()
        } catch {
                print("Could not start engine: \(error)")
        }
    }
    
//MARK: Main Convert Function and Logic
    //Converts Text to Morse Code and palys the sound
    func convert(morseCodeText: String, mapMorseCode: [String:String]){
        convertToMorseButton.setTitle("Stop", for: .normal)
        let msTime: Int = Int(duration * 1000000)
        for index in 0..<morseCodeText.length {
            let tempString = mapMorseCode[morseCodeText[index]] ?? "#"
            if (tempString == "/") {
                do { usleep(useconds_t(msTime*6)) }
            }
            for j in 0..<tempString.length {
                if (tempString[j] == ".") {
                    playSound(duration: duration)
                }
                else if (tempString[j] == "-") {
                    playSound(duration: (duration * 3))
                }
                do { usleep(useconds_t(msTime)) }
            }
            do { usleep(useconds_t(msTime*2)) }
        }
        wpmPicker.isUserInteractionEnabled = true
        convertToMorseButton.setTitle("Convert", for: .normal)
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
    
//MARK: MorseSound Class END
}

//MARK: Global Variables
let frequency: Float = 550
let amplitude: Float = min(max(0.5, 0.0), 1.0)
var duration: Float = 0.06
let twoPi = 2 * Float.pi
let sine = { (phase: Float) -> Float in
    return sin(phase)
}
var signal: (Float) -> Float = sine
let engine = AVAudioEngine()
let mainMixer = engine.mainMixerNode
let output = engine.outputNode
let outputFormat = output.inputFormat(forBus: 0)
let sampleRate = Float(outputFormat.sampleRate)
let inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                sampleRate: outputFormat.sampleRate,
                                channels: 1,
                                interleaved: outputFormat.isInterleaved)
var currentPhase: Float = 0
let phaseIncrement = (twoPi / sampleRate) * frequency

let srcNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
    let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
    for frame in 0..<Int(frameCount) {
        let value = signal(currentPhase) * amplitude
        currentPhase += phaseIncrement
        if currentPhase >= twoPi {
            currentPhase -= twoPi
        }
        if currentPhase < 0.0 {
            currentPhase += twoPi
        }
        for buffer in ablPointer {
            let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
            buf[frame] = value
        }
    }
    return noErr
}

//MARK: Extension(s)
extension String {
    var length: Int {
        return count
    }
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension MorseSound: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        wpm = Double(dataSource[row]) ?? 20
        duration = Float(60 / (50 * wpm))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(dataSource[row]) WPM"
    }
}

//MARK: Global Function(s)
//converts text to lowercase
func initializeString(toConvert: inout String) {
    toConvert = toConvert.lowercased()
}
