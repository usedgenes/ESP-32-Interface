import SwiftUI

struct BuzzerView: View {
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBuzzers().devices.isEmpty) {
                Text("No Pins Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBuzzers().devices, id: \.self) { buzzer in
                        individualBuzzerView(buzzer: buzzer)
                    }
                }
            }
        }
    }
}

struct individualBuzzerView : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var buzzer : Device
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    let items = [GridItem()]
    @State var frequency = 440
    @State var sliderFrequency : Double = 440
    @State var duration: String = "0.5"
    @State var playBuzzer = false
    var body : some View {
        Section() {
            Text("\(buzzer.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                Spacer()
                Text("\(buzzer.attachedPins[0].pinName): \(buzzer.attachedPins[0].pinNumber)")
            }
            .contentShape(Rectangle())
            HStack {
                Text("Frequency (hz): ")
                TextField("\(frequency)", text: Binding<String>(
                    get: { String(frequency) },
                    set: {
                        if let value = NumberFormatter().number(from: $0) {
                            frequency = value.intValue
                            sliderFrequency = Double(frequency)
                        }
                    }))
                .keyboardType(UIKeyboardType.numberPad)
                .hideKeyboardWhenTappedAround()
            }
            HStack {
                Text("Duration (s): ")
                TextField("\(duration)", text: Binding<String>(
                    get: { String(duration) },
                    set: {
                        duration = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                .hideKeyboardWhenTappedAround()
                Spacer()
                    .hideKeyboardWhenTappedAround()
                Button(action: {
                    bluetoothDevice.setBuzzer(input: "2" + String(frequency))
                    bluetoothDevice.setBuzzer(input: "3" + String(format: "%02d",  buzzer.getPinNumber(name: "Buzzer Pin")) + String((Float(duration) ?? 0)*1000))
                }) {
                    Text("Send")
                }.buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal)
            }
            
            HStack {
                Slider(value: Binding(get: {
                    sliderFrequency
                }, set: { (newVal) in
                    sliderFrequency = newVal
                    frequency = Int(sliderFrequency)
                    if(playBuzzer) {
                        bluetoothDevice.setBuzzer(input: "0" + String(format: "%02d",  buzzer.getPinNumber(name: "Buzzer Pin")) + String(frequency))
                    }
                }), in: 0...5000, step: 1)
                .padding(.horizontal)
                
                Button(action: {
                    playBuzzer.toggle()
                    if(playBuzzer) {
                        bluetoothDevice.setBuzzer(input: "0" + String(format: "%02d",  buzzer.getPinNumber(name: "Buzzer Pin")) + String(frequency))
                    }
                    else {
                        bluetoothDevice.setBuzzer(input: "1" + String(format: "%02d", buzzer.getPinNumber(name: "Buzzer Pin")))
                    }
                }) {
                    Image(systemName: self.playBuzzer == true ? "pause.fill" : "play.fill")
                }.padding(.horizontal)
            }
        }
    }
}

struct BuzzerView_Previews: PreviewProvider {
    static var previews: some View {
        BuzzerView()
    }
}
