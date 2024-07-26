//
//  NearbyDevicesVC.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 28/11/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import UIKit
import CoreBluetooth


class BluetoothHelper {
    
    var manager = BTManager()
    
    var devices: [BTDevice] = [] {
        didSet {
        }
    }
    
    init() {
        manager.delegate = self
    }
    
    func connectDevice(deviceNumber: Int) {
        let device = devices[deviceNumber]
        device.connect()
        device?.blink = blinkSwitch.isOn
    }
}

extension BluetoothHelper: BTManagerDelegate {
    func didChangeState(state: CBManagerState) {
        devices = manager.devices
        print("state changed")
    }
    
    func didDiscover(device: BTDevice) {
        devices = manager.devices
        print("discovered")
    }
    
    func didEnableScan(on: Bool) {
        
    }
    
    
}
