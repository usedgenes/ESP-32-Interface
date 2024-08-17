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
            Text("Accelerometer X")
            ChartStyle().getGraph(datasets: bmi088.getAccelerometerX(), colour:.red)
            
            Text("Accelerometer Y")
            ChartStyle().getGraph(datasets: bmi088.getAccelerometerY(), colour: .green)
            
            Text("Accelerometer Z")
            ChartStyle().getGraph(datasets: bmi088.getAccelerometerZ(), colour: .blue)
        }
    }
}

struct BMI088GyroView: View {
    @ObservedObject var bmi088: BMI088
    var body: some View {
        VStack {
            Text("Gyro X")
            ChartStyle().getGraph(datasets: bmi088.getGyroX(), colour: .red)

            Text("Gyro Y")
            ChartStyle().getGraph(datasets: bmi088.getGyroY(), colour: .green)
            
            Text("Gyro Z")
            ChartStyle().getGraph(datasets: bmi088.getGyroZ(), colour: .blue)
        }
    }
}

struct BMI088View_Previews: PreviewProvider {
    static var previews: some View {
        BMI088View()
    }
}
