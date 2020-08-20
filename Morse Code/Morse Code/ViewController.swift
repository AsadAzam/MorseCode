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
                            Button(action: {}) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                Text("Vibration")
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
                            Button(action: {}) {
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
