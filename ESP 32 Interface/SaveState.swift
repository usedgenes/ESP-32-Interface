//
//  SaveState.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/31/24.
//

import Foundation

extension UserDefaults {

       static let defaults = UserDefaults.standard
       
       // save Data method
       static func saveDevices(devices: [Device]){
         do{
            let encoder = JSONEncoder()
            let devices = try encoder.encode(devices)
            defaults.setValue(devices, forKey: "devices")
         }catch let err{
            print(err)
         }
      }
      
     //retrieve data method
     static func getDevices() -> [Device]{
   
            guard let devicesData = defaults.object(forKey: "devices") as? Data else{return []}
            do{
                let decoder = JSONDecoder()
                let devices = try decoder.decode([Device].self, from: devicesData)
                return devices
            }catch let err{
                return([])
          }
       }
}
