//
//  BMP390_SPI_Type.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/3/24.
//

import Foundation

class BMP390 : Device {
    var temperatureData : [Int] = []
    var pressureData : [Int] = []
    var AltitudeData : [Int] = []
    
    var I2C_or_SPI : SerialCommunicationProtocol = .noInit
    
    enum SerialCommunicationProtocol {
        case noInit
        case I2C
        case SPI
    }
    
    func setSerialCommunicationProtocol(I2C_or_SPI : SerialCommunicationProtocol) {
        self.I2C_or_SPI = I2C_or_SPI
    }
}


