//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct ServoView: View {
    @State private var servoPosition = 0
    @ObservedObject var ESP_32 : ESP32
    
    var body: some View {
        VStack {
            List {
                ForEach(ESP_32.getServos().devices, id: \.self) { servo in
                    HStack {
                        Text("\(servo.name)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    
                }
            }

        }
    }
}

struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView(ESP_32 : ESP32())
    }
}
