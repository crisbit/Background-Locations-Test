//
//  Memory.swift
//  Bacground Locations Test
//
//  Created by Cristian Bellomo on 20/09/16.
//  Copyright © 2016 Grocerest. All rights reserved.
//

import Foundation

class Memory {
    
    private static let defaults = UserDefaults.standard
    
    static func load() -> [Location] {
        let dictionaryLocations = defaults.array(forKey: "locations")
        
        guard dictionaryLocations != nil else { return [Location]() }
        
        var locations = [Location]()
        for dictLocation in dictionaryLocations as! [[String: Any]] {
            locations.append(Location(from: dictLocation))
        }
        return locations
    }
    
    static func save(locations: [Location]) {
        var dictLocations = [[String: Any]]()
        for location in locations {
            dictLocations.append(location.toDictionary())
        }
        defaults.set(dictLocations, forKey: "locations")
    }
    
    static func append(_ location: Location) {
        var locations = self.load()
        locations.append(location)
        self.save(locations: locations)
    }
    
    static func reset() {
        defaults.removeObject(forKey: "locations")
    }
    
}
