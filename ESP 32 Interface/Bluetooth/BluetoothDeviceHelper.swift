//
//  BluetoothDeviceHelper.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation
import UserNotifications


class BluetoothDeviceHelper: ObservableObject {
    
    var deviceName: String = "null"
    var isConnected: Bool = false
    
    var device: BTDevice? {
        didSet {
            device?.delegate = self
        }
    }
    
    init() {
        device?.delegate = self
    }
    
    func disconnect() {
        device?.disconnect()
        isConnected = false
    }
    
    func connect() {
        isConnected = true
    }
    
    func blinkChanged() {
        device?.blink = true
    }

}

extension BluetoothDeviceHelper: BTDeviceDelegate {
    func deviceSerialChanged(value: String) {
        
    }
    
    func deviceSpeedChanged(value: Int) {
    }
    
    func deviceConnected() {
    }
    
    func deviceDisconnected() {
    }
    
    func deviceReady() {
    }
    
    func deviceBlinkChanged(value: Bool) {
        
    }
}
    
