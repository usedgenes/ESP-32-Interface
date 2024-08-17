import SwiftUI
import SwiftUICharts

struct BMP390View: View {
    
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBMP390s().devices.isEmpty) {
                Text("No BMP390s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBMP390s().devices, id: \.self) { bmp390 in
                        let _ = print(bmp390)
                        individualBMP390View(bmp390: bmp390 as! BMP390)
                    }
                }
                .onAppear(perform: {
                    bluetoothDevice.setBMP390(input: "0" + String(ESP_32.getBMP390s().devices.count))
                    for bmp390 in ESP_32.getBMP390s().devices {
                        var bmp390PinString = "1"
                        bmp390PinString += String(format: "%02d", ESP_32.getBMP390s().getDeviceNumberInArray(inputDevice: bmp390))
                        if(bmp390.attachedPins.count == 2) {
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SDA"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SCL"))
                        }
                        else {
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"CS"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SCK"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"MISO"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"MOSI"))
                        }
                        
                        bluetoothDevice.setBMP390(input: bmp390PinString)
                        print(bmp390PinString)
                    }
                })
            }
        }
    }
}

struct individualBMP390View : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var bmp390 : BMP390
    let items = [GridItem(), GridItem(), GridItem(), GridItem()]
    var body : some View {
        Section() {
            Text("\(bmp390.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                ForEach(bmp390.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                }
            }
            .contentShape(Rectangle())
            HStack {
                NavigationLink("View Data", destination: BMP390ChartView(bmp390: bmp390))
            }.padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct BMP390ChartView : View {
    @ObservedObject var bmp390 : BMP390
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var ESP_32 : ESP32
    @State var timerOn = false
    @State var timer : Timer?
    @State var delayTime = 1000
    var body : some View {
        List {
            Text("\(bmp390.name) Data Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Text("Delay: 1 second")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    if(timer == nil) {
                        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime/1000), repeats: true, block: { _ in
                            bluetoothDevice.setBMP390(input: "2" + String(format: "%02d", ESP_32.getBMP390s().getDeviceNumberInArray(inputDevice: bmp390)))
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
                        print("invalidating")
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
                    bmp390.resetTemperature()
                }) {
                    Text("Temperature")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bmp390.resetPressure()
                }) {
                    Text("Pressure")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bmp390.resetAltitude()
                }) {
                    Text("Altitude")
                }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bmp390.resetAll()
                }) {
                    Text("All")
                }.buttonStyle(BorderlessButtonStyle())
                
            }.frame(maxWidth: .infinity, alignment: .center)
            
        }.onDisappear(perform: {
            timer?.invalidate()
            timer = nil
            timerOn.toggle()})
        .offset(y:15)
        Spacer()
        
        Text("Temperature")
        ChartStyle().getGraph(datasets: bmp390.getTemperatureDataSet(), colour: .red)

        Text("Pressure")
        ChartStyle().getGraph(datasets: bmp390.getPressureDataSet(), colour: .green)
        
        Text("Altitude")
        ChartStyle().getGraph(datasets: bmp390.getAltitudeDataSet(), colour: .green)
    }
}

struct BMP390View_Previews: PreviewProvider {
    static var previews: some View {
        BMP390View()
    }
}
