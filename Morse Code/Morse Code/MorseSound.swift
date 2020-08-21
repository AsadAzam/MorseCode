//
//  MorseSound.swift
//  Morse Code
//
//  Created by Asad Azam on 20/08/20.
//  Copyright © 2020 Asad. All rights reserved.
//

import SwiftUI
import AVFoundation

struct MorseSound: View {
    
    @State var convertFrom: String = ""
    @State var convertedTo: String = "Converted Text"
    @State var currentTitle: String = "Convert"
    @State var wpmPicker: Int = 20
    @State var duration: Float = 0.06
    
    //MARK: Adiitional States for SwiftUI
    @State var isUserInteractionEnabled: Bool = true
    @State var repeatSound: Bool = false
    @State var showAlert: Bool = false
    //MARK: END
    
    let engine = AVAudioEngine()

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
                    Picker(selection: $wpmPicker, label: Text("WPM")) {
                        Text("20 WPM").tag(20)
                        Text("19 WPM").tag(19)
                        Text("18 WPM").tag(18)
                        Text("17 WPM").tag(17)
                        Text("16 WPM").tag(16)
                        Text("15 WPM").tag(15)
                    }
                    .frame(width: 104, height: 60)
                    .clipped()
                    .scaledToFit()
                    .disabled(!self.isUserInteractionEnabled)
                    Button(action: {
                        self.duration = Float(60 / (50 * Float(self.wpmPicker)))
                        self.convertedToMorse()
                    }) {
                        Text("\(currentTitle)")
                    }
                    .frame(width: 120, height: 60)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Input!"), message: Text("Input field cannot be empty"), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                    
                    if self.repeatSound == false {
                        Button(action: {
                            self.repeatSound.toggle()
                        }) {
                            Image(systemName: "repeat")
                        }
                        .frame(width: 39, height: 34)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .foregroundColor(Color(UIColor.systemGray6))
                    } else {
                        Button(action: {
                            self.repeatSound.toggle()
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
        .navigationBarTitle("Sound")
    }
    
    func convertedToMorse() {
        
        let frequency: Float = 550
        let amplitude: Float = min(max(0.5, 0.0), 1.0)
        //var duration: Float = 0.06
        let twoPi = 2 * Float.pi
        let sine = { (phase: Float) -> Float in
            return sin(phase)
        }
        let signal: (Float) -> Float = sine
        
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
        
        if (currentTitle == "Convert") {
            engine.attach(srcNode)
            engine.connect(srcNode, to: mainMixer, format: inputFormat)
            engine.connect(mainMixer, to: output, format: outputFormat)
            mainMixer.outputVolume = 0.5
            if (convertFrom != "") {
                self.isUserInteractionEnabled = false
                morseCodeText = self.convertFrom
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
                showAlert = true
            }
        } else {
            if repeatSound == true {
                repeatSound = false
            }
            engine.detach(srcNode)
            isUserInteractionEnabled = true
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
            //convertFrom.resignFirstResponder()
            return false
        }
        return true
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
        currentTitle = "Stop"
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
        self.isUserInteractionEnabled = true
        currentTitle = "Convert"
    }

//    func handleKeyboardNotification(notification: NSNotification) {
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
//MARK: MorseSound Class END
}

struct MorseSound_Previews: PreviewProvider {
    static var previews: some View {
        MorseSound()
    }
}

//MARK: Global Variables
var morseCodeText: String!
var mapMorseCode: [String: String] = MorseCodeManager.getMorseCode()

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

//MARK: Global Function(s)
//converts text to lowercase
func initializeString(toConvert: inout String) {
    toConvert = toConvert.lowercased()
}
