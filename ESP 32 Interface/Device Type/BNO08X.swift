import Foundation
import SwiftUICharts

class BNO08X : Device {
    @Published var rotationXData : [LineChartDataPoint] = []
    @Published var rotationYData : [LineChartDataPoint] = []
    @Published var rotationZData : [LineChartDataPoint] = []

    @Published var gyroXData : [LineChartDataPoint] = []
    @Published var gyroYData : [LineChartDataPoint] = []
    @Published var gyroZData : [LineChartDataPoint] = []

    @Published var accelerometerXData : [LineChartDataPoint] = []
    @Published var accelerometerYData : [LineChartDataPoint] = []
    @Published var accelerometerZData : [LineChartDataPoint] = []


    func addRotationX(rotationX: Float) {
        rotationXData.append(LineChartDataPoint(value: Double(rotationX), xAxisLabel: "", description: "Rotation X"))
    }
    
    func addRotationY(rotationY: Float) {
        rotationYData.append(LineChartDataPoint(value: Double(rotationY), xAxisLabel: "", description: "Rotation Y"))
    }
    
    func addRotationZ(rotationZ: Float) {
        rotationZData.append(LineChartDataPoint(value: Double(rotationZ), xAxisLabel: "", description: "Rotation Z"))
    }
    
    func addGyroX(gyroX: Float) {
        gyroXData.append(LineChartDataPoint(value: Double(gyroX), xAxisLabel: "", description: "Gyro X"))
    }
    
    func addGyroY(gyroY: Float) {
        gyroZData.append(LineChartDataPoint(value: Double(gyroY), xAxisLabel: "", description: "Gyro Y"))
    }
    
    func addGyroZ(gyroZ: Float) {
        gyroZData.append(LineChartDataPoint(value: Double(gyroZ), xAxisLabel: "", description: "Gyro Z"))
    }
    
    func addAltitude(altitude: Float) {
        accelerometerData.append(LineChartDataPoint(value: Double(altitude), xAxisLabel: "", description: "Accelerometer"))
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
    
    func resetData() {
        temperatureData.removeAll()
        pressureData.removeAll()
        altitudeData.removeAll()
    }
}
