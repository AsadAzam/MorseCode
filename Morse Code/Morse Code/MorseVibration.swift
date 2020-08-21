//
//  MorseVibration.swift
//  Morse Code
//
//  Created by Asad Azam on 21/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct MorseVibration: View {
    @State var convertFrom: String = ""
    @State var convertedTo: String = "Converted Text"
    @State var currentTitle: String = "Convert"
    @State var wpmPicker: Int = 20
    var duration: Float = 0.06
    
    //MARK: Adiitional States for SwiftUI
    @State var isUserInteractionEnabled: Bool = true
    @State var repeatVibration: Bool = false
    @State var engine: CHHapticEngine!
    @State var forceStop: Bool = false
    //MARK: END
    
    var body: some View {
        ZStack{
            Color(UIColor.tertiarySystemGroupedBackground).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Text("\(convertedTo)")
                            .padding(.all, 5)
                            .lineLimit(nil)
                        Spacer(minLength: 0)
                    }
                    
                    Spacer()
                }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 5)
                .padding(.horizontal, 20)
                Spacer()
                HStack{
                    //This spacer makes sure the
                    Spacer(minLength: UIScreen.main.bounds.width/2 - 60)
                    Button(action: {
                        self.convertToMorse()
                    }) {
                        Text("\(currentTitle)")
                    }
                    .frame(width: 120, height: 60)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    Spacer()
                    
                    if self.repeatVibration == false {
                        Button(action: {
                            self.repeatVibration.toggle()
                        }) {
                            Image(systemName: "repeat")
                        }
                        .frame(width: 39, height: 34)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .foregroundColor(Color(UIColor.systemGray6))
                    } else {
                        Button(action: {
                            self.repeatVibration.toggle()
                        }) {
                            Image(systemName: "repeat")
                        }
                        .frame(width: 39, height: 34)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .foregroundColor(Color(UIColor.systemBlue))
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    VStack {
                        HStack {
                            TextField("Text to Convert", text: $convertFrom)
                                .padding(.all, 5)
                                .lineLimit(nil)
                            Spacer(minLength: 0)
                        }
                        Spacer()
                        
                    }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 5)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitle("Vibration")
    }
    
//MARK: Convert Button (Vibration)
    func convertToMorse() {
        self.forceStop = false
        if currentTitle == "Convert" {
            if (convertFrom != ""){
//                convertFrom.resignFirstResponder()
                morseCodeText = convertFrom
                initializeString(toConvert: &morseCodeText)
                tempConvert()
                if repeatVibration == false {
                    self.convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode )
                } else {
                    self.convert(morseCodeText: morseCodeText, mapMorseCode: mapMorseCode)
                }
            } else {
                showAlertWith(title: "No Input!", message: "Input field cannot be empty")
            }
        } else {
            if repeatVibration == true {
                self.repeatVibration = false
            }
            self.forceStop = true
            engine?.stop()
            currentTitle = "Convert"
        }
    }
    
//MARK: Support Function(s)
    //Modifies Morse to display in correct format to display
    func tempConvert() {
        convertedTo = ""
        for index in 0..<morseCodeText.length {
            let tempString = mapMorseCode[morseCodeText[index]] ?? "#"
            convertedTo = convertedTo + " " + tempString
        }
    }
    
    //Hides keyboard when enter/done is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
//            convertFrom.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Alerter
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
//MARK: Main Convert Function and Logic
    //Converts Text to Morse Code and palys the vibrations
    func convert(morseCodeText: String, mapMorseCode: [String:String]) {
        currentTitle = "Stop"
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
                    self.currentTitle = "Convert"
                }
            }
        }
    }
    
//MARK: objC Function(s)
//    @objc func handleKeyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//            if notification.name == UIResponder.keyboardWillShowNotification {
//                convertFrom.frame.origin.y -= keyboardFrame.height
//                convertFrom.frame.origin.y += 10
//            }
//            else if notification.name == UIResponder.keyboardWillHideNotification {
//                convertFrom.frame.origin.y += keyboardFrame.height
//                convertFrom.frame.origin.y -= 10
//            }
//        }
//    }
    
//MARK: Deinitializer
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
//MARK: MorseVibration Struct END
}

struct MorseVibration_Previews: PreviewProvider {
    static var previews: some View {
        MorseVibration()
    }
}
