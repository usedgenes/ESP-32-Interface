#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <TaskScheduler.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BMP3XX.h"
#include <ESP32Servo.h>

#define SERVICE_UUID              "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define BLINK_UUID                "e94f85c8-7f57-4dbd-b8d3-2b56e107ed60"
#define SERVO_UUID                "cceaf7ab-3160-46fb-9147-93b7fb6540ff"
#define ALTIMETER_UUID                "a8985fda-51aa-4f19-a777-71cf52abba1e"

#define DEVINFO_UUID              (uint16_t)0x180a
#define DEVINFO_MANUFACTURER_UUID (uint16_t)0x2a29
#define DEVINFO_NAME_UUID         (uint16_t)0x2a24
#define DEVINFO_SERIAL_UUID       (uint16_t)0x2a25

#define DEVICE_MANUFACTURER "The Cave"
#define DEVICE_NAME         "ESP_Blinky"

#define PIN_BUTTON 0
#define PIN_LED LED_BUILTIN

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10
#define SEALEVELPRESSURE_HPA (1013.25)

Scheduler scheduler;

void buttonCb();
void blinkCb();
void blinkOffCb();

Task taskBlink(500, TASK_FOREVER, &blinkCb, &scheduler, false, NULL, &blinkOffCb);
Task taskButton(30, TASK_FOREVER, &buttonCb, &scheduler, true);

uint8_t blinkOn;
uint8_t blinkSpeed = 5;

BLECharacteristic *pCharBlink;
BLECharacteristic *pServoValue;

Servo servo;
Adafruit_BMP3XX bmp;

void setBlink(bool on, bool notify = false) {
  if (blinkOn == on) return;

  blinkOn = on;
  if (blinkOn) {
    Serial.println("Blink ON");
    taskBlink.restartDelayed(0);
  } else {
    Serial.println("Blink OFF");
    taskBlink.disable();
  }

  pCharBlink->setValue(&blinkOn, 1);
  if (notify) {
    pCharBlink->notify();
  }
}

void blinkCb() {
  digitalWrite(PIN_LED, taskBlink.getRunCounter() & 1);
}

void blinkOffCb() {
  digitalWrite(PIN_LED, 0);
}

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      Serial.println("Connected");
    };

    void onDisconnect(BLEServer* pServer) {
      Serial.println("Disconnected");
    }
};

class BlinkCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      String value = pCharacteristic->getValue();

      if (value.length()  == 1) {
        uint8_t v = value[0];
        Serial.print("Got blink value: ");
        Serial.println(v);
        setBlink(v ? true : false);
      } else {
        Serial.println("Invalid data received");
      }
    }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting...");

  pinMode(PIN_BUTTON, INPUT);
  pinMode(PIN_LED, OUTPUT);

  String devName = DEVICE_NAME;
  String chipId = String((uint32_t)(ESP.getEfuseMac() >> 24), HEX);
  devName += '_';
  devName += chipId;

  BLEDevice::init(devName.c_str());
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharBlink = pService->createCharacteristic(BLINK_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pCharBlink->setCallbacks(new BlinkCallbacks());
  pCharBlink->addDescriptor(new BLE2902());

  pServoValue = pService>createCharacterstic(SERVO_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);

  pService->start();

  BLECharacteristic *pChar = pService->createCharacteristic(DEVINFO_MANUFACTURER_UUID, BLECharacteristic::PROPERTY_READ);
  pChar->setValue(DEVICE_MANUFACTURER);
  pService->start();
  // ----- Advertising

  BLEAdvertising *pAdvertising = pServer->getAdvertising();

  BLEAdvertisementData adv;
  adv.setName(devName.c_str());
  //adv.setCompleteServices(BLEUUID(SERVICE_UUID));
  pAdvertising->setAdvertisementData(adv);

  BLEAdvertisementData adv2;
  //adv2.setName(devName.c_str());
  adv2.setCompleteServices(BLEUUID(SERVICE_UUID));
  pAdvertising->setScanResponseData(adv2);

  pAdvertising->start();

}

void loop() {
  scheduler.execute();
}

// void setup() {
//   Serial.begin(115200);
//   while (!Serial);
//   Serial.println("Adafruit BMP388 / BMP390 test");

//   if (!bmp.begin_I2C()) {   // hardware I2C mode, can pass in address & alt Wire
//   //if (! bmp.begin_SPI(BMP_CS)) {  // hardware SPI mode  
//   //if (! bmp.begin_SPI(BMP_CS, BMP_SCK, BMP_MISO, BMP_MOSI)) {  // software SPI mode
//     Serial.println("Could not find a valid BMP3 sensor, check wiring!");
//     while (1);
//   }

//   // Set up oversampling and filter initialization
//   bmp.setTemperatureOversampling(BMP3_OVERSAMPLING_8X);
//   bmp.setPressureOversampling(BMP3_OVERSAMPLING_4X);
//   bmp.setIIRFilterCoeff(BMP3_IIR_FILTER_COEFF_3);
//   bmp.setOutputDataRate(BMP3_ODR_50_HZ);
// }

// void loop() {
//   if (! bmp.performReading()) {
//     Serial.println("Failed to perform reading :(");
//     return;
//   }
//   Serial.print("Temperature = ");
//   Serial.print(bmp.temperature);
//   Serial.println(" *C");

//   Serial.print("Pressure = ");
//   Serial.print(bmp.pressure / 100.0);
//   Serial.println(" hPa");

//   Serial.print("Approx. Altitude = ");
//   Serial.print(bmp.readAltitude(SEALEVELPRESSURE_HPA));
//   Serial.println(" m");

//   Serial.println();
//   delay(2000);
// }
