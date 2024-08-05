import Foundation
import SwiftUICharts

class BMP390 : Device {
    
    @Published var temperatureData : [LineChartDataPoint] = []

    func addTemperature(temperature: Float) {
        temperatureData.append(LineChartDataPoint(value: Double(temperature), description: "Temperature"))
    }
    
    func addPressure(pressure: Float) {
    }
    
    func addAltitude(altitude: Float) {
    }
    
    func getTemperatureDataSet() -> LineDataSet {
        return LineDataSet(dataPoints: temperatureData,
                           legendTitle: "Temperature",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
}


