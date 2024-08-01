//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ServoView: View {
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getServos().devices.isEmpty) {
                Text("No Servos Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getServos().devices, id: \.self) { servo in
                        individualServoView(ESP_32: ESP_32, servo: servo, bluetoothDevice: bluetoothDevice)
                    }
                }
            }
        }
    }
}

struct individualServoView : View {
    @ObservedObject var ESP_32: ESP32
    @ObservedObject var servo : Device
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body : some View {
        Section() {
            HStack {
                Text("\(servo.name)")
                Spacer()
                Text("\(servo.attachedPins[0].pinName): \(servo.attachedPins[0].pinNumber)")
            }
            .contentShape(Rectangle())
            HStack {
                Text("Servo Position: ")
                TextField("\(servo.servoPosition)", value: $servo.servoPosition, formatter: NumberFormatter())
                Button(action: {
                    ESP_32.servos.sendData(device: servo, bluetoothDevice: bluetoothDevice)}) {
                        Text("Send")
                    }
            }
        }
    }
}
struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        
        ServoView(ESP_32 : ESP32(servo: ServoType(type: "Servo", pinTypes: ["Digital"])), bluetoothDevice: BluetoothDeviceHelper())
        
    }
}
