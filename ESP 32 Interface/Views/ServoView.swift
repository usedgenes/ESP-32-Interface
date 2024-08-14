//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI
import Foundation

struct ServoView: View {
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getServos().devices.isEmpty) {
                Text("No Servos Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getServos().devices, id: \.self) { servo in
                        individualServoView(servo: servo as! Servo)
                    }
                }.onAppear(perform: {
                    bluetoothDevice.setServos(input: "0" + String(ESP_32.getServos().devices.count))
                    var servoDigitalPins = ""
                    for servo in ESP_32.getServos().devices {
                        servoDigitalPins += String(format: "%02d", servo.getPinNumber(name: "Digital"))
                    }
                    bluetoothDevice.setServos(input: "1" + String(servoDigitalPins))
                })
            }
        }
    }
}

struct individualServoView : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var servo : Servo
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    let items = [GridItem()]
    @State var servoPositionSlider : Double = 0
    var body : some View {
        Section() {
            Text("\(servo.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
                Spacer()
                Text("\(servo.attachedPins[0].pinName): \(servo.attachedPins[0].pinNumber)")
            }
            .contentShape(Rectangle())
            HStack {
                Text("Servo Position: ")
                TextField("\(servo.servoPosition)", text: Binding<String>(
                    get: { String(servo.servoPosition) },
                    set: {
                        if let value = NumberFormatter().number(from: $0) {
                            servo.servoPosition = value.intValue
                        }
                    }))
                .keyboardType(UIKeyboardType.numberPad)
                Button(action: {
                    bluetoothDevice.setServos(input: "2" + String(format: "%02d", ESP_32.getServos().getDeviceNumberInArray(inputDevice: servo)) + String(servo.servoPosition))
                }) {
                    Text("Send")
                }.buttonStyle(BorderlessButtonStyle())
            }.padding()
            Slider(value: Binding(get: {
                servoPositionSlider
            }, set: { (newVal) in
                servoPositionSlider = newVal
                servo.servoPosition = Int(newVal)
                bluetoothDevice.setServos(input: "2" + String(format: "%02d", ESP_32.getServos().getDeviceNumberInArray(inputDevice: servo)) + String(servoPositionSlider))
            }), in: 0...180, step: 1)
            .padding(.bottom)
        }.hideKeyboardWhenTappedAround()
    }
}

struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
