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
    
    func addAccelerometerX(accelerometerX: Float) {
        accelerometerXData.append(LineChartDataPoint(value: Double(accelerometerX), xAxisLabel: "", description: "Accelerometer X"))
    }
    
    func addAccelerometerY(accelerometerY: Float) {
        accelerometerYData.append(LineChartDataPoint(value: Double(accelerometerY), xAxisLabel: "", description: "Accelerometer Y"))
    }
    
    func addAccelerometerZ(accelerometerZ: Float) {
        accelerometerZData.append(LineChartDataPoint(value: Double(accelerometerZ), xAxisLabel: "", description: "Accelerometer Z"))
    }
    
    func getRotationX() -> LineDataSet {
        return LineDataSet(dataPoints: rotationXData,
                           legendTitle: "Quaternions",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getRotationY() -> LineDataSet {
        return LineDataSet(dataPoints: rotationYData,
                           legendTitle: "Quaternions",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getRotationZ() -> LineDataSet {
        return LineDataSet(dataPoints: rotationZData,
                           legendTitle: "Quaternions",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getGyroX() -> LineDataSet {
        return LineDataSet(dataPoints: gyroXData,
                           legendTitle: "degrees/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getGyroY() -> LineDataSet {
        return LineDataSet(dataPoints: gyroYData,
                           legendTitle: "degrees/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getGyroZ() -> LineDataSet {
        return LineDataSet(dataPoints: gyroZData,
                           legendTitle: "degrees/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getAccelerometerX() -> LineDataSet {
        return LineDataSet(dataPoints: accelerometerXData,
                           legendTitle: "m/s^2",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getAccelerometerY() -> LineDataSet {
        return LineDataSet(dataPoints: accelerometerYData,
                           legendTitle: "m/s^2",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getAccelerometerZ() -> LineDataSet {
        return LineDataSet(dataPoints: accelerometerZData,
                           legendTitle: "m/s^2",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    
    func resetData() {
        rotationXData.removeAll()
        rotationYData.removeAll()
        rotationZData.removeAll()
        gyroXData.removeAll()
        gyroYData.removeAll()
        gyroZData.removeAll()
        accelerometerXData.removeAll()
        accelerometerYData.removeAll()
        accelerometerZData.removeAll()
    }
}
