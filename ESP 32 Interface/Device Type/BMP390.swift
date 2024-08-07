import Foundation
import SwiftUICharts

class BMP390 : Device {
    
    @Published var temperatureData : [LineChartDataPoint] = []
    @Published var pressureData : [LineChartDataPoint] = []
    @Published var altitudeData : [LineChartDataPoint] = []

    func addTemperature(temperature: Float) {
        temperatureData.append(LineChartDataPoint(value: Double(temperature), xAxisLabel: " ", description: "Temperature"))
    }
    
    func addPressure(pressure: Float) {
        pressureData.append(LineChartDataPoint(value: Double(pressure), xAxisLabel: " ", description: "Pressure"))
    }
    
    func addAltitude(altitude: Float) {
        altitudeData.append(LineChartDataPoint(value: Double(altitude), xAxisLabel: " ", description: "Altitude"))
    }
    
    func getTemperatureDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: temperatureData,
                           legendTitle: "Celsius",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getPressureDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: pressureData,
                           legendTitle: "Pascals",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getAltitudeDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: altitudeData,
                           legendTitle: "Meters",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func resetAll() {
        resetTemperature()
        resetPressure()
        resetAltitude()
    }
    
    func resetTemperature() {
        temperatureData.removeAll()
    }
    
    func resetPressure() {
        pressureData.removeAll()
    }
    
    func resetAltitude() {
        altitudeData.removeAll()
    }
}


