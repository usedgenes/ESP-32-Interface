import SwiftUI

struct BMP390_I2CView: View {
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBMP390_I2C().devices.isEmpty) {
                Text("No BMP390s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBMP390_I2C().devices, id: \.self) { bmp390 in
                        individualBMP390_I2CView(ESP_32: ESP_32, bmp390: bmp390, bluetoothDevice: bluetoothDevice)
                    }
                }
            }
        }
    }
}

struct individualBMP390_I2CView : View {
    @ObservedObject var ESP_32 : ESP32
    @ObservedObject var bmp390 : Device
    @ObservedObject var bluetoothDevice : BluetoothDeviceHelper
    var body : some View {
        Section() {
            HStack {
                Text("\(bmp390.name)")
                Spacer()
                ForEach(bmp390.attachedPins) { pin in
                    Text("\(pin.pinName): \(pin.pinNumber)")
                }
            }
            .contentShape(Rectangle())
            HStack {
            }
        }
    }
}

struct BMP390_I2CView_Previews: PreviewProvider {
    static var previews: some View {
        
        BMP390_I2CView(ESP_32 : ESP32(bmp390 : BMP390_I2CType(type: "Altimeter", pinTypes: ["SCK", "SDA"])), bluetoothDevice: BluetoothDeviceHelper())
        
    }
}
