#include "SD.h"

#define SD_UUID "6492bdaa-60e3-4e8a-a978-c923dec9fc37"

BLECharacteristic *pSD;

class SDCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      SPI.begin(value.substring(1, 3).toInt(), value.substring(3, 5).toInt(), value.substring(5, 7).toInt(), value.substring(7, 9).toInt());
      if (!SD.begin(value.substring(7, 9))) {
        pCharacteristic->setValue("01");
        pCharacteristic->notify();
      }
      if (SD.cardType() == CARD_NONE) {
        pCharacteristic->setValue("01");
        pCharacteristic->notify();
      }
    }
    if (value.substring(0, 1) == "1") {
      uint64_t cardSize = SD.cardSize() / (1024 * 1024);
      pCharacteristic->setValue("10" + cardSize.toString());
      pCharacteristic->notify();
      uint64_t availableSpace = SD.totalBytes() / (1024 * 1024);
      pCharacteristic->setValue("11" + availableSpace.toString());
      pCharacteristic->notify();
      uint64_t usedSpace = SD.usedBytes() / (1024 * 1024);
      pCharacteristic->setValue("11" + usedSpace.toString());
      pCharacteristic->notify();
    }
    if (value.substring(0, 1) == "2") {
      String directory = value.substring(1, value.length());
    }
    if (value.substring(0, 1) == "3") {
      //append file
    }
    if (value.substring(0, 1) == "4") {
      //read file
    }
    if (value.substring(0, 1) == "5") {
      //delete file
    }
    if (value.substring(0, 1) == "6") {
      //rename file
    }
    Serial.println(value);
  }
};

  pSD = pService->createCharacteristic(SD_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pSD->setCallbacks(new SDCallbacks());