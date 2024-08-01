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
        case pinName, pinNumber
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
    
    // The next two items are to conform to RawRepresentable
    required init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(AttachedPin.self, from: data)
        else {
            return nil
        }
        pinName = result.pinName
        pinNumber = result.pinNumber
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

class Device: NSObject, Identifiable, ObservableObject {
    @Published var name: String
    var attachedPins : [AttachedPin]
    var servoPosition = 0
    init(name: String, attachedPins : [AttachedPin]) {
        self.name = name
        self.attachedPins = attachedPins
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

