//
//  DeviceView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct AddDeviceView: View {
    @State private var singleSelection: UUID?
    @ObservedObject var ESP_32 : ESP32
    var devices = DeviceType()

    var body: some View {
        List(selection: $singleSelection) {
            ForEach(devices.ESP32Devices) { deviceList in
                            Section(header: Text("\(deviceList.name)")) {
                                ForEach(deviceList.devices) { device in
                                    HStack {
                                        Text("\(device.name)")
                                        Spacer()
                                        Button("Add") {
                                            ESP_32.addDevice(device)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                }
                            }
                        }
                    }
                    .navigationTitle("Device List")
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView(ESP_32 : ESP32())
    }
}
