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
    
    var pins : DeviceArray = DeviceArray(name: "Pin")
    var pin_Type : DeviceType
    
    var buzzers : DeviceArray = DeviceArray(name: "Buzzer")
    var buzzer_Type: DeviceType
    
    var bmi088s : DeviceArray = DeviceArray(name: "BMI088")
    var bmi088I2C_Type: DeviceType
    var bmi088SPI_Type: DeviceType
    
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
        return bno08xs
    }
    
    func getBNO08X(index: Int) -> BNO08X {
        return bno08xs.getDevice(index: index) as! BNO08X
    }
    
    func getPins() -> DeviceArray {
        return pins
    }
    
    func getBuzzers() -> DeviceArray {
        return buzzers
    }
    
    func getBMI088(index: Int) -> BMI088 {
        return bmi088s.getDevice(index: index) as! BMI088
    }
    
    func getBMI088s() -> DeviceArray {
        return bmi088s
    }
    
    init() {
        servo_Type = DeviceType(type: "Servo", pinTypes: ["Digital"], deviceType: Servo.self, devices: servos)
        
        bmp390I2C_Type = DeviceType(type: "BMP390 I2C", pinTypes: ["SDA", "SCL"], deviceType: BMP390.self, devices: bmp390s)
        bmp390SPI_Type = DeviceType(type: "BMP390 SPI", pinTypes: ["CS", "SCK", "MISO", "MOSI"], deviceType: BMP390.self, devices: bmp390s)
        
        bno08xI2C_Type = DeviceType(type: "BNO08X I2C", pinTypes: ["SDA", "SCL"], deviceType: BNO08X.self, devices: bno08xs)
        bno08xSPI_Type = DeviceType(type: "BNO08X SPI", pinTypes: ["CS", "SCK", "MISO", "MOSI", "INT", "RST"], deviceType: BNO08X.self, devices: bno08xs)
        
        pin_Type = DeviceType(type: "Pin", pinTypes: ["Pin"], deviceType: Device.self, devices: pins)
        
        buzzer_Type = DeviceType(type: "Buzzer", pinTypes: ["Buzzer Pin"], deviceType: Device.self, devices: buzzers)
        
        bmi088I2C_Type = DeviceType(type: "BMI088 I2C", pinTypes: ["SDA, SCL"], deviceType: BMI088.self, devices: bmi088s)
        bmi088SPI_Type = DeviceType(type: "BMI088 SPI", pinTypes: ["SCK", "MISO", "MOSI", "Accel CS", "Gyro CS"], deviceType: BMI088.self, devices: bmi088s)
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
        //bno08xs
        if let encoded = try? encoder.encode(self.getBNO08Xs().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getBNO08Xs().name)
        }
        //pins
        if let encoded = try? encoder.encode(self.getPins().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getPins().name)
        }
        //buzzers
        if let encoded = try? encoder.encode(self.getBuzzers().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getBuzzers().name)
        }
        //bmi088s
        if let encoded = try? encoder.encode(self.getBMI088s().getDevices()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.getBMI088s().name)
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
        //bno08x
        if let savedDevices = defaults.object(forKey: self.getBNO08Xs().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([BNO08X].self, from: savedDevices) {
                    self.bno08xs.setDevices(devices: loadedDevices)
            }
        }
        //pins
        if let savedDevices = defaults.object(forKey: self.getPins().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([Device].self, from: savedDevices) {
                    self.pins.setDevices(devices: loadedDevices)
            }
        }
        //buzzers
        if let savedDevices = defaults.object(forKey: self.getBuzzers().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([Device].self, from: savedDevices) {
                    self.buzzers.setDevices(devices: loadedDevices)
            }
        }
        //bmi088s
        if let savedDevices = defaults.object(forKey: self.getBMI088s().name) as? Data {
                let decoder = JSONDecoder()
                if let loadedDevices = try? decoder.decode([BMI088].self, from: savedDevices) {
                    self.bmi088s.setDevices(devices: loadedDevices)
            }
        }
    }
    
    func cleanState() {
        servos.resetDevices()
        bmp390s.resetDevices()
        bno08xs.resetDevices()
        pins.resetDevices()
        buzzers.resetDevices()
        bmi088s.resetDevices()
    }
}
