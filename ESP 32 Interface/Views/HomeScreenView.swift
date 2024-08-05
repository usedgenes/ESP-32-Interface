//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var ESP_32 : ESP32
    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    @State var saveTemp = 0
    @State var getTemp = 0
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ESP32 Options")) {
                    NavigationLink("App Help", destination: AppHelpView())
                    NavigationLink("Connect to Bluetooth", destination: BluetoothConnectView())
                    NavigationLink("View Devices", destination: DeviceView())
                    Button(action: {
                        ESP_32.cleanState()
                        if let bundleID = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        }
                    }) {
                        Text("Reset Devices")
                    }
                }
                
                Section(header: Text("Motion")) {
                    NavigationLink("Servos", destination: ServoView())
                        .disabled(!bluetoothDevice.isConnected)
                }
                Section(header: Text("Sensors")) {
                    NavigationLink("BMP390", destination: BMP390View())
                        .disabled(!bluetoothDevice.isConnected)
                }
                
                NavigationLink("BMP390 Charts", destination: BMP390ChartView())
            }
            .navigationBarTitle("ESP32 Assistant")
            
        }.onAppear(perform: {
            ESP_32.getState()
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getESP32() -> ESP32 {
        return ESP_32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
