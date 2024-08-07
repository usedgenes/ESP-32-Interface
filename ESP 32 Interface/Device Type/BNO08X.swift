import Foundation
import SwiftUICharts

class BNO08X : Device {
    @Published var rotationXData : [LineChartDataPoint] = []
    @Published var rotationYData : [LineChartDataPoint] = []
    @Published var rotationZData : [LineChartDataPoint] = []
    @Published var rotationRealData : [LineChartDataPoint] = []
    @Published var rotationAccuracyData : [LineChartDataPoint] = []

    @Published var gyroXData : [LineChartDataPoint] = []
    @Published var gyroYData : [LineChartDataPoint] = []
    @Published var gyroZData : [LineChartDataPoint] = []

    @Published var accelerometerXData : [LineChartDataPoint] = []
    @Published var accelerometerYData : [LineChartDataPoint] = []
    @Published var accelerometerZData : [LineChartDataPoint] = []


    func addRotationX(rotationX: Float) {
        rotationXData.append(LineChartDataPoint(value: Double(rotationX), xAxisLabel: " ", description: "X"))
    }
    
    func addRotationY(rotationY: Float) {
        rotationYData.append(LineChartDataPoint(value: Double(rotationY), xAxisLabel: " ", description: "Y"))
    }
    
    func addRotationZ(rotationZ: Float) {
        rotationZData.append(LineChartDataPoint(value: Double(rotationZ), xAxisLabel: " ", description: "Z"))
    }
    
    func addRotationReal(rotationReal: Float) {
        rotationRealData.append(LineChartDataPoint(value: Double(rotationReal), xAxisLabel: " ", description: "Real"))
    }
    
    func addRotationAccuracy(rotationAccuracy: Float) {
        rotationAccuracyData.append(LineChartDataPoint(value: Double(rotationAccuracy), xAxisLabel: " ", description: "Accuracy"))
    }
    
    func addGyroX(gyroX: Float) {
        gyroXData.append(LineChartDataPoint(value: Double(gyroX), xAxisLabel: " ", description: "X"))
    }
    
    func addGyroY(gyroY: Float) {
        gyroYData.append(LineChartDataPoint(value: Double(gyroY), xAxisLabel: " ", description: "Y"))
    }
    
    func addGyroZ(gyroZ: Float) {
        gyroZData.append(LineChartDataPoint(value: Double(gyroZ), xAxisLabel: " ", description: "Z"))
    }
    
    func addAccelerometerX(accelerometerX: Float) {
        accelerometerXData.append(LineChartDataPoint(value: Double(accelerometerX), xAxisLabel: " ", description: "X"))
    }
    
    func addAccelerometerY(accelerometerY: Float) {
        accelerometerYData.append(LineChartDataPoint(value: Double(accelerometerY), xAxisLabel: " ", description: "Y"))
    }
    
    func addAccelerometerZ(accelerometerZ: Float) {
        accelerometerZData.append(LineChartDataPoint(value: Double(accelerometerZ), xAxisLabel: " ", description: "Z"))
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
    
    func getRotationReal() -> LineDataSet {
        return LineDataSet(dataPoints: rotationRealData,
                           legendTitle: "Quaternions",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .purple), lineType: .line))
    }
    
    func getRotationAccuracy() -> LineDataSet {
        return LineDataSet(dataPoints: rotationAccuracyData,
                           legendTitle: "Quaternions",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .yellow), lineType: .line))
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
    
    func resetAll() {
        resetRotation()
        resetGyro()
        resetAccelerometer()
    }
    
    func resetRotation() {
        rotationXData.removeAll()
        rotationYData.removeAll()
        rotationZData.removeAll()
        rotationRealData.removeAll()
        rotationAccuracyData.removeAll()
    }
    
    func resetGyro() {
        gyroXData.removeAll()
        gyroYData.removeAll()
        gyroZData.removeAll()
    }
    
    func resetAccelerometer() {
        accelerometerXData.removeAll()
        accelerometerYData.removeAll()
        accelerometerZData.removeAll()
    }
}
