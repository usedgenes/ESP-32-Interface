//import SwiftUI
//
//struct BNO08XView: View {
//    @EnvironmentObject var ESP_32 : ESP32
//    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
//    var body: some View {
//        VStack {
//            if(ESP_32.getBNO08X_SPI().devices.isEmpty) {
//                Text("No BMP390s Attached")
//            }
//            else {
//                List {
//                    ForEach(ESP_32.getBNO08X_SPI().devices, id: \.self) { bmp390 in
//                        individualBNO08XView(bno08x: bmp390)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct individualBNO08XView : View {
//    @EnvironmentObject var ESP_32 : ESP32
//    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
//    @ObservedObject var bno08x : Device
//
//    var body : some View {
//        Section() {
//            HStack {
//                Text("\(bno08x.name)")
//                Spacer()
//                ForEach(bno08x.attachedPins) { pin in
//                    Text("\(pin.pinName): \(pin.pinNumber)")
//                }
//            }
//            .contentShape(Rectangle())
//            HStack {
//            }
//        }
//    }
//}
//
//struct BNO08XView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        BNO08XView()
//
//    }
//}
