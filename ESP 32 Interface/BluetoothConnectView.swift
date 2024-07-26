//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    var bluetoothHelper = BluetoothHelper()
    @State var selectedIndex: Int?
    @State var refresh: Bool = false

    func update() {
       refresh.toggle()
    }
    
    var body: some View {
        
        let _ = bluetoothHelper.viewLoaded()
        var bluetoothManager = bluetoothHelper.manager
        var bluetoothDevices = bluetoothHelper.devices
        
        VStack {
            Button("Refresh") {
                update()
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
                        selectedIndex = index
                    }
                }
            }
            
            selectedIndex.map {
                Text("\($0)")
                    .font(.largeTitle)
            }
            
        }
    }
}

struct BluetoothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectView()
    }
}
