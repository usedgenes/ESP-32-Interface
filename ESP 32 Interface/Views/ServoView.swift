//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI
import Foundation
import CoreMotion

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
    @State var servoPositionSlider : Double = 90
    @State var tiltViewOn = false
    @State var motionManager : CMMotionManager?
    let motionType = ["Roll", "Pitch", "Yaw"]
    @State var selectedMotion = "Roll"
    init(servo: Servo) {
        servoPositionSlider = Double(servo.servoPosition)
        self.servo = servo
    }
    
    var body : some View {
        Section() {
            Text("\(servo.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            LazyVGrid(columns: items) {
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
                            servoPositionSlider = Double(servo.servoPosition)
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
                bluetoothDevice.setServos(input: "2" + String(format: "%02d", ESP_32.getServos().getDeviceNumberInArray(inputDevice: servo)) + String(Int(servoPositionSlider)))
            }), in: 0...180, step: 1)
            HStack {
                Text("Phone Tilt Control:")
                Button(action: {
                    tiltViewOn.toggle()
                    if(tiltViewOn) {
                        motionManager = CMMotionManager()
                        motionManager!.deviceMotionUpdateInterval = 0.25
                        motionManager!.startDeviceMotionUpdates(to: .main) {
                            (motion, error) in
                            var servoPosition = 90
                            if(selectedMotion == "Roll") {
                                servoPosition = mapRadiantoServo(value: (motion?.attitude.roll)!)
                                
                            } else if(selectedMotion == "Pitch") {
                                servoPosition = mapRadiantoServo(value: (motion?.attitude.pitch)!)
                                
                            }
                            if(selectedMotion == "Yaw") {
                                servoPosition = mapRadiantoServo(value: (motion?.attitude.yaw)!)
                                
                            }
                            servo.servoPosition = servoPosition
                            servoPositionSlider = Double(servoPosition)
                            bluetoothDevice.setServos(input: "2" + String(format: "%02d", ESP_32.getServos().getDeviceNumberInArray(inputDevice: servo)) + String(servo.servoPosition))
                        }
                    }
                    else {
                        motionManager!.stopDeviceMotionUpdates()
                    }
                }) {
                    Image(systemName: tiltViewOn ? "pause.fill" : "play.fill")
                }.buttonStyle(.plain)
                Spacer()
                Picker("Motion Type", selection: $selectedMotion) {
                    ForEach(motionType, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.menu)
            }.padding(.bottom, 30)
        }.hideKeyboardWhenTappedAround()
            .onDisappear(perform: { motionManager?.stopDeviceMotionUpdates()
            })
    }
}

func mapRadiantoServo(value: Double) -> Int {
    return Int(180 * (value + Double.pi) / (2*Double.pi))
}

struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
