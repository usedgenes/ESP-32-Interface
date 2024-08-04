import SwiftUI
import Charts

struct BMP390View: View {
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
                        individualBMP390_SPIView(bmp390: bmp390 as! BMP390)
                    }
                    ForEach(ESP_32.getBMP390_I2C().devices, id:\.self) {
                        bmp390 in
                        individualBMP390_SPIView(bmp390: bmp390 as! BMP390)
                    }
                }.onAppear(perform: {
                    bluetoothDevice.setBMP390SPI(input: "0" + String((ESP_32.getBMP390_SPI().devices.count + ESP_32.getBMP390_I2C().devices.count)))
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
                    for bmp390I2C in ESP_32.getBMP390_SPI().devices {
                        var bmp390PinString = "1"
                        bmp390PinString += String(format: "%02d", ESP_32.getBMP390_I2C().getDeviceNumberInArray(inputDevice: bmp390I2C))
                        bmp390PinString += String(format: "%02d", bmp390I2C.getPinNumber(name:"SCK"))
                        bmp390PinString += String(format: "%02d", bmp390I2C.getPinNumber(name:"SDA"))
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
    @ObservedObject var bmp390 : BMP390
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
                Button(action: {
                    bluetoothDevice.setBMP390SPI(input: "2" + String(format: "%02d", ESP_32.getBMP390_SPI().getDeviceNumberInArray(inputDevice: bmp390))
                    )}) {
                        Text("Get Data")
                    }
            }
            Chart(data, id: \.type) { dataSeries in
                       ForEach(dataSeries.petData) { data in
                           LineMark(x: .value("Year", data.year),
                                    y: .value("Population", data.population))
                       }
                       .foregroundStyle(by: .value("Pet type", dataSeries.type))
                       .symbol(by: .value("Pet type", dataSeries.type))
                   }
                   .chartXScale(domain: 1998...2024)
                   .aspectRatio(1, contentMode: .fit)
                   .padding()
        }
    }
}

struct BMP390_SPIView_Previews: PreviewProvider {
    static var previews: some View {
        
        BMP390_I2CView()
        
    }
}
