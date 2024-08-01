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
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(ESP_32) {
                        let defaults = UserDefaults.standard
                        defaults.set(encoded, forKey: "ESP32")
                    }
                }) {
                    Text("Save State")
                }
                Button (action: {
                    let defaults = UserDefaults.standard
                    let decoder = JSONDecoder()
                    if let savedESP32 = defaults.object(forKey: "ESP32") as? Data {
                        if let loadedESP32 = try? decoder.decode(ESP32.self, from: savedESP32) {
                                ESP_32 = loadedESP32
                            }
                    }
                }) {
                    Text("Get State")
                }
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
