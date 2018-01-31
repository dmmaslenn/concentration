//
//  ViewController.swift
//  concentration
//
//  Created by Darya Maslennikova on 11/28/17.
//  Copyright © 2017 Darya Maslennikova. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    @IBAction func NewGameButton(_ sender: UIButton) {
        newGame();
    }
    //    let attribtext = NSAttributedString(string : "Flips: 0", attributes: attributes)
    
    var numberOfPairsOfCards: Int
    {
            return (cardButtons.count+1) / 2
    }
    
    private(set) var flipCount = 0{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel()
    {
        let attributes: [NSAttributedStringKey : Any] = [
            .strokeColor : #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1),
            .strokeWidth : 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips : \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
//    private var emojiChoices = ["❄️","🌲", "🎄", "⛷", "🏂", "☃️", "🎁", "🎅🏼" ,"🎉", "🍾","🍊","⛸"]
    
    private var emojiChoices = "❄️🌲🎄⛷🏂☃️🎁🎅🏼🎉🍾🍊⛸"
    
    @IBOutlet private var cardButtons: [UIButton]!
   
    func newGame()
    {
        game.shuffleCards();
    }
    
    @IBAction private func touchCard(_ sender: UIButton)
    {
        if let cardNumber = cardButtons.index(of: sender)
        {
            if cardButtons[cardNumber].backgroundColor != #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            {
                flipCount += 1
            }
            game.chooseCard(at: cardNumber)
            if game.newGame == true{
                flipCount = 0
                game.newGame = false
                emojiChoices += "❄️🌲🎄⛷🏂☃️🎁🎅🏼🎉🍾🍊⛸"
            }
            updateViewFromModel()
        }
//        flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
    }
    
    private func updateViewFromModel()
    {
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp
            {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }
            else
            {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String
    {
        if emoji[card] == nil , emojiChoices.count > 0
        {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
                emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
        {
        didSet{
            updateFlipCountLabel()
        }
    }
}

extension Int{
    var arc4random: Int {
        if self > 0 {
        return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0
        {
             return -Int(arc4random_uniform(UInt32(self)))
        }
        else
        {
            return 0
        }
    }
}
