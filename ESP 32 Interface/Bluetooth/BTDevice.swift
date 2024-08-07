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
    
    private var bno08xChar: CBCharacteristic?
    
    var ESP_32 : ESP32?
    
    weak var delegate: BTDeviceDelegate?
    
    var bno08xString: String {
        get {
            return self.bno08xString
        }
        set {
            if let char = bno08xChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var bmp390String: String {
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
                peripheral.discoverCharacteristics([BTUUIDs.blinkUUID, BTUUIDs.servoUUID, BTUUIDs.esp32Service, BTUUIDs.bmp390UUID, BTUUIDs.bno08xUUID], for: $0)
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
            } else if $0.uuid == BTUUIDs.bno08xUUID {
                self.bno08xChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            }
        }
        print()
        
        delegate?.deviceReady()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("Device: updated value for \(characteristic)")
        
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
                let deviceNumber = Int(value[...value.index(value.startIndex, offsetBy: 1)])!
                value.removeSubrange(...value.index(value.startIndex, offsetBy: 1))

                //temperature
                if(Int(value[...value.startIndex]) == 3) {
                    value.remove(at: value.startIndex)
                    let bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addTemperature(temperature: bmp390Data)
                }
                //pressure
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    let bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addPressure(pressure: bmp390Data)
                }
                //altitude
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    let bmp390Data = Float(value)!
                    ESP_32!.getBMP390(index: deviceNumber).addAltitude(altitude: bmp390Data)
                }
            }
        }
        
        if characteristic.uuid == bno08xChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                let deviceNumber = Int(value[...value.index(value.startIndex, offsetBy: 1)])!
                value.removeSubrange(...value.index(value.startIndex, offsetBy: 1))
                print(value);
                //rotation
                if(Int(value[...value.startIndex]) == 3) {
                    value.remove(at: value.startIndex)
                    let bno08xXData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xXData)
                    let bno08xYData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xYData)
                    let bno08xZData = Float(value[..<value.firstIndex(of: ",")!])!
                    print(bno08xZData)
                    let bno08xRealData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xRealData)
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    let bno08xAccuracyData = Float(value)!
                    print(bno08xAccuracyData)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationX(rotationX: bno08xXData)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationY(rotationY: bno08xYData)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationZ(rotationZ: bno08xZData)
                    print("rotation")
                }
                //gyro
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    let bno08xXData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xXData)
                    let bno08xYData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xYData)
                    let bno08xZData = Float(value)!
                    print(bno08xZData)
                    ESP_32!.getBNO08X(index: deviceNumber).addGyroX(gyroX: bno08xXData)
                    ESP_32!.getBNO08X(index: deviceNumber).addGyroY(gyroY: bno08xYData)
                    ESP_32!.getBNO08X(index: deviceNumber).addGyroZ(gyroZ: bno08xZData)
                    print("gyro")
                }
                //accelerometer
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    let bno08xXData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    print(bno08xXData)
                    let bno08xYData = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    let bno08xZData = Float(value)!
                    print(bno08xZData)
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerX(accelerometerX: bno08xXData)
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerY(accelerometerY: bno08xYData)
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerZ(accelerometerZ: bno08xZData)
                    print("accelerometer")
                }
            }
        }
    }
}


