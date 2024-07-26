//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    @State private var selection: String?
    @State var count: Int = 1
    
    var bluetoothHelper = BluetoothHelper()
    
    var body: some View {
        var bluetoothManager = bluetoothHelper.manager
        var bluetoothDevices = bluetoothHelper.devices

        VStack {
            Button("Refresh") {
                count += 1
            }
            Button(String(count)) {
                
            }
            List {
                ForEach(0..<bluetoothDevices.count, id: \.self) { index in
                    HStack {
                        Text("\(bluetoothDevices[index].name)")
                        Spacer()
                    }
                    //Entirely Clickable
                    .contentShape(Rectangle())
                    .onTapGesture {
                        bluetoothHelper.connectDevice(deviceNumber: index)
                        count += 1
                    }
                }
            }
            
        }
    }
}

struct BluetoothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectView()
    }
}
