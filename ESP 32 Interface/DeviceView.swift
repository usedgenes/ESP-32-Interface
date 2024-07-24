//
//  DeviceView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct DeviceView: View {
    struct Device: Hashable, Identifiable {
            let name: String
            let id = UUID()
        }
    
    struct DeviceList: Identifiable {
            let name: String
            let devices: [Device]
            let id = UUID()
        }

        private let ESP32devices: [DeviceList] = [
            DeviceList(name: "Motion",
                        devices: [Device(name: "Motor"),
                               Device(name: "Servo")]),
            DeviceList(name: "Altimeter",
                        devices: [Device(name: "BMP388")]),
            DeviceList(name: "IMU",
                        devices: [Device(name: "BNO08x")]),
        ]
    @State private var singleSelection: UUID?
    var body: some View {
        List(selection: $singleSelection) {
                        ForEach(ESP32devices) { deviceList in
                            Section(header: Text("IMU: \(deviceList.name)")) {
                                ForEach(deviceList.devices) { devices in
                                    Text(devices.name)
                                }
                            }
                        }
                    }
                    .navigationTitle("Device List")
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
