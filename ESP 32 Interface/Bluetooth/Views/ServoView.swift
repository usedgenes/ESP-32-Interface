//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ServoView: View {
    @State private var servoPosition : Int?
    @ObservedObject var ESP_32 : ESP32
    
    var body: some View {
        VStack {
            if(ESP_32.getServos().devices.isEmpty) {
                Text("No Servos Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getServos().devices, id: \.self) { servo in
                        HStack {
                            Text("\(servo.name)")
                            Spacer()
                            Text("\(servo.attachedPins[0].pinName): \(servo.attachedPins[0].pinNumber)")
                        }
                        .contentShape(Rectangle())
                        TextField("Placeholder", value: $servoPosition, formatter: NumberFormatter())
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
