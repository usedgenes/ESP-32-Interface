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
    var servoPosition = 0
    
    init(name: String, attachedPins : [AttachedPin]) {
        self.name = name
        self.attachedPins = attachedPins
    }
    
    enum CodingKeys: CodingKey {
        case name
        case attachedPins
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        self.attachedPins = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
}


class DeviceType: NSObject, Identifiable, ObservableObject {
    var type: String
    @Published var devices : [Device] = []
    var pinTypes: [String] = []
    init(type: String, pinTypes: [String]) {
        self.type = type
        self.pinTypes = pinTypes
    }
    
    func deleteDevice(device: Device) {
        for number in 0..<devices.count {
            print(number)
            if(devices[number] === device) {
                print(number)
                devices.remove(at: number)
                break
            }
        }
    }
    
    func sendData(device : Device, bluetoothDevice : BluetoothDeviceHelper) {
        
    }
}

class DeviceCategory: NSObject, Identifiable {
    var category: String
    var deviceTypes: [DeviceType] = []
    init(category: String) {
        self.category = category
    }
    
    func addDevice(deviceType : DeviceType) {
        deviceTypes.append(deviceType)
    }
}

