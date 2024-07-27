//
//  DeviceCategory.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

struct DeviceCategory: Identifiable {
    let category: String
    let devices: [Device]
    let id = UUID()
}

let ESP32Devices: [DeviceCategory] = [
    DeviceCategory(category: "Motion",
               devices: [Device(name: "Motor"),
                         Device(name: "Servo")]),
    DeviceCategory(category: "Altimeter",
               devices: [Device(name: "BMP388")]),
    DeviceCategory(category: "IMU",
               devices: [Device(name: "BNO08x")]),
]
