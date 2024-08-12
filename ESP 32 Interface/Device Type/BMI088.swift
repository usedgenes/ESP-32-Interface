//
//  BMI088.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/12/24.
//

import Foundation
import SwiftUICharts

class BMI088 : Device {

    @Published var gyroXData : [LineChartDataPoint] = []
    @Published var gyroYData : [LineChartDataPoint] = []
    @Published var gyroZData : [LineChartDataPoint] = []

    @Published var accelerometerXData : [LineChartDataPoint] = []
    @Published var accelerometerYData : [LineChartDataPoint] = []
    @Published var accelerometerZData : [LineChartDataPoint] = []

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

    func getGyroX() -> LineDataSet {
        return LineDataSet(dataPoints: gyroXData,
                           legendTitle: "rad/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getGyroY() -> LineDataSet {
        return LineDataSet(dataPoints: gyroYData,
                           legendTitle: "rad/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getGyroZ() -> LineDataSet {
        return LineDataSet(dataPoints: gyroZData,
                           legendTitle: "rad/s",
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
        resetGyro()
        resetAccelerometer()
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
