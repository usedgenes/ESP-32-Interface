import SwiftUI

struct DigitalAnalogPinView: View {
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getPins().devices.isEmpty) {
                Text("No Pins Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getPins().devices, id: \.self) { pin in
                        individualPinView(pin: pin)
                    }
                }.onAppear(perform: {
                    bluetoothDevice.setPin(input: "0" + String(ESP_32.getPins().devices.count))
                    print("setting")
                    for pin in ESP_32.getPins().devices {
                        bluetoothDevice.setPin(input: "1" + String(format: "%02d", ESP_32.getPins().getDeviceNumberInArray(inputDevice: pin)) + String(pin.getPinNumber(name:"Pin")))
                    }
                })
            }
        }
    }
}

struct individualPinView : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var pin : Device
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    let items = [GridItem()]
    @State var analog = 0
    var body : some View {
        Section() {
            Text("\(pin.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                Spacer()
                Text("\(pin.attachedPins[0].pinName): \(pin.attachedPins[0].pinNumber)")
            }
            .contentShape(Rectangle())
            HStack {
                Text("Digital: ")
                
                Button(action: {
                    bluetoothDevice.setPin(input: "2" + String(format: "%02d", ESP_32.getPins().getDeviceNumberInArray(inputDevice: pin)) + "1")
                    print("high")
                    }) {
                        Text("HIGH")
                    }.buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    bluetoothDevice.setPin(input: "2" + String(format: "%02d", ESP_32.getPins().getDeviceNumberInArray(inputDevice: pin)) + "0")
                    print("low")
                    }) {
                        Text("LOW")
                    }.buttonStyle(BorderlessButtonStyle())
            }
            HStack {
                Text("Analog: ")
                TextField("\(analog)", text: Binding<String>(
                    get: { String(analog) },
                    set: {
                        if let value = NumberFormatter().number(from: $0) {
                            analog = value.intValue

                        }
                    }))
                    .keyboardType(UIKeyboardType.numberPad)
                Button(action: {
                    bluetoothDevice.setPin(input: "3" + String(format: "%02d", ESP_32.getPins().getDeviceNumberInArray(inputDevice: pin)) + String(analog))
                    }) {
                        Text("Send")
                    }.buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct DigitalAnalogPinView_Previews: PreviewProvider {
    static var previews: some View {
        DigitalAnalogPinView()
    }
}
