//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var bluetoothDevice = BluetoothDeviceHelper()
    @AppStorage("ESP_32") var ESP_32 = ESP32()
    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    
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
                    let device = Device(name: "hi", attachedPins: [])
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(device) {
                        let defaults = UserDefaults.standard
                        defaults.set(encoded, forKey: "device")
                    }
                }) {
                    Text("Save Devices")
                }
                Button (action: {
                    let defaults = UserDefaults.standard
                    if let savedDevice = defaults.object(forKey: "device") as? Data {
                        let decoder = JSONDecoder()
                        if let loadedDevice = try? decoder.decode(Device.self, from: savedDevice) {
                            print(loadedDevice.name)
                        }
                    }
                }) {
                    Text("Retrieve Devices")
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
