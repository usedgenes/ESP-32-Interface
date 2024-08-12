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
    }
}

struct BNO08XAccelerationView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        VStack {
            let accelerationXData = LineChartData(dataSets: bno08x.getAccelerometerX(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer x
            LineChart(chartData: accelerationXData)
                .filledTopLine(chartData: accelerationXData,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: accelerationXData, specifier: "%.2f")
                .xAxisGrid(chartData: accelerationXData)
                .yAxisGrid(chartData: accelerationXData)
                .xAxisLabels(chartData: accelerationXData)
                .yAxisLabels(chartData: accelerationXData, specifier: "%.2f")
                .floatingInfoBox(chartData: accelerationXData)
                .id(accelerationXData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Accelerometer X")
            
            let accelerationYData = LineChartData(dataSets: bno08x.getAccelerometerY(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer y
            LineChart(chartData: accelerationYData)
                .filledTopLine(chartData: accelerationYData,
                               lineColour: ColourStyle(colour: .green),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: accelerationYData, specifier: "%.2f")
                .xAxisGrid(chartData: accelerationYData)
                .yAxisGrid(chartData: accelerationYData)
                .xAxisLabels(chartData: accelerationYData)
                .yAxisLabels(chartData: accelerationYData, specifier: "%.2f")
                .floatingInfoBox(chartData: accelerationYData)
                .id(accelerationYData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Accelerometer Y")
            
            let accelerationZData = LineChartData(dataSets: bno08x.getAccelerometerZ(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer z
            LineChart(chartData: accelerationZData)
                .filledTopLine(chartData: accelerationZData,
                               lineColour: ColourStyle(colour: .blue),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: accelerationZData, specifier: "%.2f")
                .xAxisGrid(chartData: accelerationZData)
                .yAxisGrid(chartData: accelerationZData)
                .xAxisLabels(chartData: accelerationZData)
                .yAxisLabels(chartData: accelerationZData, specifier: "%.2f")
                .floatingInfoBox(chartData: accelerationZData)
                .id(accelerationZData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Accelerometer Z")
                .padding()
        }
    }
}

struct BNO08XGyroView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        VStack {
            let gyroXData = LineChartData(dataSets: bno08x.getGyroX(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro x
            LineChart(chartData: gyroXData)
                .filledTopLine(chartData: gyroXData,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: gyroXData, specifier: "%.2f")
                .xAxisGrid(chartData: gyroXData)
                .yAxisGrid(chartData: gyroXData)
                .xAxisLabels(chartData: gyroXData)
                .yAxisLabels(chartData: gyroXData, specifier: "%.2f")
                .floatingInfoBox(chartData: gyroXData)
                .id(gyroXData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Gyro X")
                .padding()
            
            let gyroYData = LineChartData(dataSets: bno08x.getGyroY(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro y
            LineChart(chartData: gyroYData)
                .filledTopLine(chartData: gyroYData,
                               lineColour: ColourStyle(colour: .green),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: gyroYData, specifier: "%.2f")
                .xAxisGrid(chartData: gyroYData)
                .yAxisGrid(chartData: gyroYData)
                .xAxisLabels(chartData: gyroYData)
                .yAxisLabels(chartData: gyroYData, specifier: "%.2f")
                .floatingInfoBox(chartData: gyroYData)
                .id(gyroYData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Gyro Y")
                .padding()
            
            let gyroZData = LineChartData(dataSets: bno08x.getGyroZ(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro z
            LineChart(chartData: gyroZData)
                .filledTopLine(chartData: gyroZData,
                               lineColour: ColourStyle(colour: .blue),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: gyroZData, specifier: "%.2f")
                .xAxisGrid(chartData: gyroZData)
                .yAxisGrid(chartData: gyroZData)
                .xAxisLabels(chartData: gyroZData)
                .yAxisLabels(chartData: gyroZData, specifier: "%.2f")
                .floatingInfoBox(chartData: gyroZData)
                .id(gyroZData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Gyro Z")
                .padding()
        }
    }
}
struct BNO08XRotationView: View {
    @ObservedObject var bno08x: BNO08X
    var body: some View {
        ScrollView {
            let rotationXData = LineChartData(dataSets: bno08x.getRotationX(), chartStyle: ChartStyle().getChartStyle())
            
            //rotation x
            LineChart(chartData: rotationXData)
                .filledTopLine(chartData: rotationXData,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rotationXData, specifier: "%.2f")
                .xAxisGrid(chartData: rotationXData)
                .yAxisGrid(chartData: rotationXData)
                .xAxisLabels(chartData: rotationXData)
                .yAxisLabels(chartData: rotationXData, specifier: "%.2f")
                .floatingInfoBox(chartData: rotationXData)
                .id(rotationXData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 600)
            Text("Rotation X")
                .padding()
            
            let rotationYData = LineChartData(dataSets: bno08x.getRotationY(), chartStyle: ChartStyle().getChartStyle())
            
            //rotation y
            LineChart(chartData: rotationYData)
                .filledTopLine(chartData: rotationYData,
                               lineColour: ColourStyle(colour: .green),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rotationYData, specifier: "%.2f")
                .xAxisGrid(chartData: rotationYData)
                .yAxisGrid(chartData: rotationYData)
                .xAxisLabels(chartData: rotationYData)
                .yAxisLabels(chartData: rotationYData, specifier: "%.2f")
                .floatingInfoBox(chartData: rotationYData)
                .id(rotationYData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 600)
            Text("Rotation Y")
                .padding()
            
            let rotationZData = LineChartData(dataSets: bno08x.getRotationZ(), chartStyle: ChartStyle().getChartStyle())
            
            //rotation z
            LineChart(chartData: rotationZData)
                .filledTopLine(chartData: rotationZData,
                               lineColour: ColourStyle(colour: .blue),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rotationZData, specifier: "%.2f")
                .xAxisGrid(chartData: rotationZData)
                .yAxisGrid(chartData: rotationZData)
                .xAxisLabels(chartData: rotationZData)
                .yAxisLabels(chartData: rotationZData, specifier: "%.2f")
                .floatingInfoBox(chartData: rotationZData)
                .id(rotationZData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 600)
            Text("Rotation Z")
                .padding()
            
            let rotationRealData = LineChartData(dataSets: bno08x.getRotationReal(), chartStyle: ChartStyle().getChartStyle())
            
            //rotation real
            LineChart(chartData: rotationRealData)
                .filledTopLine(chartData: rotationRealData,
                               lineColour: ColourStyle(colour: .purple),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rotationRealData, specifier: "%.2f")
                .xAxisGrid(chartData: rotationRealData)
                .yAxisGrid(chartData: rotationRealData)
                .xAxisLabels(chartData: rotationRealData)
                .yAxisLabels(chartData: rotationRealData, specifier: "%.2f")
                .floatingInfoBox(chartData: rotationRealData)
                .id(rotationRealData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 600)
            Text("Rotation Real")
                .padding()
            
            let rotationAccuracyData = LineChartData(dataSets: bno08x.getRotationAccuracy(), chartStyle: ChartStyle().getChartStyle())
            
            //rotation accuracy
            LineChart(chartData: rotationAccuracyData)
                .filledTopLine(chartData: rotationAccuracyData,
                               lineColour: ColourStyle(colour: .yellow),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: rotationAccuracyData, specifier: "%.2f")
                .xAxisGrid(chartData: rotationAccuracyData)
                .yAxisGrid(chartData: rotationAccuracyData)
                .xAxisLabels(chartData: rotationAccuracyData)
                .yAxisLabels(chartData: rotationAccuracyData, specifier: "%.2f")
                .floatingInfoBox(chartData: rotationAccuracyData)
                .id(rotationAccuracyData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 600)
            Text("Rotation Accuracy")
                .padding()
        }
    }
}

struct BNO08XView_Previews: PreviewProvider {
    static var previews: some View {
        BNO08XView()
    }
}
