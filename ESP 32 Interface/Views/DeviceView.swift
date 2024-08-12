//
//  DeviceView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI
struct deviceView : View {
    @ObservedObject var device : Device
    
    var body: some View {
        Text(device.name)
        Spacer()
        Button(action: {editAlert(device: device)}) {
            Text("Edit Pins")
        }.buttonStyle(BorderlessButtonStyle())
        Spacer()
        Button(action: {setNameAlert(device : device)}) {
            Text("Change Name")
        }.buttonStyle(BorderlessButtonStyle())
        Spacer()
    }
}

struct DeviceArrayView : View {
    @ObservedObject var deviceArray : DeviceArray
    var body: some View {
        ForEach(deviceArray.devices, id: \.self) { device in
            HStack {
                deviceView(device: device)
                Button(action: {deviceArray.deleteDevice(device: device)}) {
                    Text("Delete")
                }.buttonStyle(BorderlessButtonStyle())
            }
            .environmentObject(device)
        }.padding(.leading)
    }
}

struct DeviceView: View {
    @State private var singleSelection: UUID?
    @EnvironmentObject var ESP_32 : ESP32

    var body: some View {

        List() {
            Section(header: Text("Motion")) {
                HStack{
                    Text("Servos")
                    Spacer()
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.servo_Type)
                    }) {
                        Text("Add")
                    }
                }
                DeviceArrayView(deviceArray : ESP_32.servos)
            }
            Section(header: Text("Altimeters")) {
                HStack{
                    Text("BMP390")
                    Spacer()
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.bmp390I2C_Type)
                    }) {
                        Text("Add I2C")
                    }
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.bmp390SPI_Type)
                    }) {
                        Text("Add SPI")
                    }
                }
                DeviceArrayView(deviceArray : ESP_32.bmp390s)
            }
            Section(header: Text("Inertial Measurement Units")) {
                HStack{
                    Text("BNO08X")
                    Spacer()
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.bno08xI2C_Type)
                    }) {
                        Text("Add I2C")
                    }
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.bno08xSPI_Type)
                    }) {
                        Text("Add SPI")
                    }
                }
                DeviceArrayView(deviceArray : ESP_32.bno08xs)
            }
            Section(header: Text("Miscellaneous")) {
                HStack{
                    Text("Pins")
                    Spacer()
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.pin_Type)
                    }) {
                        Text("Add Pin")
                    }
                }
                DeviceArrayView(deviceArray : ESP_32.pins)
                HStack{
                    Text("Buzzers")
                    Spacer()
                    Button(action:{
                        self.addDeviceAlert(deviceType: ESP_32.buzzer_Type)
                    }) {
                        Text("Add Buzzer")
                    }
                }
                DeviceArrayView(deviceArray : ESP_32.buzzers)
            }
        }
        .onDisappear(perform: {
            ESP_32.saveState()
        })
        .navigationTitle("Device List")
    }

    private func addDeviceAlert(deviceType: DeviceType) {
        var pinNumbers : [Int] = Array(repeating: -1, count: deviceType.pinTypes.count)
        let alert = UIAlertController(title: "Attach Pins", message: "Enter the pins this device is attached to on the ESP32", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        let alertDone = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            var attachedPins: [AttachedPin] = []
            for number in 0..<deviceType.pinTypes.count {
                attachedPins.append(AttachedPin(pinName: deviceType.pinTypes[number], pinNumber: pinNumbers[number]))
            }
            if(alert.textFields![0].text == "") {
                let currentDevice = deviceType.deviceType.init(name: deviceType.type , attachedPins: attachedPins)
                deviceType.devices.addDevice(device: currentDevice)
            } else {
                let currentDevice = deviceType.deviceType.init(name: alert.textFields![0].text ?? deviceType.type , attachedPins: attachedPins)
                deviceType.devices.addDevice(device: currentDevice)
            }
            ESP_32.saveState()
        })
        alertDone.isEnabled = false
        alert.addAction(alertDone)
        alert.addTextField() { textField in
            textField.placeholder = "Name: " + deviceType.type
        }
        for pinType in deviceType.pinTypes {
            alert.addTextField() { textField in
                textField.placeholder = pinType
                textField.keyboardType = .numberPad
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                        {_ in
                    let text = textField.text ?? ""
                    if (text != "") {
                        pinNumbers[deviceType.pinTypes.firstIndex(of: pinType)!] = Int(text)!
                    }
                    else {
                        pinNumbers[deviceType.pinTypes.firstIndex(of:pinType)!] = -1                    }
                    if(pinNumbers.allSatisfy({$0 >= 0})) {
                        alertDone.isEnabled = true
                    }
                    else {
                        alertDone.isEnabled = false
                    }
                })

            }
        }
        showAlert(alert: alert)
    }
}

private func setNameAlert(device: Device) {
    let alert = UIAlertController(title: "Device Name", message: "Edit the name of this device", preferredStyle: .alert)
    let alertDone = UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
        let input = alert?.textFields![0].text
        if(input != "") {
            device.name = input!
        }
    })
    alert.addAction(alertDone)
    alert.addTextField() { textField in
            textField.placeholder = "Name: " + device.name
    }
    showAlert(alert: alert)
}

private func editAlert(device: Device) {
    let alert = UIAlertController(title: "Pin Number", message: "Edit the pins of this device", preferredStyle: .alert)
    let alertDone = UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
        for number in 0..<device.attachedPins.count {
            let input = alert?.textFields![number].text
            if(input != "") {
                device.attachedPins[number].setNumber(pinNumber: Int(input!)!)
            }
        }
    })
    alert.addAction(alertDone)
    for pin in device.attachedPins {
        alert.addTextField() { textField in
            textField.placeholder = pin.pinName + ": \(pin.pinNumber)"
            textField.keyboardType = .numberPad
        }
    }
    showAlert(alert: alert)
}

func showAlert(alert: UIAlertController) {
    if let controller = topMostViewController() {
        controller.present(alert, animated: true)
    }
}

private func keyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
}

private func topMostViewController() -> UIViewController? {
    guard let rootController = keyWindow()?.rootViewController else {
        return nil
    }
    return topMostViewController(for: rootController)
}

private func topMostViewController(for controller: UIViewController) -> UIViewController {
    if let presentedController = controller.presentedViewController {
        return topMostViewController(for: presentedController)
    } else if let navigationController = controller as? UINavigationController {
        guard let topController = navigationController.topViewController else {
            return navigationController
        }
        return topMostViewController(for: topController)
    } else if let tabController = controller as? UITabBarController {
        guard let topController = tabController.selectedViewController else {
            return tabController
        }
        return topMostViewController(for: topController)
    }
    return controller
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
