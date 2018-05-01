//
//  ViewController.swift
//  Concentration
//
//  Created by Maulik Sharma on 19/01/18.
//  Copyright © 2018 Maulik Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {      //read only Computed Property, no need for private(set) because it's already read only
        return (cardButtons.count)/2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var gameScoreLabel: UILabel!
    
    @IBAction private func startAgain(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
        availableEmojis = loadingEmojis()
        emojiDict = [Card: String]()
        updateViewFromModel()
        
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardButtonIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardButtonIndex)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() { //checks for changes in cards in model to update in View
        for index in cardButtons.indices { //same as 0..<cardButton.count
            let button = cardButtons[index]
            let card = game.cardsCollection[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.7896886531, blue: 0.4371617177, alpha: 1)
            }
            else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9736175379, green: 0.9994240403, blue: 0.9814655069, alpha: 0) : #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
            }
        }
        flipCountLabel.text = "FLIP COUNT: \(game.flipCount)"
        gameScoreLabel.text = String(game.score)
    }
    
    private var emojiDict = [Card: String]()    //we made Card to be Hashable
    private lazy var availableEmojis = loadingEmojis()
    
    private func loadingEmojis() -> [String] {
        var emojiChoices = [["😃","😍","😎","😉","😐","😡","😰","😈"], ["🐶","🐭","🦊","🐼","🐨","🦁","🐷","🐵"], ["❤️","🧡","💛","💚","💙","💜","🖤","💖"], ["👍","👎","👊","👌","🖖","🤘","🤝","👏"], ["☠️","👽","👻","👹","🎃","🤡","🧟‍♀️","👾"]]
        let randomThemeIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
        return emojiChoices[randomThemeIndex]
    }
    
    private func emoji(for card: Card) -> String {
        if emojiDict[card] == nil, availableEmojis.count > 0 {
            emojiDict[card] = availableEmojis.remove(at: availableEmojis.count.arc4random) //Array.remove(at: Int ) removes element from the array and returns it too
        }
        return emojiDict[card] ?? "?" //same as: if Optional != nil, unwrap optional or else "?"
    }
}
extension Int {
    var arc4random: Int {           //extensions can only have computed properties, not stored properties
        if self>0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self<0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
