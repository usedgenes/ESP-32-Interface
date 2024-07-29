//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothDevice = BluetoothDeviceHelper()
    @StateObject var ESP_32 = ESP32()

    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ESP32 Options")) {
                    NavigationLink("Connect to Bluetooth", destination: BluetoothConnectView(bluetoothDevice : bluetoothDevice))
//                    NavigationLink("Connect to WiFi", destination: BluetoothConnectView())
                    NavigationLink("Add a Device", destination: AddDeviceView(ESP_32: ESP_32))
                }
                
                Section(header: Text("Motion")) {
                    Button("Servo") {
                        showingServoView.toggle()
                    }
                    .sheet(isPresented: $showingServoView) {
                        ServoView(ESP_32)
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
