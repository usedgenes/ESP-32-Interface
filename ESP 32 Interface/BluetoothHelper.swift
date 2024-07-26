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
    
    func viewLoaded() {
        manager.delegate = self
    }
}

extension BluetoothHelper: BTManagerDelegate {
    func didChangeState(state: CBManagerState) {
        devices = manager.devices
    }
    
    func didDiscover(device: BTDevice) {
        devices = manager.devices
    }
    
    func didEnableScan(on: Bool) {
        
    }
    
    
}
