import SwiftUI

struct BMP390_SPIView: View {
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBMP390_SPI().devices.isEmpty) {
                Text("No BMP390s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBMP390_SPI().devices, id: \.self) { bmp390 in
                        individualBMP390_SPIView(bmp390: bmp390)
                    }
                }.onAppear(perform: {
                    bluetoothDevice.setBMP390SPI(input: "0" + String(ESP_32.getBMP390_SPI().devices.count))
                    for bmp390SPI in ESP_32.getBMP390_SPI().devices {
                        var bmp390PinString = "1"
                        bmp390PinString += String(format: "%02d", ESP_32.getBMP390_SPI().getDeviceNumberInArray(inputDevice: bmp390SPI))
                        bmp390PinString += String(format: "%02d", bmp390SPI.getPinNumber(name:"CS"))
                        bmp390PinString += String(format: "%02d", bmp390SPI.getPinNumber(name:"SCK"))
                        bmp390PinString += String(format: "%02d", bmp390SPI.getPinNumber(name:"MISO"))
                        bmp390PinString += String(format: "%02d", bmp390SPI.getPinNumber(name:"MOSI"))
                        bluetoothDevice.setBMP390SPI(input: bmp390PinString)
                        print(bmp390PinString)
                    }
                })
            }
        }
    }
}

struct individualBMP390_SPIView : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var bmp390 : Device
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
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

struct BMP390_SPIView_Previews: PreviewProvider {
    static var previews: some View {
        
        BMP390_I2CView()
        
    }
}
