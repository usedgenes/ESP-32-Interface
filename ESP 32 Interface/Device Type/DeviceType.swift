//
//  DeviceType.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/26/24.
//

import Foundation

class Device : NSObject {
    var name: String
    
    init(name: String) {
        self.name = name
        
        super.init()
    }

}
