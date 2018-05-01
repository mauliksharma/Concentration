//
//  Concentration.swift
//  Concentration
//
//  Created by Maulik Sharma on 19/01/18.
//  Copyright © 2018 Maulik Sharma. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cardsCollection = Array<Card>()
    
    private var indexOfOneAndOnlyCard: Int? {
        get {
            return cardsCollection.indices.filter{cardsCollection[$0].isFaceUp}.oneAndOnlyElement //equivalent to next comment block
        }

        /*  let indicesOfFaceUpCards = cardsCollection.indices.filter() {cardsCollection[$0].isFaceUp}
         //here indicesOfFaceUpCard is Array of Array.Index which is basically equivalent to Int (unlike String.Index). here indices gives a countable range i.e. sequence of those Array.Index, on which filter can be applied; also filter has a trailing closure here. $0 is shorthand argument inferred to be Array.Index since filter is applied on a sequence of the same.
                return indicesOfFaceUpCards.count == 1 ? indicesOfFaceUpCards.first : nil //array.first is same as array[0] */
            
            //            var foundOneIndex: Int?
            //            for index in cardsCollection.indices {
            //                if cardsCollection[index].isFaceUp {
            //                    if foundOneIndex == nil {
            //                        foundOneIndex = index
            //                    }
            //                    else {
            //                        return nil
            //                    }
            //                }
            //            }
            //            return foundOneIndex

        set {
            for index in cardsCollection.indices {
                cardsCollection[index].isFaceUp = (index == newValue) //isFaceUp will be true for value of index equal to newValue, false for rest of the values
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var score = 0
    
    private var seenCardsindices = [Int]()
    
    func chooseCard(at index: Int) {
        assert(cardsCollection.indices.contains(index), "Concentration.chooseCard(at: \(index)): Chosen index not in the cards")
        
        if !cardsCollection[index].isFaceUp, !cardsCollection[index].isMatched { //makes no sense to choose a card that is already chosen or matched and hidden
            
            if let indexOfCardToMatchWith = indexOfOneAndOnlyCard { //for one card face up:-
                
                if cardsCollection[index] == cardsCollection[indexOfCardToMatchWith] {
                    cardsCollection[indexOfCardToMatchWith].isMatched = true
                    cardsCollection[index].isMatched = true
                    score += 2
                }
                else {
                    if seenCardsindices.contains(indexOfCardToMatchWith) {
                        score -= 1
                    }
                    else {
                        seenCardsindices.append(indexOfCardToMatchWith)
                    }
                    if seenCardsindices.contains(index) {
                        score -= 1
                    }
                    else {
                        seenCardsindices.append(index)
                    }
                }
                cardsCollection[index].isFaceUp = true
            }
                
            else { //for none or 2 cards face up:-
                indexOfOneAndOnlyCard = index
            }
            flipCount += 1
        }
    }
    
    private var tempCollection = [Card]()
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "You must have atleast 1 pair of cards")
        
        for _ in 0..<numberOfPairsOfCards {
            let newCard = Card()
            tempCollection += [newCard, newCard] //every newCard instance will be a separate copy since Card is struct (value type)
        }
        for _ in 0..<tempCollection.count { //shuffling the cards
            let randomIndex = Int(arc4random_uniform(UInt32(tempCollection.count)))
            cardsCollection.append(tempCollection[randomIndex])
            tempCollection.remove(at: randomIndex)
        }
    }
}

extension Collection { //extending the protocol for Collection (applies to like Arrays, Strings, Countable Ranges, Dictionary, etc
    var oneAndOnlyElement: Element? { //computed property
        return count == 1 ? first : nil //count and first are computed properties of Collections
    }
}
