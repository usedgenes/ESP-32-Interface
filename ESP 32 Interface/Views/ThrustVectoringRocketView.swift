import SwiftUI
import SwiftUICharts

struct ThrustVectoringRocketView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var servo2Position : Double = 0
    @State var servo3Position : Double = 0
    @State var edfPower : Double = 50
    
    @State var rollKp : String = "50.0"
    @State var rollKi : String = "0.5"
    @State var rollKd : String = "0.0"
    @State var pitchKp : String = "50.0"
    @State var pitchKi : String = "0.0"
    @State var pitchKd : String = "0.0"
    @State var yawKp : String = "50.0"
    @State var yawKi : String = "0.0"
    @State var yawKd : String = "0.0"
    
    
    @EnvironmentObject var bmi088EDF : BNO08XEDF
    
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
                }), in: 50...180, step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "4" + String(Int(edfPower)))
                    }
                }
            }.padding()
            GroupBox {
                NavigationLink("View Orientation:", destination: rocketGraphView())
                    .padding()
            }
            GroupBox {
                NavigationLink("View Servo Values:", destination: rocketServoPosView())
                    .padding()
            }
            GroupBox {
                NavigationLink("View PID Values:", destination: rocketPidView())
                    .padding()
            }
        }.hideKeyboardWhenTappedAround()
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct rocketGraphView : View {
    @EnvironmentObject var bmi088EDF : BNO08XEDF
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
        ChartStyle().getGraph(chartData: yawData, colour: .red)
        
        let pitchData = LineChartData(dataSets: bmi088EDF.getPitch(), chartStyle: ChartStyle().getChartStyle())
        Text("Pitch")
        ChartStyle().getGraph(chartData: pitchData, colour: .green)
        
        let rollData = LineChartData(dataSets: bmi088EDF.getRoll(), chartStyle: ChartStyle().getChartStyle())
        Text("Roll")
        ChartStyle().getGraph(chartData: rollData, colour: .blue)
    }
}

struct rocketServoPosView : View {
    @EnvironmentObject var bmi088EDF : BNO08XEDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    
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
                    bmi088EDF.resetServoPos()
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
        ChartStyle().getGraph(chartData: servo0data, colour: .red)
        
        let servo1data = LineChartData(dataSets: bmi088EDF.getServo1Pos(), chartStyle: ChartStyle().getChartStyle())
        Text("Servo 1 Position")
        ChartStyle().getGraph(chartData: servo1data, colour: .green)
    }
}

struct rocketPidView : View {
    @EnvironmentObject var bmi088EDF : BNO08XEDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    
    var body: some View {
        Section {
            Text("PID Command Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    if(timer == nil) {
                        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                            bluetoothDevice.setPID(input: "3")
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
                    bmi088EDF.resetPIDCommands()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }.onDisappear(perform: {
            timer?.invalidate()
            timer = nil
            timerOn.toggle()})
        
        let yawCmd = LineChartData(dataSets: bmi088EDF.getYawCommand(), chartStyle: ChartStyle().getChartStyle())
        Text("Yaw Command")
        ChartStyle().getGraph(chartData: yawCmd, colour: .red)
        
        let pitchCmd = LineChartData(dataSets: bmi088EDF.getPitchCommand(), chartStyle: ChartStyle().getChartStyle())
        Text("Pitch Command")
        ChartStyle().getGraph(chartData: pitchCmd, colour: .green)
        
        let rollCmd = LineChartData(dataSets: bmi088EDF.getRollCommand(), chartStyle: ChartStyle().getChartStyle())
        Text("Roll Command")
        ChartStyle().getGraph(chartData: rollCmd, colour: .blue)
    }
}

struct ThrustVectoringRocketView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringRocketView()
    }
}
