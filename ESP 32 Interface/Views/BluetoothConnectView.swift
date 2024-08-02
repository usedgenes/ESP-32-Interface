//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State private var showBluetoothAlert: Bool = false
    @State var bluetoothManagerHelper = BluetoothManagerHelper()
    
    var body: some View {
        
        VStack {
            Text("Bluetooth")
            Button("Refresh") {
                bluetoothDevice.refresh()
            }
            .padding(.top)
            
            Button("Disconnect") {
                if(bluetoothDevice.isConnected) {
                    bluetoothDevice.disconnect()
                }
                else {
                    showBluetoothAlert = true
                    
                }
            }
            .padding()
            
            HStack{
                Button("LED Blink Test") {
                    if(bluetoothDevice.isConnected) {
                        bluetoothDevice.blinkChanged()
                    }
                    else {
                        showBluetoothAlert = true
                        
                    }
                }
                Text(bluetoothDevice.blinkState() ? "On" : "Off")
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
                Text(bluetoothDevice.isConnected ? "Connected" : "Not connected")
            }
            .cornerRadius(8)
            .padding()
        }
        List {
            ForEach(bluetoothManagerHelper.devices, id: \.self) { device in
                HStack {
                    Text("\(device.name)")
                        .onTapGesture {
                            bluetoothManagerHelper.connectDevice(BTDevice: device)
                            bluetoothDevice.device = device
                            bluetoothDevice.connect()
                        }
                    Spacer()
                }
                .contentShape(Rectangle())
                
            }
        }
        
    }
}


struct BluetoothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectView()
    }
}
