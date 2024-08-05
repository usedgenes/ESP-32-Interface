//
//  BMP390_SPI_Type.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/3/24.
//

import Foundation

class BMP390 : Device {
    
    var temperatureData : [Float] = []
    var pressureData : [Float] = []
    var altitudeData : [Float] = []
    
    func addTemperature(temperature: Float) {
        temperatureData.append(temperature)
    }
    
    func addPressure(pressure: Float) {
        pressureData.append(pressure)
    }
    
    func addAltitude(altitude: Float) {
        altitudeData.append(altitude)
    }
}


