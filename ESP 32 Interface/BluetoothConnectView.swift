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
    @State private var connectedState: Bool = false
    @State private var deviceName: String = "null"
    var bluetoothManagerHelper = BluetoothManagerHelper()
    
    var body: some View {
        var bluetoothDevices = bluetoothManagerHelper.devices

        VStack {
            Button("Refresh") {
            }
            
            VStack(spacing:-20) {
                HStack{
                    Text("Device Name")
                    Spacer()
                    Text(String(deviceName))
                }
                .cornerRadius(8)
                .padding()
                
                HStack{
                    Text("Device State")
                    Spacer()
                    Text(String(connectedState))
                }
                .cornerRadius(8)
                .padding()
            }
            List {
                ForEach(0..<bluetoothDevices.count, id: \.self) { index in
                    HStack {
                        Text("\(bluetoothDevices[index].name)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        bluetoothManagerHelper.connectDevice(deviceNumber: index)
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
