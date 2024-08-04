import Foundation


class AttachedPin : NSObject, Identifiable, ObservableObject, Codable {
    @Published var pinName : String
    @Published var pinNumber : Int
    
    init(pinName: String, pinNumber: Int) {
        self.pinName = pinName
        self.pinNumber = pinNumber
        
    }
    
    func setNumber(pinNumber : Int) {
        self.pinNumber = pinNumber
    }
    
    enum CodingKeys: CodingKey {
        case pinName
        case pinNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pinName = try container.decode(String.self, forKey: .pinName)
        pinNumber = try container.decode(Int.self, forKey: .pinNumber)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pinName, forKey: .pinName)
        try container.encode(pinNumber, forKey: .pinNumber)
    }
}

class Device: NSObject, Identifiable, ObservableObject, Codable {
    @Published var name: String
    var attachedPins : [AttachedPin]
    
    required init(name: String, attachedPins : [AttachedPin]) {
        self.name = name
        self.attachedPins = attachedPins
    }
    
    func getPinNumber(name: String) -> Int {
        for attachedPin in attachedPins {
            if(attachedPin.pinName == name) {
                return attachedPin.pinNumber
            }
        }
        return -1
    }
        
    enum CodingKeys: CodingKey {
        case name
        case attachedPins
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        attachedPins = try container.decode([AttachedPin].self, forKey: .attachedPins)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(attachedPins, forKey: .attachedPins)
    }
    
}

class DeviceArray: NSObject, Identifiable, ObservableObject {
    var name : String
    @Published var devices : [Device] = []
    
    init(name: String) {
        self.name = name
    }
    
    func getDevices() -> [Device] {
        return devices
    }
    
    func addDevice(device: Device) {
        devices.append(device)
    }
    
    func resetDevices() {
        for device in devices {
            deleteDevice(device: device)
        }
    }
    
    func deleteDevice(device: Device) {
        for number in 0..<devices.count {
            if(devices[number] === device) {
                devices.remove(at: number)
                break
            }
        }
    }
    
    func getDeviceNumberInArray(inputDevice: Device) -> Int {
            var counter = 0
            for device in devices {
                if(device === inputDevice) {
                    return counter
                }
                counter += 1
            }
            return -1
    }
}

class DeviceType: NSObject, Identifiable, ObservableObject {
    var type: String
    var deviceType : Device.Type
    @Published var devices : DeviceArray
    var pinTypes: [String] = []

    init(type: String, pinTypes: [String], deviceType: Device.Type, devices : DeviceArray) {
        self.type = type
        self.pinTypes = pinTypes
        self.deviceType = deviceType
        self.devices = devices
    }
}


