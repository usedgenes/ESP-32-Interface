//
//  TestView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 8/5/24.
//

import SwiftUI
import SwiftUICharts

struct TestView: View {
    var temperature = [LineChartDataPoint(value: Double(10000), xAxisLabel: "1", description: "Temperature"), LineChartDataPoint(value: Double(15000), description: "Temperature")]
    
    var body: some View {
        var temperatureData = LineChartData(dataSets: LineDataSet(dataPoints: temperature,
                                                                  legendTitle: "Celsius", pointStyle: PointStyle(),
                                                                  style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line)), chartStyle: ChartStyle().getChartStyle())
        LineChart(chartData: temperatureData)
            .pointMarkers(chartData: temperatureData)
                            .touchOverlay(chartData: temperatureData, specifier: "%.0f")
                            .yAxisPOI(chartData: temperatureData,
                                      markerName: "Step Count Aim",
                                      markerValue: 15_000,
                                      labelPosition: .center(specifier: "%.0f"),
                                      labelColour: Color.black,
                                      labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
                                      lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                      strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                            .yAxisPOI(chartData: temperatureData,
                                      markerName: "Minimum Recommended",
                                      markerValue: 10_000,
                                      labelPosition: .center(specifier: "%.0f"),
                                      labelColour: Color.white,
                                      labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
                                      lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
                                      strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                            .averageLine(chartData: temperatureData,
                                         strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                            .xAxisGrid(chartData: temperatureData)
                            .yAxisGrid(chartData: temperatureData)
                            .xAxisLabels(chartData: temperatureData)
                            .yAxisLabels(chartData: temperatureData)
                            .infoBox(chartData: temperatureData)
                            .headerBox(chartData: temperatureData)
                            .legends(chartData: temperatureData, columns: [GridItem(.flexible()), GridItem(.flexible())])
                            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 250, maxHeight: 400, alignment: .center)    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
