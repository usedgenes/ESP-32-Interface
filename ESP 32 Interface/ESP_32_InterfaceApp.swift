//
//  ESP_32_InterfaceApp.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

@main
struct ESP_32_InterfaceApp: App {
    @StateObject var ESP_32 = ESP32()
    @StateObject var bluetoothDevice = BluetoothDeviceHelper()
    @StateObject var bmi088EDF = BMI088EDF()
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environmentObject(ESP_32)
                .environmentObject(bluetoothDevice)
                .environmentObject(bmi088EDF)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    @EnvironmentObject var ESP_32 : ESP32
    func applicationWillTerminate(_ application: UIApplication) {
        ESP_32.saveState()
    }
}
