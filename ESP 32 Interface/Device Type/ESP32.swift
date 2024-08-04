//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos : DeviceArray = DeviceArray(name: "Servo")
    var servo_Type : DeviceType
    
    var bmp390s : DeviceArray = DeviceArray(name: "BMP390")
    var bmp390I2C_Type : DeviceType
    var bmp390SPI_Type : DeviceType
    
    var ESP32Devices : [DeviceArray] = []
    
    func getServos() -> DeviceArray {
        return servos
    }
    
    func getBMP390s() -> DeviceArray {
        return bmp390s
    }
    
    init() {
        servo_Type = DeviceType(type: "Servo", pinTypes: ["Digital"], deviceType: Servo.self, devices: servos)
        
        bmp390I2C_Type = DeviceType(type: "BMP390 I2C", pinTypes: ["SDA", "SCL"], deviceType: BMP390.self, devices: bmp390s)
        bmp390SPI_Type = DeviceType(type: "BMP390 SPI", pinTypes: ["CS", "SCK", "MISO", "MOSI"], deviceType: BMP390.self, devices: bmp390s)
        
        ESP32Devices.append(servos)
        ESP32Devices.append(bmp390s)
    }
    
    enum CodingKeys: CodingKey {
        case label, icon
    }
    
    func saveState() {
        let encoder = JSONEncoder()
        for devices in self.ESP32Devices {
            if let encoded = try? encoder.encode(devices.getDevices()) {
                    let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: devices.name)
            }
        }
    }
    
    func getState() {
        let defaults = UserDefaults.standard
        var i = 0
        for devices in self.ESP32Devices {
            if let savedDevices = defaults.object(forKey: devices.name) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedDevices = try? decoder.decode([Device].self, from: savedDevices) {
                        self.ESP32Devices[i].devices = loadedDevices
                }
            }
            i += 1

        }
    }
    
    func cleanState() {
        for devices in self.ESP32Devices {
            devices.resetDevices()
        }
    }
}
