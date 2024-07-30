//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ServoView: View {
    @State private var servoPosition : [Int]
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var count = 0;
    init(ESP_32 : ESP32) {
        servoPosition = Array(repeating: 0, count: ESP_32.servos.devices.count)
        self.ESP_32 = ESP_32
        bluetoothDevice = BluetoothDeviceHelper()
    }
    var body: some View {
        VStack {
            if(ESP_32.getServos().devices.isEmpty) {
                Text("No Servos Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getServos().devices, id: \.self) { servo in
                        Section() {
                            HStack {
                                Text("\(servo.name)")
                                Spacer()
                                Text("\(servo.attachedPins[0].pinName): \(servo.attachedPins[0].pinNumber)")
                            }
                            .contentShape(Rectangle())
                            HStack {
                                Text("Servo Position: ")
                                TextField("\(servo.servoPosition)", value: $servoPosition[count], formatter: NumberFormatter())
                                Button(action: {
                                    servo.servoPosition = servoPosition[count]
                                    ESP_32.servos.sendData(device: servo, bluetoothDevice: bluetoothDevice)}) {
                                        Text("Send")
                                    }
                            }
                        }
                        self.count += 1
                    }
                }
            }
        }
    }
}

struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        
        ServoView(ESP_32 : ESP32(servo: ServoType(type: "Servo", pinTypes: ["Digital"])))
        
    }
}
