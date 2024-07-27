//
//  DeviceView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct AddDeviceView: View {
    @State private var singleSelection: UUID?
    var devices = DeviceType()

    var body: some View {
        List(selection: $singleSelection) {
            ForEach(devices.ESP32Devices) { deviceList in
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
        AddDeviceView()
    }
}
