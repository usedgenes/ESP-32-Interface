import SwiftUI
import PDFKit
import UIKit

struct AppHelpView: View {
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        ScrollView {
            Text("App Info")
                .font(.largeTitle)
                .padding(.top)
                .padding(.bottom, 2)
            
            Button(action: {self.isSharePresented = true}) {
                Text("Save Arduino Code")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
            }
            .sheet(isPresented: $isSharePresented, onDismiss: {
                print("Dismiss")
            }, content: {
                let url = Bundle.main.url(forResource: "ArduinoCode", withExtension: "pdf")!
                let document = PDFDocument(url: url)
                let documentData = document!.dataRepresentation()
                ActivityViewController(activityItems: ["Save Code", documentData!], applicationActivities: nil)
            })
            
            Group {
                CollapsibleView(
                    label: { Text("Getting Started") },
                    content: {
                        HStack {
                            Text("To use this app, first press the blue \"Save Arduino Code\" button above. Copy the code into the Arduino IDE and upload it to your ESP32. If you aren't using some of the devices this app supports and need more memory on your ESP32, you can just remove those parts of the code - it should be self-explanatory what each class and variable does. Feel free to also add your own devices to the iOS app - the github respository is https://github.com/usedgenes/ESP-32-Interface.")
                            Spacer()
                        }
                    }
                )
                
                CollapsibleView(
                    label: { Text("Bluetooth") },
                    content: {
                        HStack {
                            Text("Available devices will automatically be shown in the bluetooth tab. Simply click on a device to connect to it, and the device name will be displayed. You can refresh the bluetooth list, and you can also disconnect form a device. Once connected, press the LED Blink Test Button to test the connection if you want - the ESP32 will start blinking. Press the button again to turn the blinking LED off.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("Adding Devices") },
                    content: {
                        HStack {
                            Text("Click on the \"View Devices\" tab to add devices to your ESP32. \nTo add a device: Press the \"Add\" button, enter the pins the device is connected to on the ESP32, change the default name if you want, and then press \"OK.\" A name isn't required, but you must enter in all the pins to add a device. \nYou can change the name and pins of the device at any time you want. \nTo delete a device, simply press the \"Delete\" button, or press the \"Reset Devices\" button on the home screen. \nYour devices will be saved when you exit the app, including their name and pins.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("Servos") },
                    content: {
                        HStack {
                            Text("Simply enter the servo position and press \"Send\" to set the desired servo position. You can also use the slider to adjust the servo position, and the app will automaticlly write the position without you needing to press \"Send\". There is a possibility that if you move the slider too fast and too frequently, the servo will start lagging due to too many commands. You can also control the servo through your phone's attitude - select a motion type (roll, pitch, or yaw), and then press the play button. Zero roll/pitch/yaw corresponds to the servo position 90, while max roll/pitch/yaw corresponds to either servo position 0 or 180.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("BMP390s") },
                    content: {
                        HStack {
                            Text("Press the \"View Data\" button to open the bmp390 data screen. Press \"Get Data\" to have the bmp390 start logging data, and press \"Stop\" to stop logging data. Press any of the \"Reset\" buttons to clear the corresponding graph data. The app requests data once every second from the bmp390.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("BNO08X") },
                    content: {
                        HStack {
                            Text("Press the \"View Data\" button to open the bno08x data screen. Press \"Get Data\" to have the bno08x start logging data, and press \"Stop\" to stop logging data. Press any of the \"Reset\" buttons to clear the corresponding graph data. Press any of the three data buttons to open up a graph view of what you want. The app requests data once every second from the bno08x.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("BMI088s") },
                    content: {
                        HStack {
                            Text("Press the \"View Data\" button to open the bno08x data screen. Press \"Get Data\" to have the bno08x start logging data, and press \"Stop\" to stop logging data. Press any of the \"Reset\" buttons to clear the corresponding graph data. Press any of the two data buttons to open up a graph view of what you want. The app requests data once every second from the bmi088.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("Digital/Analog Pins") },
                    content: {
                        HStack {
                            Text("You can control an individual's pin output to be either digital or analog, though make sure that the pin you're writing to is capable of sending the signal type you're using")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
                
                CollapsibleView(
                    label: { Text("Buzzers") },
                    content: {
                        HStack {
                            Text("Enter the frequency in hertz and the duration in seconds, then press \"Send\" to play a tone. You can also press the play button to play a tone indefinitely, and use the slider to adjust the pitch. the minimum pitch is 0 hz, and the maximum pitch is 5000 hz.")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    }
                )
            }
        } .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}

struct CollapsibleView<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        self.label()
                            .padding(.leading)
                            .font(.title2)
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                            .padding(.trailing)
                    }
                    .padding(.bottom, 1)
                    .background(Color.white.opacity(0.01))
                }
            )
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .frame(height: 0)
                .padding(.leading)
                .padding(.trailing)
            
            VStack {
                self.content()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .padding(.leading, 35)
            .padding(.bottom, 15)
        }
    }
}

struct AppHelpView_Previews: PreviewProvider {
    static var previews: some View {
        AppHelpView()
    }
}
