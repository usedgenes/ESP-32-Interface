//
//  BMI088.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/12/24.
//

import Foundation
import SwiftUICharts

class BMI088EDF : ObservableObject {
    @Published var yawData : [LineChartDataPoint] = []
    @Published var pitchData : [LineChartDataPoint] = []
    @Published var rollData : [LineChartDataPoint] = []
    
    @Published var servo0pos : [LineChartDataPoint] = []
    @Published var servo1pos : [LineChartDataPoint] = []
    @Published var servo2pos : [LineChartDataPoint] = []
    @Published var servo3pos : [LineChartDataPoint] = []

    func addYaw(yaw: Float) {
        yawData.append(LineChartDataPoint(value: Double(yaw * 57.29), xAxisLabel: " ", description: "Yaw"))
    }
    
    func addPitch(pitch: Float) {
        pitchData.append(LineChartDataPoint(value: Double(pitch * 57.29), xAxisLabel: " ", description: "Y"))
    }
    
    func addRoll(roll: Float) {
        rollData.append(LineChartDataPoint(value: Double(roll * 57.29), xAxisLabel: " ", description: "Z"))
    }
    
    func addServo0Pos(pos: Float) {
        yawData.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 0 Pos"))
    }
    
    func addServo1Pos(pos: Float) {
        servo3pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 1 Pos"))
    }
    
    func addServo2Pos(pos: Float) {
        servo2pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 2 Pos"))
    }
    
    func addServo3Pos(pos: Float) {
        servo3pos.append(LineChartDataPoint(value: Double(pos), xAxisLabel: " ", description: "Servo 3 Pos"))
    }
    
    func getYaw() -> LineDataSet {
        return LineDataSet(dataPoints: yawData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getPitch() -> LineDataSet {
        return LineDataSet(dataPoints: pitchData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getRoll() -> LineDataSet {
        return LineDataSet(dataPoints: rollData,
                           legendTitle: "deg/s",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getServo0Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo0pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
    }
    
    func getServo1Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo1pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line))
    }
    
    func getServo2Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo2pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line))
    }
    
    func getServo3Pos() -> LineDataSet {
        return LineDataSet(dataPoints: servo3pos,
                           legendTitle: "deg",
                           pointStyle: PointStyle(),
                           style: LineStyle(lineColour: ColourStyle(colour: .purple), lineType: .line))
    }
    
    func resetRotation() {
        yawData.removeAll()
        pitchData.removeAll()
        rollData.removeAll()
    }
    
    func resetServoPos() {
        servo0pos.removeAll()
        servo1pos.removeAll()
        servo2pos.removeAll()
        servo3pos.removeAll()
    }
}
