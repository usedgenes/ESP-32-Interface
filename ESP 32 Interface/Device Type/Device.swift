import Foundation

class AttachedPin : NSObject, Identifiable, ObservableObject {
    @Published var pinName : String
    @Published var pinNumber : Int
    init(pinName: String, pinNumber: Int) {
        self.pinName = pinName
        self.pinNumber = pinNumber
    }
    
    func setNumber(pinNumber : Int) {
        self.pinNumber = pinNumber
    }
}

class Device: NSObject, Identifiable {
    var name: String
    var attachedPins : [AttachedPin]
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

