//To add new device:
//create new device cbcharacteristic variable
//update the three peripheral functions in extension BTDevice: CBPeripheralDelegate
//create a function in BTDevice
import Foundation
import CoreBluetooth


protocol BTDeviceDelegate: class {
    func deviceConnected()
    func deviceReady()
    func deviceBlinkChanged(value: Bool)
    func deviceSpeedChanged(value: Int)
    func deviceSerialChanged(value: String)
    func deviceDisconnected()

}

class BTDevice: NSObject {
    private let peripheral: CBPeripheral
    private let manager: CBCentralManager
    private var blinkChar: CBCharacteristic?
    private var speedChar: CBCharacteristic?
    public var _blink: Bool = false
    
    private var servoChar: CBCharacteristic?
    
    private var bmp390Char: CBCharacteristic?
    private var _bmp390data: Int = 0
    
    var ESP_32 : ESP32?
    
    weak var delegate: BTDeviceDelegate?
    
    var bmp390data: Int {
        get {
            return 0
        }
        set {

         }
    }
    
    var bmp390String: String{
        get {
            return self.bmp390String
        }
        set {
            if let char = bmp390Char {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var servoString: String {
        get {
            return self.servoString
        }
        set {
            if let char = servoChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
         }
    }
    
    var blink: Bool {
        get {
            return _blink
        }
        set {
            guard _blink != newValue else { return }
            
            _blink = newValue
            if let char = blinkChar {
                peripheral.writeValue(Data(bytes: [_blink ? 1 : 0]), for: char, type: .withResponse)
            }
        }
    }
    
    var name: String {
        return peripheral.name ?? "Unknown device"
    }
    var detail: String {
        return peripheral.identifier.description
    }
    private(set) var serial: String?
    
    init(peripheral: CBPeripheral, manager: CBCentralManager) {
        self.peripheral = peripheral
        self.manager = manager
        super.init()
        self.peripheral.delegate = self
    }
    
    func connect() {
        manager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    func intToChar(number: Int) -> [Character] {
        return Array(String(number))
    }
}

extension BTDevice {
    // these are called from BTManager, do not call directly
    
    func connectedCallback() {
        peripheral.discoverServices([BTUUIDs.esp32Service])
        delegate?.deviceConnected()
    }
    
    func disconnectedCallback() {
        delegate?.deviceDisconnected()
    }
    
    func errorCallback(error: Error?) {
        print("Device: error \(String(describing: error))")
    }
}


extension BTDevice: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Device: discovered services")
        peripheral.services?.forEach {
            print("  \($0)")
            if $0.uuid == BTUUIDs.esp32Service {
                peripheral.discoverCharacteristics([BTUUIDs.blinkUUID, BTUUIDs.servoUUID, BTUUIDs.esp32Service, BTUUIDs.bmp390UUID], for: $0)
            } else {
                peripheral.discoverCharacteristics(nil, for: $0)
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Device: discovered characteristics")
        service.characteristics?.forEach {
            print("   \($0)")
            
            if $0.uuid == BTUUIDs.blinkUUID {
                self.blinkChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.servoUUID {
                self.servoChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.bmp390UUID {
                self.bmp390Char = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            }
        }
        print()
        
        delegate?.deviceReady()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Device: updated value for \(characteristic)")
        
        if characteristic.uuid == blinkChar?.uuid, let b = characteristic.value {
            let temp = String(decoding: b, as: UTF8.self)
            if(temp == "On") {
                _blink = true
            }
            else {
                _blink = false
            }
            delegate?.deviceBlinkChanged(value: _blink)
        }

        if characteristic.uuid == bmp390Char?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                var deviceNumber = Int(value[...value.startIndex])!
                print("number")
                print(deviceNumber)
                value.remove(at: value.startIndex)
                //temperature
                if(Int(value[...value.startIndex]) == 3) {
                    value.remove(at: value.startIndex)
                    var bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addTemperature(temperature: bmp390Data)
                }
                //pressure
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    var bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addPressure(pressure: bmp390Data)
                }
                //altitude
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    var bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addAltitude(altitude: bmp390Data)
                }
                print(value)
            }
        }
    }
}


