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
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"CS"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"SCK"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"MISO"))
                            bno08xPinString += String(format: "%02d", bno08x.getPinNumber(name:"MOSI"))
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
    var body : some View {
        Section() {
            HStack {
                Text("\(bno08x.name)")
                Spacer()
                ForEach(bno08x.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                }
            }
            .contentShape(Rectangle())
            HStack {
                NavigationLink("View Data", destination: BNO08XChartView(bno08x: bno08x))
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
    @State var delayTime = 500
    var body : some View {
        VStack {
            HStack {
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
                    .padding()
                
                Button(action: {
                    timer?.invalidate()
                    timer = nil
                    timerOn.toggle()
                }) {
                    Text("Stop")
                }.disabled(!timerOn)
                    .padding()
            }
            HStack {
                Text("Delay (ms):")
                    .padding()
                //                TextField("\(delayTime)", text: Binding<String>(
                //                    get: { String(delayTime) },
                //                    set: {
                //                        if let value = NumberFormatter().number(from: $0) {
                //                            self.delayTime = value.intValue
                //
                //                        }
                //                    }))
                //                    .keyboardType(UIKeyboardType.numberPad)
                //                    .disabled(timerOn)
                Spacer()
                Button(action: {
                    timer?.invalidate()
                    timer = nil
                    timerOn.toggle()
                    bno08x.resetData()
                }) {
                    Text("Reset Altimeter Data")
                }.padding()
            }
        }
    }
}

struct BNO08XView_Previews: PreviewProvider {
    static var previews: some View {
        BNO08XView()
    }
}
