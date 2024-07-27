//
//  DeviceType.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class DeviceType : NSObject {
    struct Device: Hashable, Identifiable {
        let name: String
        let id = UUID()
    }
    
    struct DeviceList: Identifiable {
        let name: String
        let devices: [Device]
        let id = UUID()
    }
    
    let ESP32Devices: [DeviceList] = [
        DeviceList(name: "Motion",
                   devices: [Device(name: "Motor"),
                             Device(name: "Servo")]),
        DeviceList(name: "Altimeter",
                   devices: [Device(name: "BMP388")]),
        DeviceList(name: "IMU",
                   devices: [Device(name: "BNO08x")]),
    ]
}
