import SwiftUI

struct BNO08X_SPIView: View {
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBNO08X_SPI().devices.isEmpty) {
                Text("No BMP390s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBNO08X_SPI().devices, id: \.self) { bmp390 in
                        individualBNO08X_SPIView(ESP_32: ESP_32, bno08x: bmp390, bluetoothDevice: bluetoothDevice)
                    }
                }
            }
        }
    }
}

struct individualBNO08X_SPIView : View {
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bno08x : Device
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body : some View {
        Section() {
            HStack {
                Text("\(bno08x.name)")
                Spacer()
                ForEach(bno08x.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                }
            }
            .contentShape(Rectangle())
            HStack {
            }
        }
    }
}

struct BNO08X_I2CView_Previews: PreviewProvider {
    static var previews: some View {
        
        BNO08X_SPIView(ESP_32 : ESP32(bno08x : BNO08X_SPIType(type: "Altimeter", pinTypes: ["SCK", "SDA"])), bluetoothDevice: BluetoothDeviceHelper())
        
    }
}
