//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var bluetoothDevice = BluetoothDeviceHelper()
    @ObservedObject var ESP_32 = ESP32()
    @State var test = "Nothing"
    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    @State var saveTemp = 0
    @State var getTemp = 0
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ESP32 Options")) {
                    NavigationLink("Connect to Bluetooth", destination: BluetoothConnectView(bluetoothDevice : bluetoothDevice))
                    NavigationLink("View Devices", destination: DeviceView(ESP_32: ESP_32))
                }
                
                Section(header: Text("Motion")) {
                    NavigationLink("Servos", destination: ServoView(ESP_32: ESP_32, bluetoothDevice: bluetoothDevice))
                }
                Section(header: Text("Sensors")) {
                    NavigationLink("Altimeters", destination: BMP390_I2CView(ESP_32: ESP_32, bluetoothDevice: bluetoothDevice))
                }
                Button (action: {
                    ESP_32.saveState()
                }) {
                    Text("Save State")
                }
                Button (action: {
                    test = String(ESP_32.getState())
                }) {
                    Text("Get State")
                }
                Text(test)
            }
            .navigationBarTitle("ESP32 Assistant")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
