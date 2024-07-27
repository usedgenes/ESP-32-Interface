//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos = DeviceType(type: "servo")
    var motion = DeviceCategory(category: "motion")
    @Published var ESP32Devices: [DeviceCategory] = [] {
        didSet {
        }
    }
    
    init() {
        motion.addDevice(deviceType: servos)
        ESP32Devices.append(motion)
    }
}
