//
//  ThrustVectoringEDFView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/14/24.
//

import SwiftUI
import SwiftUICharts

struct ThrustVectoringEDFView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var servo2Position : Double = 0
    @State var servo3Position : Double = 0
    @State var edfPower : Double = 60
    
    @State var rollKp : Double = 50
    @State var rollKi : Double = 0.5
    @State var rollKd : Double = 0
    @State var pitchKp : Double = 50
    @State var pitchKi : Double = 0
    @State var pitchKd : Double = 0
    @State var yawKp : Double = 50
    @State var yawKi : Double = 0
    @State var yawKd : Double = 0
    
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    
    @EnvironmentObject var bmi088EDF : BMI088EDF
    
    var body: some View {
        ScrollView {
            Section {
                HStack {
                    Text("PID Values")
                        .padding(.trailing)
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + String(rollKp) + "," + String(rollKi) + "!" + String(rollKd))
                        bluetoothDevice.setPID(input: "1" + String(pitchKp) + "," + String(pitchKi) + "!" + String(pitchKd))
                        bluetoothDevice.setPID(input: "2" + String(yawKp) + "," + String(yawKi) + "!" + String(yawKd))
                    }) {
                        Text("Apply")
                    }.buttonStyle(BorderlessButtonStyle())
                }
                HStack {
                    Text("Roll:")
                    Text("Kp:")
                    TextField("\(rollKp)", text: Binding<String>(
                        get: { String(rollKp) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                rollKp = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField("\(rollKi)", text: Binding<String>(
                        get: { String(rollKi) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                rollKi = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField("\(rollKd)", text: Binding<String>(
                        get: { String(rollKd) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                rollKd = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                HStack {
                    Text("Pitch:")
                    Text("Kp:")
                    TextField("\(pitchKp)", text: Binding<String>(
                        get: { String(pitchKp) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                pitchKp = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField("\(pitchKi)", text: Binding<String>(
                        get: { String(pitchKi) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                pitchKi = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField("\(pitchKd)", text: Binding<String>(
                        get: { String(pitchKd) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                pitchKd = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                HStack {
                    Text("Yaw:")
                    Text("Kp:")
                    TextField("\(yawKp)", text: Binding<String>(
                        get: { String(yawKp) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                yawKp = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField("\(yawKi)", text: Binding<String>(
                        get: { String(yawKi) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                yawKi = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField("\(yawKd)", text: Binding<String>(
                        get: { String(yawKd) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                yawKd = value.doubleValue
                            }
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                }
            }.padding(.leading)
            
            Section {
                HStack {
                    Text("Servo 0: " + String(Int(servo0Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo0Position
                    }, set: { (newVal) in
                        servo0Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "0" + String(Int(servo0Position)))
                        }
                    }
                }.padding()
                HStack {
                    Text("Servo 1: " + String(Int(servo1Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo1Position
                    }, set: { (newVal) in
                        servo1Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "1" + String(Int(servo1Position)))
                        }
                    }
                }.padding()
                HStack {
                    Text("Servo 2: " + String(Int(servo2Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo2Position
                    }, set: { (newVal) in
                        servo2Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "2" + String(Int(servo2Position)))
                        }
                    }
                }.padding()
                HStack {
                    Text("Servo 3: " + String(Int(servo3Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo3Position
                    }, set: { (newVal) in
                        servo3Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if (!editing) {
                            bluetoothDevice.setServos(input: "3" + String(Int(servo3Position)))
                        }
                    }
                }.padding()
            }
            HStack {
                Text("EDF Power: " + String(Int(edfPower)))
                    .padding(.trailing)
                Slider(value: Binding(get: {
                    edfPower
                }, set: { (newVal) in
                    edfPower = newVal
                }), in: 60...180, step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "4" + String(Int(edfPower)))
                    }
                }
            }.padding()
            
            Section {
                Text("BMI088 Data Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        if(timer == nil) {
                            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                                bluetoothDevice.setBMI088(input: "0")
                            })
                        }
                        timerOn.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(timerOn)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        if timer != nil {
                            timer?.invalidate()
                            timer = nil
                            timerOn.toggle()
                        }
                    }) {
                        Text("Stop")
                    }.disabled(!timerOn)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        bmi088EDF.resetAll()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }
            let yawData = LineChartData(dataSets: bmi088EDF.getYaw(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro x
            Text("Yaw")
            LineChart(chartData: yawData)
                .filledTopLine(chartData: yawData,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: yawData, specifier: "%.2f")
                .xAxisGrid(chartData: yawData)
                .yAxisGrid(chartData: yawData)
                .xAxisLabels(chartData: yawData)
                .yAxisLabels(chartData: yawData, specifier: "%.2f")
                .floatingInfoBox(chartData: yawData)
                .id(yawData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            
            let pitchData = LineChartData(dataSets: bmi088EDF.getPitch(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro y
            Text("Pitch")
            LineChart(chartData: pitchData)
                .filledTopLine(chartData: pitchData,
                               lineColour: ColourStyle(colour: .green),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: pitchData, specifier: "%.2f")
                .xAxisGrid(chartData: pitchData)
                .yAxisGrid(chartData: pitchData)
                .xAxisLabels(chartData: pitchData)
                .yAxisLabels(chartData: pitchData, specifier: "%.2f")
                .floatingInfoBox(chartData: pitchData)
                .id(pitchData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            
            let rollData = LineChartData(dataSets: bmi088EDF.getRoll(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro z
            Text("Roll")
            LineChart(chartData: rollData)
                .filledTopLine(chartData: rollData,
                               lineColour: ColourStyle(colour: .blue),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rollData, specifier: "%.2f")
                .xAxisGrid(chartData: rollData)
                .yAxisGrid(chartData: rollData)
                .xAxisLabels(chartData: rollData)
                .yAxisLabels(chartData: rollData, specifier: "%.2f")
                .floatingInfoBox(chartData: rollData)
                .id(rollData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
        }
    }
}

struct ThrustVectoringEDFView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringEDFView()
    }
}
