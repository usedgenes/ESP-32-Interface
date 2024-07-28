//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos = ServoType(type: "Servos", pinTypes: ["Digital"])
    var motors = MotorType(type: "Motors", pinTypes: ["Digital"])
    var motion = DeviceCategory(category: "Motion")
    
    var bmp390I2C = BMP390_I2CType(type: "BMP390 I2C", pinTypes: [""])
    var altimeters = DeviceCategory(category: "Altimeters")
    
    var bno08x = BNO08X_I2CType(type: "BNO08X", pinTypes: [""])
    var imu = DeviceCategory(category: "IMUs")

    @Published var ESP32Devices: [DeviceCategory] = [] {
        didSet {
        }
    }
    
    init() {
        motion.addDevice(deviceType: servos)
        altimeters.addDevice(deviceType: bmp390I2C)
        imu.addDevice(deviceType: bno08x)
        ESP32Devices.append(motion)
        ESP32Devices.append(altimeters)
        ESP32Devices.append(imu)
    }
}
