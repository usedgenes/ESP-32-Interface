//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Connect to ESP32")) {
                    NavigationLink("Bluetooth", destination: BluetoothConnectView())

                }
                
                Section(header: Text("Motion")) {
                    Button("Servo") {
                        showingServoView.toggle()
                    }
                    .sheet(isPresented: $showingServoView) {
                        ServoView()
                    }
                }
                
                Section(header: Text("Sensors")) {
                    Button("BMP390 Altimeter") {
                        showingAltimeterView.toggle()
                    }
                    .sheet(isPresented: $showingAltimeterView) {
                        ServoView()
                    }
                }
            }
            .navigationBarTitle("ESP32 Assistant")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
