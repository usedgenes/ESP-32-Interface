//
//  BTUUIDs.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 28/11/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import CoreBluetooth


struct BTUUIDs {
    static let blinkUUID = CBUUID(string: "e94f85c8-7f57-4dbd-b8d3-2b56e107ed60")
    
    static let esp32Service = CBUUID(string: "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d")
    
    static let servoUUID = CBUUID(string:"f74fb3de-61d1-4f49-bd77-419b61d188da")
}
