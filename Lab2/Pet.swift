//
//  Pet.swift
//  Lab2
//
//  Created by Reis Sirdas on 2/8/17.
//  Copyright © 2017 sirdas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Pet: NSManagedObject {
    
    enum Species: Int {
        case dog = 0
        case cat = 1
        case bird = 2
        case bunny = 3
        case fish = 4
        
        var description: String {
            switch self {
            case .dog:
                return "dog"
            case .cat:
                return "cat"
            case .bird:
                return "bird"
            case .bunny:
                return "rabbit"
            case .fish:
                return "fish"
            }
        }
    }
    
    @NSManaged  var happiness: Int
    @NSManaged  var foodLevel: Int
    @NSManaged var isAlive: Bool
    
    @NSManaged var name: String
    
    @NSManaged var speciesRaw: Int
    
    var speciesAffiliation: Species {
        set { speciesRaw = newValue.rawValue }
        get { return Species(rawValue: speciesRaw)! }
    }
    
    //Behavior
    func play() {
        if (foodLevel > 0) {
            if (happiness < 10) {
                happiness += 1
            }
            foodLevel -= 1
            if (happiness == 10) {
                isAlive = false //heart attack
            }
            else if (foodLevel == 0) {
                isAlive = false //starvation
            }
        }
    }
    
    func feed() {
        if (foodLevel < 10) {
            foodLevel += 1
        }
        if (foodLevel == 10) {
            isAlive = false //diabetes
        }
        
    }
}
