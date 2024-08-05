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
//                NavigationLink("View Data", destination: BMP390ChartView(bmp390: bmp390))
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BMP390ChartView : View {
//    @ObservedObject var bmp390 : BMP390
    let data : LineChartData = weekOfData()
    var body : some View {
        VStack {
                    LineChart(chartData: data)
                        .pointMarkers(chartData: data)
                        .touchOverlay(chartData: data, specifier: "%.0f")
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data)
                        .infoBox(chartData: data)
                        .headerBox(chartData: data)
                        .id(data.id)
                        .frame(minWidth: 150, maxWidth: 390, minHeight: 150, idealHeight: 150, maxHeight: 400, alignment: .center)
                        .padding()
                }
                .navigationTitle("Week of Data")
    }
    
    static func weekOfData() -> LineChartData {
           let data = LineDataSet(dataPoints: [
               LineChartDataPoint(value: 12000, xAxisLabel: "M", description: "Monday"),
               LineChartDataPoint(value: 10000, xAxisLabel: "T", description: "Tuesday"),
               LineChartDataPoint(value: 8000,  xAxisLabel: "W", description: "Wednesday"),
               LineChartDataPoint(value: 17500, xAxisLabel: "T", description: "Thursday"),
               LineChartDataPoint(value: 16000, xAxisLabel: "F", description: "Friday"),
               LineChartDataPoint(value: 11000, xAxisLabel: "S", description: "Saturday"),
               LineChartDataPoint(value: 9000,  xAxisLabel: "S", description: "Sunday")
           ],
           pointStyle: LineStyle(),
           style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
           
           let metadata = ChartMetadata(title: "Step Count", subtitle: "Over a Week")
           
           let gridStyle = GridStyle(numberOfLines: 7, lineColour: Color(.lightGray).opacity(0.5),
                                      lineWidth    : 1,
                                      dash         : [8],
                                      dashPhase    : 0)
           
           let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                           infoBoxBorderColour : Color.primary,
                                           infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                           
                                           markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                           
                                           xAxisGridStyle      : gridStyle,
                                           xAxisLabelPosition  : .bottom,
                                           xAxisLabelColour    : Color.primary,
                                           xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                           
                                           yAxisGridStyle      : gridStyle,
                                           yAxisLabelPosition  : .leading,
                                           yAxisLabelColour    : Color.primary,
                                           yAxisNumberOfLabels : 7,
                                           
                                           baseline            : .minimumWithMaximum(of: 5000),
                                           topLine             : .maximum(of: 20000))
           
           return LineChartData(dataSets       : data,
                                metadata       : metadata,
                                chartStyle     : chartStyle)
           
       }
}

struct BMP390View_Previews: PreviewProvider {
    static var previews: some View {
        BMP390ChartView()
    }
}
