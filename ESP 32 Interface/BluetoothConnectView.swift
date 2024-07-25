//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    var body: some View {
        VStack {
        

        }
    }
    
    private var manager = BTManager()
    private var devices: [BTDevice] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    @IBOutlet var scanLabel: UILabel!
}

struct BluetoothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectView()
    }
}
