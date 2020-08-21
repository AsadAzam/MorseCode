//
//  ViewController.swift
//  Morse Code
//
//  Created by Asad Azam on 20/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import SwiftUI

struct ViewController: View {
    var body: some View {
        NavigationView{
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    ZStack {
                        Color(UIColor.white)
                        HStack {
                            NavigationLink(destination: MorseSound()) {
                                Image(systemName: "speaker.3.fill")
                                Text("Sound")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 160, height: 60)
                    .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 15)
                    .padding(.bottom, 23)
                    ZStack {
                        Color(UIColor.white)
                        HStack {
                            NavigationLink(destination: MorseVibration()) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                Text("Vibration")
                                    .frame(width: 70)
                                    .lineLimit(1)
                                    .foregroundColor(Color.black)
                            }
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 160, height: 60)
                    .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 15)
                    .padding(.bottom, 23)
                    ZStack {
                        Color(UIColor.white)
                        HStack {
                            NavigationLink(destination: MorseFlash()) {
                                Image(systemName: "flashlight.on.fill")
                                Text("Flash")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 160, height: 60)
                    .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 15)
                }
                .navigationBarTitle("Morse Code")
            }
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
    }
}

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

final class KeyboardResponder: ObservableObject {
    @Published private(set) var currentKeyboardHeight: CGFloat = 0.0
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: objC Function(s)
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            if notification.name == UIResponder.keyboardWillShowNotification {
                currentKeyboardHeight = -CGFloat(keyboardFrame.height) - 20.0
            }
            else if notification.name == UIResponder.keyboardWillHideNotification {
                currentKeyboardHeight = 0.0
            }
        }
    }
    
    //MARK: Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
