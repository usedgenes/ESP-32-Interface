//
//  BMP390_SPI_Type.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/3/24.
//

import Foundation

class BMP390_SPI : Device {
    var temperatureData : [Int] = []
    var pressureData : [Int] = []
    var AltitudeData : [Int] = []

}
