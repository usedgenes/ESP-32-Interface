//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject, Codable, RawRepresentable {
    var servos = ServoType(type: "Servo", pinTypes: ["Digital"])
    var motors = MotorType(type: "Motor", pinTypes: ["Digital"])
    var motion = DeviceCategory(category: "Motion")
    
    var bmp390I2C = BMP390_I2CType(type: "BMP390 I2C", pinTypes: ["SCK", "SDA"])
    var altimeters = DeviceCategory(category: "Altimeters")
    
    var bno08xSPI = BNO08X_SPIType(type: "BNO08X", pinTypes: [""])
    var imu = DeviceCategory(category: "Inertial Measurement Units")
    
    @Published var label = "Text"
    @Published var icon = "questionmark.app"
    
    @Published var ESP32Devices: [DeviceCategory] = [] {
        didSet {
        }
    }
    
    enum CodingKeys: CodingKey {
        case label, icon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        icon = try container.decode(String.self, forKey: .icon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(icon, forKey: .icon)
    }
    
    // The next two items are to conform to RawRepresentable
    required init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(ESP32.self, from: data)
        else {
            return nil
        }
        label = result.label
        icon = result.icon
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
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
    
    func saveState() {
        let encoder = JSONEncoder()
        for deviceCategories in self.ESP32Devices {
            for deviceType in deviceCategories.deviceTypes {
                if let encoded = try? encoder.encode(deviceType) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: deviceType.type)
                    print(deviceType.type + "\(deviceType.devices.count)")
                }
            }
        }
    }
    
    func getState() {
        let defaults = UserDefaults.standard
        for deviceCategories in self.ESP32Devices {
            for deviceType in deviceCategories.deviceTypes {
                if let savedDevices = defaults.object(forKey: deviceType.type) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedDevices = try? decoder.decode(DeviceType.self, from: savedDevices) {
                        print("hi")
                        print(loadedDevices.devices.count)
                    }
                }
            }
        }
        
    }
    
    func cleanState() {
    }
}
