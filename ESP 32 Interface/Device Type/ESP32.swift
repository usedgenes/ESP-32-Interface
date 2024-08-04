//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos : DeviceArray
    var servo_Type : DeviceType
    
    var bmp390s : DeviceArray
    var bmp390I2C_Type : DeviceType
    var bmp390SPI_Type : DeviceType
    
    var ESP32Devices : [DeviceArray]
    
    func getServos() -> [Servo] {
        return servos
    }
    
    func getBMP390s() -> [BMP390] {
        return bmp390s
    }
    
    init() {
        servo_Type = DeviceType(type: "Servo", pinTypes: ["Digital"], deviceType: Servo.self, devices: servos)
        
        bmp390I2C_Type = DeviceType(type: "BMP390 I2C", pinTypes: ["SCK", "SDA"], deviceType: BMP390.self, devices: bmp390s)
        bmp390SPI_Type = DeviceType(type: "BMP390 SPI", pinTypes: ["CS", "SCK", "MISO", "MOSI"], deviceType: BMP390.self, devices: bmp390s)
        
        ESP32Devices.append(DeviceArray)
        ESP32Devices.append(bmp390s)
    }
    
    enum CodingKeys: CodingKey {
        case label, icon
    }
    
    func saveState() {
        let encoder = JSONEncoder()
        for devices in self.ESP32Devices {
                if let encoded = try? encoder.encode(devices) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: deviceType.type)
                }
            }
        }
    }
    
    func getState() {
        let defaults = UserDefaults.standard
        var i = 0
        for deviceCategory in self.ESP32Devices {
            var j = 0
            for deviceType in deviceCategory.deviceTypes {
                if let savedDevices = defaults.object(forKey: deviceType.type) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedDevices = try? decoder.decode([Device].self, from: savedDevices) {
                        self.ESP32Devices[i].deviceTypes[j].devices = loadedDevices
                    }
                }
                j += 1
            }
            i += 1

        }
    }
    
    func cleanState() {
        for deviceCategory in ESP32Devices {
            for deviceType in deviceCategory.deviceTypes {
                deviceType.resetDevices()
            }
        }
    }
}
