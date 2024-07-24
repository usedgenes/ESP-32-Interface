//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            HStack {
                Text("ESP32 Interface")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.yellow)
                Image("ESP32")
                    .resizable()
                    .frame(width: 48.0, height: 48.0)
                    
                    
            }
            .padding()
            Text("An app to help you program an ESP32")
            
            Button("Add a Device") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            Button("Servo") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            Button("Altimeter") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            Button("IMU") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
