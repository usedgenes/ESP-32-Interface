//
//  ESP32.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class ESP32 : ObservableObject {
    var servos = DeviceType(type: "servo")
    var motion = DeviceCategory(category: "motion", deviceTypes: <#[DeviceType]#>
    var altimeter
    var ESP32Devices: [DeviceCategory]
    
                                init() {
        
    }
}
