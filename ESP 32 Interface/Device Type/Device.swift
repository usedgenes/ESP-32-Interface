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
    var servoPosition = 0 {
        didSet{
        }
    }
    
    init(name: String, attachedPins : [AttachedPin]) {
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


class DeviceType: NSObject, Identifiable, ObservableObject, Codable {
    var type: String
    @Published var devices : [Device] = []
    var pinTypes: [String] = []
    
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

    init(type: String, pinTypes: [String]) {
        self.type = type
        self.pinTypes = pinTypes
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
    
    enum CodingKeys: CodingKey {
        case type
        case devices
        case pinTypes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        devices = try container.decode([Device].self, forKey: .devices)
        pinTypes = try container.decode([String].self, forKey: .pinTypes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(devices, forKey: .devices)
        try container.encode(pinTypes, forKey: .pinTypes)
    }
    
    func sendData(device : Device) {
        
    }
}

class DeviceCategory: NSObject, Identifiable, Codable {
    var category: String
    var deviceTypes: [DeviceType] = []
    init(category: String) {
        self.category = category
    }
    
    enum CodingKeys: CodingKey {
        case deviceTypes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deviceTypes = try container.decode([DeviceType].self, forKey: .deviceTypes)
        self.category = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceTypes, forKey: .deviceTypes)
    }
    
    func addDevice(deviceType : DeviceType) {
        deviceTypes.append(deviceType)
    }
}

