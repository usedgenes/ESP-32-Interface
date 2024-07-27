//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var devices : [DeviceType] = []
    var deviceAmount: [DeviceType: Int] = [:]
    
    func addDevice(device : DeviceType) {
        deviceAmount[device]? += 1
    }
}
