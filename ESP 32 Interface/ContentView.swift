//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingServoView = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Connect to ESP32")) {
                    NavigationLink("Bluetooth", destination: BluetoothConnectView())
//                    NavigationLink("Green", destination: GreenView())
//                    NavigationLink("Blue", destination: BlueView())
                }
                
                Section(header: Text("Motion")) {
                    Button("Servo") {
                        showingServoView.toggle()
                    }
                    .sheet(isPresented: $showingServoView) {
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
