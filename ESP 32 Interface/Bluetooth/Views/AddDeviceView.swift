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

    var body: some View {
        List(selection: $singleSelection) {
            ForEach(ESP32Devices) { deviceCategory in
                            Section(header: Text("\(deviceCategory.category)")) {
                                ForEach(deviceCategory.devices, id: \.self) { device in
                                    HStack {
                                        Text("\(device.name)")
                                        Spacer()
                                        Button("Add") {
                                            ESP_32.addDevice(device: device)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    
//                                    ForEach(ESP_32.de)
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
