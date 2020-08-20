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
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
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
