//
//  DeviceType.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class Device: Identifiable {
    let id = UUID()
    let name: String
    let pins : [Int] = []
    init(name: String) {
        self.name = name
    }
}

class DeviceType: Identifiable {
    let id = UUID()
    let type: String
    let devices : [Device]
    init(type: String, devices: [Device]) {
        self.type = type
        self.devices = devices
    }
}

class DeviceCategory: Identifiable {
    let id = UUID()
    let category: String
    let deviceTypes: [DeviceType]
    init(category: String, deviceTypes: [DeviceType]) {
        self.category = category
        self.deviceTypes = deviceTypes
    }
}

