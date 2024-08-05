import Foundation
import LineChartView

class BMP390 : Device {
    
    @Published var temperatureData : Float = 0 {
        
    }
    @Published var pressureData : Float = 0
    @Published var altitudeData : Float = 0
    
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


