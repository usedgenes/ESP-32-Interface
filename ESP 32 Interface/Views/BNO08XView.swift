import SwiftUI
import SwiftUICharts

struct BNO08XView: View {
    
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBNO08Xs().devices.isEmpty) {
                Text("No BNO08Xs Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBNO08Xs().devices, id: \.self) { bno08x in
                        let _ = print(bno08x)
                        individualBNO08XView(bno08x: bno08x as! BNO08X)
                    }
                }
                .onAppear(perform: {
                    bluetoothDevice.setBNO08X(input: "0" + String(ESP_32.getBNO08Xs().devices.count))
                    for bno08x in ESP_32.getBNO08Xs().devices {
                        var bno08xPinString = "1"
                        bno08xPinString += String(format: "%02d", ESP_32.getBNO08Xs().getDeviceNumberInArray(inputDevice: bno08x))
                        if(bno08x.attachedPins.count == 2) {
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"SDA"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"SCL"))
                        }
                        else {
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"SCK"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"MISO"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"MOSI"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"CS"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"INT"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"RST"))
                        }
                        
                        bluetoothDevice.setBNO08X(input: bno08xPinString)
                        print(bno08xPinString)
                    }
                })
            }
        }
    }
}

struct individualBNO08XView : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var bno08x : BNO08X
    let items = [GridItem(), GridItem(), GridItem(), GridItem()]
    var body : some View {
        Section() {
            Text("\(bno08x.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                ForEach(bno08x.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                    
                }
            }
            .contentShape(Rectangle())
            HStack {
                NavigationLink("View Data", destination: BNO08XChartView(bno08x: bno08x))
                    .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BNO08XChartView : View {
    @ObservedObject var bno08x : BNO08X
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var ESP_32 : ESP32
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    var body : some View {
        List {
            Text("\(bno08x.name) Data Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Text("Delay: 1 second")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    if(timer == nil) {
                        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                            bluetoothDevice.setBNO08X(input: "2" + String(format: "%02d", ESP_32.getBNO08Xs().getDeviceNumberInArray(inputDevice: bno08x)))
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

            }
            HStack {
                Text("Reset:")
                Button(action: {
                    bno08x.resetRotation()
                }) {
                    Text("Rotation")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bno08x.resetGyro()
                }) {
                    Text("Gyro")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bno08x.resetAccelerometer()
                }) {
                    Text("Gyro")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bno08x.resetAll()
                }) {
                    Text("All")
                }.buttonStyle(BorderlessButtonStyle())

            }.frame(maxWidth: .infinity, alignment: .center)

            GroupBox {
                NavigationLink("Rotation Data", destination: BNO08XRotationView(bno08x: bno08x))
                    .frame(maxWidth: .infinity, alignment: .center)

            }
            GroupBox {
                NavigationLink("Gyro Data", destination: BNO08XGyroView(bno08x: bno08x))
                    .frame(maxWidth: .infinity, alignment: .center)

            }
            GroupBox {
                NavigationLink("Accelerometer Data", destination: BNO08XAccelerationView(bno08x: bno08x))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .onDisappear(perform: {
                timer?.invalidate()
                timer = nil
                timerOn.toggle()})
    }
}

struct BNO08XAccelerationView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        VStack {
            let accelerationXData = LineChartData(dataSets: bno08x.getAccelerometerX(), chartStyle: ChartStyle().getChartStyle())
            Text("Accelerometer X")
            ChartStyle().getGraph(chartData: accelerationXData, colour: .red)

            let accelerationYData = LineChartData(dataSets: bno08x.getAccelerometerY(), chartStyle: ChartStyle().getChartStyle())
            Text("Accelerometer Y")
            ChartStyle().getGraph(chartData: accelerationYData, colour: .green)
            
            let accelerationZData = LineChartData(dataSets: bno08x.getAccelerometerZ(), chartStyle: ChartStyle().getChartStyle())
            Text("Accelerometer Z")
            ChartStyle().getGraph(chartData: accelerationZData, colour: .blue)
        }
    }
}

struct BNO08XGyroView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        VStack {
            let gyroXData = LineChartData(dataSets: bno08x.getGyroX(), chartStyle: ChartStyle().getChartStyle())
            Text("Gyro X")
            ChartStyle().getGraph(chartData: gyroXData, colour: .red)
            
            let gyroYData = LineChartData(dataSets: bno08x.getGyroY(), chartStyle: ChartStyle().getChartStyle())
            Text("Gyro Y")
            ChartStyle().getGraph(chartData: gyroYData, colour: .green)

            let gyroZData = LineChartData(dataSets: bno08x.getGyroZ(), chartStyle: ChartStyle().getChartStyle())
            Text("Gyro Z")
            ChartStyle().getGraph(chartData: gyroZData, colour: .blue)
        }
    }
}

struct BNO08XRotationView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        ScrollView {
            let rotationXData = LineChartData(dataSets: bno08x.getRotationX(), chartStyle: ChartStyle().getChartStyle())
            Text("Rotation X")
            ChartStyle().getGraph(chartData: rotationXData, colour: .red)
            
            let rotationYData = LineChartData(dataSets: bno08x.getRotationY(), chartStyle: ChartStyle().getChartStyle())
            Text("Rotation Y")
            ChartStyle().getGraph(chartData: rotationYData, colour: .green)
            
            let rotationZData = LineChartData(dataSets: bno08x.getRotationZ(), chartStyle: ChartStyle().getChartStyle())
            Text("Rotation Z")
            ChartStyle().getGraph(chartData: rotationZData, colour:.blue)

            let rotationRealData = LineChartData(dataSets: bno08x.getRotationReal(), chartStyle: ChartStyle().getChartStyle())
            Text("Rotation Real")
            ChartStyle().getGraph(chartData: rotationRealData, colour: .purple)
            
            let rotationAccuracyData = LineChartData(dataSets: bno08x.getRotationAccuracy(), chartStyle: ChartStyle().getChartStyle())
            Text("Rotation Accuracy")
            ChartStyle().getGraph(chartData: rotationAccuracyData, colour: .yellow)
        }
    }
}

struct BNO08XView_Previews: PreviewProvider {
    static var previews: some View {
        BNO08XView()
    }
}
