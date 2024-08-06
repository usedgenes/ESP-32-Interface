import Foundation
import SwiftUICharts
import SwiftUI

struct ChartStyle {
    let gridStyle = GridStyle(lineColour   : Color(.lightGray).opacity(0.5),
                              lineWidth    : 1,
                              dash         : [8],
                              dashPhase    : 0)
    
    var chartStyle : LineChartStyle
    
    init() {
        chartStyle = LineChartStyle(infoBoxPlacement    : .floating,
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
                                    
                                    globalAnimation     : .easeOut(duration: 0))
    }
    
    func getChartStyle() -> LineChartStyle {
        return chartStyle
    }
}
