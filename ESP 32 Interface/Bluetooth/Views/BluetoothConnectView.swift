//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    @ObservedObject var bluetoothDevice = BluetoothDeviceHelper()
    @State private var refresh: Bool = false
    @State private var showBluetoothAlert: Bool = false
    
    var bluetoothManagerHelper = BluetoothManagerHelper()
    
    var body: some View {
        var bluetoothDevices = bluetoothManagerHelper.devices
        
        VStack {
            Text("Bluetooth")
            
            HStack {
                Button("Refresh") {
                    refresh.toggle()
                    bluetoothDevice.blinkChanged()
                    print(String(bluetoothDevice.isConnected))
                }
                Spacer()
                Button("Disconnect") {
                    if(bluetoothDevice.isConnected) {
                        bluetoothDevice.disconnect()
                    }
                    else {
                            showBluetoothAlert = true
                        
                    }
                }
                .alert(isPresented: $showBluetoothAlert) {
                        Alert(
                            title: Text("No Bluetooth Device Connected"),
                            message: Text("Please select a device to connect to")
                        )
                    }
            }
            .cornerRadius(8)
            .padding()
            
            VStack(spacing:-20) {
                HStack{
                    Text("Device Name")
                    Spacer()
                    Text(String(bluetoothDevice.deviceName))
                }
                .cornerRadius(8)
                .padding()
                
                HStack{
                    Text("Device State")
                    Spacer()
                    Text(String(bluetoothDevice.isConnected))
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
                        bluetoothDevice.device = bluetoothDevices[index]
                        bluetoothDevice.connect()
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
