import Foundation
import LineChartView

class BMP390 : Device {
    
    @Published var temperatureData : [Float] = []
    @Published var pressureData : [Float] = []
    @Published var altitudeData : [Float] = []
    
    @Published var temperatureChart : [LineChartData] = []
    @Published var pressureChart : [LineChartData] = []
    @Published var altitudeChart : [LineChartData] = []
    
    func addTemperature(temperature: Float) {
        temperatureChart.append(LineChartData(Double(temperature)))
    }
    
    func addPressure(pressure: Float) {
        altitudeChart.append(LineChartData(Double(pressure)))
    }
    
    func addAltitude(altitude: Float) {
        altitudeChart.append(LineChartData(Double(altitude)))
    }
    
}


