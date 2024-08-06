import Foundation
import SwiftUICharts

class BMP390 : Device {
    
    @Published var temperatureData : [LineChartDataPoint] = []
    @Published var pressureData : [LineChartDataPoint] = []
    @Published var altitudeData : [LineChartDataPoint] = []

    func addTemperature(temperature: Float) {
        temperatureData.append(LineChartDataPoint(value: Double(temperature), description: "Temperature"))
    }
    
    func addPressure(pressure: Float) {
        pressureData.append(LineChartDataPoint(value: Double(pressure), description: "Test"))
    }
    
    func addAltitude(altitude: Float) {
        altitudeData.append(LineChartDataPoint(value: Double(altitude), description: "Altitude"))
    }
    
    func getTemperatureDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: temperatureData,
                           legendTitle: "Temperature",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getPressureDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: pressureData,
                           legendTitle: "Pressure",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getAltitudeDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: altitudeData,
                           legendTitle: "Altitude",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func resetData() {
        for number in 0..<temperatureData.count {
            temperatureData.remove(at: number)
        }
        
        for number in 0..<pressureData.count {
            pressureData.remove(at: number)
        }
        
        for number in 0..<altitudeData.count {
            altitudeData.remove(at: number)
        }
    }
}


