//
//  Servo.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct Servo: View {
    @State private var servoPosition = 0

    var body: some View {
        VStack {
            TextField("Servo Position", value: $servoPosition, format: .number)
                .textFieldStyle(.roundedBorder)
                .padding()

        }
    }
}

struct Servo_Previews: PreviewProvider {
    static var previews: some View {
        Servo()
    }
}
