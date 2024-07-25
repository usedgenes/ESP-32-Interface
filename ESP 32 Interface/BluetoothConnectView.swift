//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    var bluetoothManager = BTManager()
    var devices: [BTDevice]
    @State  var selectedIndex: Int?
    
    var body: some View {
        VStack {
            List {
                ForEach(1...10, id: \.self) { index in
                    HStack {
                        Text("\(index)")
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
