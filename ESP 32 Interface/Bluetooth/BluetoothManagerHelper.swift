//
//  NearbyDevicesVC.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 28/11/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import UIKit
import CoreBluetooth


class BluetoothManagerHelper : ObservableObject {
    
    var manager = BTManager()
    var device: BTDevice?
    
    var devices: [BTDevice] = [] {
        didSet {
        }
    }
    
    init() {
        manager.delegate = self
    }
    
    func connectDevice(deviceNumber: Int) {
        device = devices[deviceNumber]
        device?.connect()
    }
}

extension BluetoothManagerHelper: BTManagerDelegate {
    func didChangeState(state: CBManagerState) {
        devices = manager.devices
    }
    
    func didDiscover(device: BTDevice) {
        devices = manager.devices
    }
    
    func didEnableScan(on: Bool) {
        
    }
    
    
}
