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
    
    var bno08xs : DeviceArray = DeviceArray(name: "BNO08X")
    var bno08xI2C_Type : DeviceType
    var bno08xSPI_Type : DeviceType
    
    func getServos() -> DeviceArray {
        return servos
    }
    
    func getBMP390s() -> DeviceArray {
        return bmp390s
    }
    
    func getBMP390(index: Int) -> BMP390 {
        return bmp390s.getDevice(index: index) as! BMP390
    }
    
    func getBNO08Xs() -> DeviceArray {
        return bmp390s
    }
    
    func getBNO08X(index: Int) -> BNO08X {
        return bno08xs.getDevice(index: index) as! BNO08X
    }
    
    init() {
        servo_Type = DeviceType(type: "Servo", pinTypes: ["Digital"], deviceType: Servo.self, devices: servos)
        
        bmp390I2C_Type = DeviceType(type: "BMP390 I2C", pinTypes: ["SDA", "SCL"], deviceType: BMP390.self, devices: bmp390s)
        bmp390SPI_Type = DeviceType(type: "BMP390 SPI", pinTypes: ["CS", "SCK", "MISO", "MOSI"], deviceType: BMP390.self, devices: bmp390s)
        
        bno08xI2C_Type = DeviceType(type: "BNO08X I2C", pinTypes: ["SDA", "SCL"], deviceType: BNO08X.self, devices: bno08xs)
        bno08xSPI_Type = DeviceType(type: "BNO08X I2C", pinTypes: ["CS", "SCK", "MISO", "MOSI", "INT", "RST"], deviceType: BNO08X.self, devices: bno08xs)
    }
    
    enum CodingKeys: CodingKey {
        case label, icon
    }
    
    func saveState() {
        let encoder = JSONEncoder()
        //servos
        if let encoded = try? encoder.encode(self.getServos().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getServos().name)
        }
        //bmp390s
        if let encoded = try? encoder.encode(self.getBMP390s().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getBMP390s().name)
        }
    }
    
    func getState() {
        let defaults = UserDefaults.standard
        //servos
        if let savedDevices = defaults.object(forKey: self.getServos().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([Servo].self, from: savedDevices) {
                    self.servos.setDevices(devices: loadedDevices)
            }
        }
        //bmp390s
        if let savedDevices = defaults.object(forKey: self.getBMP390s().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([BMP390].self, from: savedDevices) {
                    self.bmp390s.setDevices(devices: loadedDevices)
            }
        }
    }
    
    func cleanState() {
        servos.resetDevices()
        bmp390s.resetDevices()
    }
}
