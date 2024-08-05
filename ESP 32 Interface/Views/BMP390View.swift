import SwiftUI
import SwiftUICharts

struct BMP390View: View {
    
    @EnvironmentObject var ESP_32 : ESP32
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        VStack {
            if(ESP_32.getBMP390s().devices.isEmpty) {
                Text("No BMP390s Attached")
            }
            else {
                List {
                    ForEach(ESP_32.getBMP390s().devices, id: \.self) { bmp390 in
                        let _ = print(bmp390)
                        individualBMP390View(bmp390: bmp390 as! BMP390)
                    }
                }
                .onAppear(perform: {
                    bluetoothDevice.setBMP390(input: "0" + String(ESP_32.getBMP390s().devices.count))
                    for bmp390 in ESP_32.getBMP390s().devices {
                        var bmp390PinString = "1"
                        bmp390PinString += String(format: "%02d", ESP_32.getBMP390s().getDeviceNumberInArray(inputDevice: bmp390))
                        if(bmp390.attachedPins.count == 2) {
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SDA"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SCL"))
                        }
                        else {
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"CS"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"SCK"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"MISO"))
                            bmp390PinString += String(format: "%02d", bmp390.getPinNumber(name:"MOSI"))
                        }
                        
                        bluetoothDevice.setBMP390(input: bmp390PinString)
                        print(bmp390PinString)
                    }
                })
            }
        }
    }
}

struct individualBMP390View : View {
    @EnvironmentObject var ESP_32 : ESP32
    @ObservedObject var bmp390 : BMP390
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
                NavigationLink("View Data", destination: BMP390ChartView(bmp390: bmp390))
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BMP390ChartView : View {
    @ObservedObject var bmp390 : BMP390
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var ESP_32 : ESP32
    var body : some View {
        VStack {
            Button(action: {
                                bluetoothDevice.setBMP390(input: "2" + String(format: "%02d", ESP_32.getBMP390s().getDeviceNumberInArray(inputDevice: bmp390))
                                )}) {
                                    Text("Get Data")
                                }
                                
            let temperatureData = LineChartData(dataSets: bmp390.getTemperatureDataSet(), chartStyle: ChartStyle().getChartStyle())
            //temperature
            LineChart(chartData: temperatureData)
                .filledTopLine(chartData: temperatureData,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: temperatureData, specifier: "%.0f")
                .xAxisGrid(chartData: temperatureData)
                .yAxisGrid(chartData: temperatureData)
                .xAxisLabels(chartData: temperatureData)
                .yAxisLabels(chartData: temperatureData)
                .floatingInfoBox(chartData: temperatureData)
                .headerBox(chartData: temperatureData)
                .id(temperatureData.id)
                .frame(minWidth: 150, maxWidth: 390, minHeight: 150, maxHeight: 400)
            Text("Temperature")
                .padding()
        }
    }
}

struct BMP390View_Previews: PreviewProvider {
    static var previews: some View {
        BMP390View()
    }
}
