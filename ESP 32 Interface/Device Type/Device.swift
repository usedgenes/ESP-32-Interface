import Foundation

class Device: NSObject, Identifiable {
    var name: String
    var pins : [String: Int] = [:]
    init(name: String) {
        self.name = name
    }
}

class DeviceType: NSObject, Identifiable {
    var type: String
    var devices : [Device] = []
    init(type: String) {
        self.type = type
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

