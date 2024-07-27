//
//  DeviceType.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

struct Device: Identifiable {
    let id = UUID()
    let name: String
}

struct DeviceType: Identifiable {
    let id = UUID()
    let type: String
    let devices : [Device]
}

struct DeviceCategory: Identifiable {
    let id = UUID()
    let category: String
    let devicesTypes: [DeviceType]
}

