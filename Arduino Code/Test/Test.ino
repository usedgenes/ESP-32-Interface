#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <TaskScheduler.h>

#define SERVICE_UUID              "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define BLINK_UUID                "e94f85c8-7f57-4dbd-b8d3-2b56e107ed60"
#define SERVO_UUID                "a8985fda-51aa-4f19-a777-71cf52abba1e"

#define DEVICE_NAME         "ESP_32"

#define PIN_BUTTON 0
#define PIN_LED LED_BUILTIN

Scheduler scheduler;

void blinkCb();
void blinkOffCb();

Task taskBlink(500, TASK_FOREVER, &blinkCb, &scheduler, false, NULL, &blinkOffCb);

uint8_t blinkOn;
uint8_t blinkSpeed = 5;

BLECharacteristic *pCharBlink;
BLECharacteristic *pServo;

void(* resetFunc) (void) = 0; //declare reset function @ address 0

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

void setBlinkSpeed(uint8_t v) {
  blinkSpeed = v;
  taskBlink.setInterval(v * 100);
  Serial.println("Blink speed updated");
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
      resetFunc();
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

class ServoCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      String value = pCharacteristic->getValue();

      Serial.println(value);
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting...");

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

  pServo = pService-> pService->createCharacteristic(SERVO_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pServo->setCallbacks(new ServoCallbacks());
  pService->start();

  // ----- Advertising

  BLEAdvertising *pAdvertising = pServer->getAdvertising();

  BLEAdvertisementData adv;
  adv.setName(devName.c_str());
  adv.setCompleteServices(BLEUUID(SERVICE_UUID));
  pAdvertising->setAdvertisementData(adv);

  pAdvertising->start();

  Serial.println("Ready");
  Serial.print("Device name: ");
  Serial.println(devName);
}

void loop() {
  scheduler.execute();
}
