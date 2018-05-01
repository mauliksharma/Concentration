//
//  Card.swift
//  Concentration
//
//  Created by Maulik Sharma on 19/01/18.
//  Copyright © 2018 Maulik Sharma. All rights reserved.
//

import Foundation

struct Card: Hashable { //Struct has no inheritance, and is value type
    
    var hashValue: Int {
        return identifier
    }   //property to be implemented to conform to Hashable protocol
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }   //implementing equal-to operator to conform to Equatable protocol, so that cards can be compared (by implicitly comparing their hash-values)
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory: Int = 0 //static belongs to type (here: 'Card'), not the instances
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 //if this wasn't a static func, it would have been Card.identifierFactory
        return identifierFactory
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
    
}
