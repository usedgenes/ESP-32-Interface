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
    
    @State var rollKp : String = "50.0"
    @State var rollKi : String = "0.5"
    @State var rollKd : String = "0.0"
    @State var pitchKp : String = "50.0"
    @State var pitchKi : String = "0.0"
    @State var pitchKd : String = "0.0"
    @State var yawKp : String = "50.0"
    @State var yawKi : String = "0.0"
    @State var yawKd : String = "0.0"
    
    
    @EnvironmentObject var bmi088EDF : BMI088EDF
    
    var body: some View {
        ScrollView {
            Section {
                Text("PID Values")
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + rollKp + "," + rollKi + "!" + rollKd)
                        bluetoothDevice.setPID(input: "1" + pitchKp + "," + pitchKi + "!" + pitchKd)
                        bluetoothDevice.setPID(input: "2" + yawKp + "," + yawKi + "!" + yawKd)
                    }) {
                        Text("Apply")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        bluetoothDevice.setReset(input: "0")
                    }) {
                        Text("RESET ESP32")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
                HStack {
                    Text("Roll:")
                    Text("Kp:")
                    TextField(rollKp, text: Binding<String>(
                        get: { rollKp },
                        set: {
                            rollKp = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField(rollKi, text: Binding<String>(
                        get: { rollKi },
                        set: {
                            rollKi = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField(rollKd, text: Binding<String>(
                        get: { rollKd },
                        set: {
                            rollKd = $0
                            
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                HStack {
                    Text("Pitch:")
                    Text("Kp:")
                    TextField(pitchKp, text: Binding<String>(
                        get: { pitchKp },
                        set: {
                            pitchKp = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField(pitchKi, text: Binding<String>(
                        get: { pitchKi },
                        set: {
                            
                            pitchKi = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField(pitchKd, text: Binding<String>(
                        get: { pitchKd },
                        set: {
                            pitchKd = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                HStack {
                    Text("Yaw:")
                    Text("Kp:")
                    TextField(yawKp, text: Binding<String>(
                        get: { yawKp },
                        set: {
                            yawKp = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Ki:")
                    TextField(yawKi, text: Binding<String>(
                        get: { yawKi },
                        set: {
                            yawKi = $0
                        }))
                    .keyboardType(UIKeyboardType.decimalPad)
                    Text("Kd:")
                    TextField(yawKd, text: Binding<String>(
                        get: { yawKd },
                        set: {
                            yawKd = $0
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
            GroupBox {
                NavigationLink("View Orientation:", destination: edfGraphView())
                    .padding()
            }
            GroupBox {
                NavigationLink("View PID Values:", destination: servoPosView())
                    .padding()
            }
        }.hideKeyboardWhenTappedAround()
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct edfGraphView : View {
    @EnvironmentObject var bmi088EDF : BMI088EDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    
    var body : some View {
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
                    bmi088EDF.resetRotation()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    bluetoothDevice.setBMI088(input: "1")
                }) {
                    Text("Calibrate")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }.onDisappear(perform: {
            timer?.invalidate()
            timer = nil
            timerOn.toggle()})
        let yawData = LineChartData(dataSets: bmi088EDF.getYaw(), chartStyle: ChartStyle().getChartStyle())
        
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

struct servoPosView : View {
    @EnvironmentObject var bmi088EDF : BMI088EDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 500
    
    var body: some View {
        Section {
            Text("Servo Position Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    if(timer == nil) {
                        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                            bluetoothDevice.setServos(input: "2")
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
                    bmi088EDF.resetRotation()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }.onDisappear(perform: {
            timer?.invalidate()
            timer = nil
            timerOn.toggle()})
        let servo0data = LineChartData(dataSets: bmi088EDF.getServo0Pos(), chartStyle: ChartStyle().getChartStyle())
        
        Text("Servo 0 Position")
        LineChart(chartData: servo0data)
            .filledTopLine(chartData: servo0data,
                           lineColour: ColourStyle(colour: .red),
                           strokeStyle: StrokeStyle(lineWidth: 3))
            .touchOverlay(chartData: servo0data, specifier: "%.2f")
            .xAxisGrid(chartData: servo0data)
            .yAxisGrid(chartData: servo0data)
            .xAxisLabels(chartData: servo0data)
            .yAxisLabels(chartData: servo0data, specifier: "%.2f")
            .floatingInfoBox(chartData: servo0data)
            .id(servo0data.id)
            .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
        
        let servo1data = LineChartData(dataSets: bmi088EDF.getServo1Pos(), chartStyle: ChartStyle().getChartStyle())
        
        Text("Servo 1 Position")
        LineChart(chartData: servo1data)
            .filledTopLine(chartData: servo1data,
                           lineColour: ColourStyle(colour: .green),
                           strokeStyle: StrokeStyle(lineWidth: 3))
            .touchOverlay(chartData: servo1data, specifier: "%.2f")
            .xAxisGrid(chartData: servo1data)
            .yAxisGrid(chartData: servo1data)
            .xAxisLabels(chartData: servo1data)
            .yAxisLabels(chartData: servo1data, specifier: "%.2f")
            .floatingInfoBox(chartData: servo1data)
            .id(servo1data.id)
            .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
        
        let servo2data = LineChartData(dataSets: bmi088EDF.getServo2Pos(), chartStyle: ChartStyle().getChartStyle())
        
        Text("Servo 2 Position")
        LineChart(chartData: servo2data)
            .filledTopLine(chartData: servo2data,
                           lineColour: ColourStyle(colour: .blue),
                           strokeStyle: StrokeStyle(lineWidth: 3))
            .touchOverlay(chartData: servo2data, specifier: "%.2f")
            .xAxisGrid(chartData: servo2data)
            .yAxisGrid(chartData: servo2data)
            .xAxisLabels(chartData: servo2data)
            .yAxisLabels(chartData: servo2data, specifier: "%.2f")
            .floatingInfoBox(chartData: servo2data)
            .id(servo2data.id)
            .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
        
        let servo3data = LineChartData(dataSets: bmi088EDF.getServo3Pos(), chartStyle: ChartStyle().getChartStyle())
        
        Text("Servo 3 Position")
        LineChart(chartData: servo3data)
            .filledTopLine(chartData: servo3data,
                           lineColour: ColourStyle(colour: .purple),
                           strokeStyle: StrokeStyle(lineWidth: 3))
            .touchOverlay(chartData: servo3data, specifier: "%.2f")
            .xAxisGrid(chartData: servo3data)
            .yAxisGrid(chartData: servo3data)
            .xAxisLabels(chartData: servo3data)
            .yAxisLabels(chartData: servo3data, specifier: "%.2f")
            .floatingInfoBox(chartData: servo3data)
            .id(servo3data.id)
            .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
    }
}

struct ThrustVectoringEDFView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringEDFView()
    }
}
