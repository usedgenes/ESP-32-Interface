//
//  DeviceView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct AddDeviceView: View {
    @State private var singleSelection: UUID?
    @ObservedObject var ESP_32 : ESP32
    @State var bluetoothManagerHelper = BluetoothManagerHelper()

    var body: some View {

        List() {
            ForEach(ESP_32.ESP32Devices, id: \.self) { deviceCategory in
                Section(header: Text("\(deviceCategory.category)")) {
//                    ForEach(deviceCategory.devices, id: \.self) { device in
//                        HStack {
//                            Text("\(device.name)")
//                            Spacer()
//                            Button(action: {self.alert()}) {
//                                Text("Add")
//                            }
//                        }
//                        .contentShape(Rectangle())
//                        
//                        //                                    ForEach(ESP_32.de)
//                    }
                }
            }
        }
        .navigationTitle("Device List")
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Pin Number", message: "Enter the pins this device is attached to on the ESP32", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Enter pin number"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        let alertDone = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        alert.addAction(alertDone)
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
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView(ESP_32 : ESP32())
    }
}
