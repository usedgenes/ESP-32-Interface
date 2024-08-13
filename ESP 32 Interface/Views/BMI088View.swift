import SwiftUI
import SwiftUICharts

struct BMI088View: View {
    
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBMI088s().devices.isEmpty) {
                Text("No BMI088s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBMI088s().devices, id: \.self) { bmi088 in
                        individualBMI088View(bmi088: bmi088 as! BMI088)
                    }
                }
                .onAppear(perform: {
                    bluetoothDevice.setBMI088(input: "0" + String(ESP_32.getBMI088s().devices.count))
                    for bmi088 in ESP_32.getBMI088s().devices {
                        var bmi088PinString = "1"
                        bmi088PinString += String(format: "%02d", ESP_32.getBMI088s().getDeviceNumberInArray(inputDevice: bmi088))
                        if(bmi088.attachedPins.count == 2) {
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"SDA"))
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"SCL"))
                        }
                        else {
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"SCK"))
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"MISO"))
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"MOSI"))
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"Accel CS"))
                            bmi088PinString += String(format: "%02d", bmi088.getPinNumber(name:"Gyro CS"))
                        }
                        
                        bluetoothDevice.setBMI088(input: bmi088PinString)
                        print(bmi088PinString)
                    }
                })
            }
        }
    }
}

struct individualBMI088View : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var bmi088 : BMI088
    let items = [GridItem(), GridItem(), GridItem()]
    var body : some View {
        Section() {
            Text("\(bmi088.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                ForEach(bmi088.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                }
            }
            .contentShape(Rectangle())
            HStack {
                NavigationLink("View Data", destination: BMI088ChartView(bmi088: bmi088))
                    .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BMI088ChartView : View {
    @ObservedObject var bmi088 : BMI088
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var ESP_32 : ESP32
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    var body : some View {
        List {
            Text("\(bmi088.name) Data Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Text("Delay: 1 second")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    if(timer == nil) {
                        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                            bluetoothDevice.setBMI088(input: "2" + String(format: "%02d", ESP_32.getBMI088s().getDeviceNumberInArray(inputDevice: bmi088)))
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
                    bmi088.resetGyro()
                }) {
                    Text("Gyro")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bmi088.resetAccelerometer()
                }) {
                    Text("Accelerometer")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bmi088.resetAll()
                }) {
                    Text("All")
                }.buttonStyle(BorderlessButtonStyle())

            }.frame(maxWidth: .infinity, alignment: .center)
            GroupBox {
                NavigationLink("Gyro Data", destination: BMI088GyroView(bmi088: bmi088))
                    .frame(maxWidth: .infinity, alignment: .center)

            }
            GroupBox {
                NavigationLink("Accelerometer Data", destination: BMI088AccelerationView(bmi088: bmi088))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BMI088AccelerationView: View {
    @ObservedObject var bmi088: BMI088
    var body: some View {
        VStack {
            let accelerationXData = LineChartData(dataSets: bmi088.getAccelerometerX(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer x
            Text("Accelerometer X")
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
            
            let accelerationYData = LineChartData(dataSets: bmi088.getAccelerometerY(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer y
            Text("Accelerometer Y")
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
            
            let accelerationZData = LineChartData(dataSets: bmi088.getAccelerometerZ(), chartStyle: ChartStyle().getChartStyle())
            
            //accelerometer z
            Text("Accelerometer Z")
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
        }
    }
}

struct BMI088GyroView: View {
    @ObservedObject var bmi088: BMI088
    var body: some View {
        VStack {
            let gyroXData = LineChartData(dataSets: bmi088.getGyroX(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro x
            Text("Gyro X")
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
            
            let gyroYData = LineChartData(dataSets: bmi088.getGyroY(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro y
            Text("Gyro Y")
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
            
            let gyroZData = LineChartData(dataSets: bmi088.getGyroZ(), chartStyle: ChartStyle().getChartStyle())
            
            //gyro z
            Text("Gyro Z")
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
        }
    }
}

struct BMI088View_Previews: PreviewProvider {
    static var previews: some View {
        BMI088View()
    }
}
