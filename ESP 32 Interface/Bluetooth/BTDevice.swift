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
    
    private var pinChar: CBCharacteristic?
    
    private var buzzerChar: CBCharacteristic?
    
    private var bmi088Char: CBCharacteristic?
    
    private var pidChar: CBCharacteristic?
    
    private var resetChar: CBCharacteristic?
    
    var ESP_32 : ESP32?
    
    var edf : EDF?
    
    var rocket: Rocket?
    
    weak var delegate: BTDeviceDelegate?
    
    var resetString: String {
        get {
            return "-1"
        }
        set {
            if let char = resetChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    var pidString: String {
        get {
            return "-1"
        }
        set {
            if let char = pidChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    var bmi088String: String {
        get {
            return "-1"
        }
        set {
            if let char = bmi088Char {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var buzzerString: String {
        get {
            return "-1"
        }
        set {
            if let char = buzzerChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var pinString: String {
        get {
            return "-1"
        }
        set {
            if let char = pinChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var bno08xString: String {
        get {
            return "-1"
        }
        set {
            if let char = bno08xChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var bmp390String: String {
        get {
            return "-1"
        }
        set {
            if let char = bmp390Char {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var servoString: String {
        get {
            return "-1"
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
                peripheral.discoverCharacteristics([BTUUIDs.blinkUUID, BTUUIDs.servoUUID, BTUUIDs.esp32Service, BTUUIDs.bmp390UUID, BTUUIDs.bno08xUUID, BTUUIDs.pinUUID, BTUUIDs.buzzerUUID, BTUUIDs.bmi088UUID, BTUUIDs.pidUUID, BTUUIDs.resetUUID], for: $0)
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
            } else if $0.uuid == BTUUIDs.pinUUID {
                self.pinChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.buzzerUUID {
                self.buzzerChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.bmi088UUID {
                self.bmi088Char = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.pidUUID {
                self.pidChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.resetUUID {
                self.resetChar = $0
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
        if characteristic.uuid == servoChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(Int(value[...value.startIndex]) == 3) {
                    value.remove(at: value.startIndex)
                    
                    let servo0pos = Float(value)!
                    edf!.addServo0Pos(pos: servo0pos)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    
                    let servo1pos = Float(value)!
                    edf!.addServo1Pos(pos: servo1pos)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    
                    let servo2pos = Float(value)!
                    edf!.addServo2Pos(pos: servo2pos)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 6) {
                    value.remove(at: value.startIndex)
                    
                    let servo3pos = Float(value)!
                    edf!.addServo3Pos(pos: servo3pos)
                    
                    return;
                }
            }
        }
        if characteristic.uuid == pidChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    
                    let yawCmd = Float(value)!
                    edf!.addYawCommand(cmd: yawCmd)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    
                    let pitchCmd = Float(value)!
                    edf!.addPitchCommand(cmd: pitchCmd)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 6) {
                    value.remove(at: value.startIndex)
                    
                    let rollCmd = Float(value)!
                    edf!.addRollCommand(cmd: rollCmd)
                    
                    return;
                }
            }
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
                    
                    let rotationX = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let rotationY = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let rotationZ = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)

                    let rotationReal = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let rotationAccuracy = Float(value)!

                    ESP_32!.getBNO08X(index: deviceNumber).addRotationX(rotationX: rotationX)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationY(rotationY: rotationY)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationZ(rotationZ: rotationZ)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationReal(rotationReal: rotationReal)
                    ESP_32!.getBNO08X(index: deviceNumber).addRotationAccuracy(rotationAccuracy: rotationAccuracy)
                }
                //gyro
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    let gyroX = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)

                    let gyroY = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
   
                    let gyroZ = Float(value)!

                    ESP_32!.getBNO08X(index: deviceNumber).addGyroX(gyroX: gyroX)
                    ESP_32!.getBNO08X(index: deviceNumber).addGyroY(gyroY: gyroY)
                    ESP_32!.getBNO08X(index: deviceNumber).addGyroZ(gyroZ: gyroZ)
                }
                //accelerometer
                if(Int(value[...value.startIndex]) == 5) {
                    value.remove(at: value.startIndex)
                    
                    let accelX = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let accelY = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let accelZ = Float(value)!
                    
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerX(accelerometerX: accelX)
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerY(accelerometerY: accelY)
                    ESP_32!.getBNO08X(index: deviceNumber).addAccelerometerZ(accelerometerZ: accelZ)
                }
            }
        }
        if characteristic.uuid == bmi088Char?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(Int(value[...value.startIndex]) == 7) {
                    value.remove(at: value.startIndex)
                    
                    let yaw = Float(value)!
                    edf!.addYaw(yaw: yaw)
                    
                    return;
                }
                if(Int(value[...value.startIndex]) == 8) {
                    value.remove(at: value.startIndex)
                    
                    let pitch = Float(value)!
                    edf!.addPitch(pitch: pitch)
                    
                    return;
                    
                }
                if(Int(value[...value.startIndex]) == 9) {
                    value.remove(at: value.startIndex)
                    
                    let roll = Float(value)!
                    edf!.addRoll(roll: roll)
                    
                    return;
                }
                let deviceNumber = Int(value[...value.index(value.startIndex, offsetBy: 1)])!
                value.removeSubrange(...value.index(value.startIndex, offsetBy: 1))
                print(value);
                //gyro
                if(Int(value[...value.startIndex]) == 3) {
                    value.remove(at: value.startIndex)
                    let gyroX = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)

                    let gyroY = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
   
                    let gyroZ = Float(value)!

                    ESP_32!.getBMI088(index: deviceNumber).addGyroX(gyroX: gyroX)
                    ESP_32!.getBMI088(index: deviceNumber).addGyroY(gyroY: gyroY)
                    ESP_32!.getBMI088(index: deviceNumber).addGyroZ(gyroZ: gyroZ)
                    print("gyro")
                }
                //accelerometer
                if(Int(value[...value.startIndex]) == 4) {
                    value.remove(at: value.startIndex)
                    
                    let accelX = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let accelY = Float(value[..<value.firstIndex(of: ",")!])!
                    value.removeSubrange(...value.firstIndex(of: ",")!)
                    
                    let accelZ = Float(value)!
                    
                    ESP_32!.getBMI088(index: deviceNumber).addAccelerometerX(accelerometerX: accelX)
                    ESP_32!.getBMI088(index: deviceNumber).addAccelerometerY(accelerometerY: accelY)
                    ESP_32!.getBMI088(index: deviceNumber).addAccelerometerZ(accelerometerZ: accelZ)
                    print("accelerometer")
                }
                //thrust vectoring edf
            }
        }
    }
}


