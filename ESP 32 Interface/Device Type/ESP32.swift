//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos = ServoType(type: "Servo", pinTypes: ["Digital"])
    var motors = MotorType(type: "Motor", pinTypes: ["Digital"])
    var motion = DeviceCategory(category: "Motion")
    
    var bmp390I2C = BMP390_I2CType(type: "BMP390 I2C", pinTypes: ["SCK", "SDA"])
    var altimeters = DeviceCategory(category: "Altimeters")
    
    var bno08xSPI = BNO08X_SPIType(type: "BNO08X", pinTypes: [""])
    var imu = DeviceCategory(category: "Inertial Measurement Units")
    
    @Published var ESP32Devices: [DeviceCategory] = [] {
        didSet {
        }
    }
    
    enum CodingKeys: CodingKey {
        case label, icon
    }
    
    func getServos() -> DeviceType {
        return ESP32Devices[0].deviceTypes[0]
    }
    
    func getBMP390_I2C() -> DeviceType {
        return ESP32Devices[1].deviceTypes[0]
    }
    
    func getBNO08X_SPI() -> DeviceType {
        return ESP32Devices[2].deviceTypes[0]
    }
    
    init() {
        motion.addDevice(deviceType: servos)
        motion.addDevice(deviceType: motors)
        
        altimeters.addDevice(deviceType: bmp390I2C)
        
        imu.addDevice(deviceType: bno08xSPI)
        
        ESP32Devices.append(motion)
        ESP32Devices.append(altimeters)
        ESP32Devices.append(imu)

    }
    
    func saveState() {
        let encoder = JSONEncoder()
        for deviceCategory in self.ESP32Devices {
            if let encoded = try? encoder.encode(deviceCategory) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: deviceCategory.category)
            }
        }
    }
    
    func getState() {
        let defaults = UserDefaults.standard
        var count = 0
        for deviceCategory in self.ESP32Devices {
            if let savedDeviceCategory = defaults.object(forKey: deviceCategory.category) as? Data {
                let decoder = JSONDecoder()
                if let loadedDeviceCategory = try? decoder.decode(DeviceCategory.self, from: savedDeviceCategory) {
                    self.ESP32Devices[count].deviceTypes = loadedDeviceCategory.deviceTypes
                }
            }
            count += 1
        }
    }
    
    func cleanState() {
        for deviceCategory in ESP32Devices {
            for deviceType in deviceCategory.deviceTypes {
                deviceType.resetDevices()
            }
        }
    }
    
    //For testing previews:
    convenience init(servo : ServoType) {
        self.init()
        self.servos.devices.append(Device(name: "Servo", attachedPins: [AttachedPin(pinName: "Digital", pinNumber: 5)]))
        self.servos.devices.append(Device(name: "Servo", attachedPins: [AttachedPin(pinName: "Digital", pinNumber: 8)]))
    }
    
    convenience init(bmp390 : BMP390_I2CType) {
        self.init()
        self.bmp390I2C.devices.append(Device(name: "BMP390 I2C", attachedPins: [AttachedPin(pinName: "SCK", pinNumber: 5)]))
        self.bmp390I2C.devices.append(Device(name: "BMP390 I2C", attachedPins: [AttachedPin(pinName: "SCK", pinNumber: 5)]))
    }
    
    convenience init(bno08x : BNO08X_SPIType) {
        self.init()
        self.bno08xSPI.devices.append(Device(name: "BNO08X SPI1", attachedPins: [AttachedPin(pinName: "SCK", pinNumber: 5)]))
        self.bno08xSPI.devices.append(Device(name: "BNO08X SPI2", attachedPins: [AttachedPin(pinName: "SCK", pinNumber: 5)]))
    }
}
