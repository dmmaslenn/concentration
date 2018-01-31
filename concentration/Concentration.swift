//
//  Concentration.swift
//  concentration
//
//  Created by Darya Maslennikova on 12/6/17.
//  Copyright © 2017 Darya Maslennikova. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [Card]()
    
    var newGame = false
    
    var matched = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int?
    {
        get{
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices{
//                if cards[index].isFaceUp{
//                    if foundIndex == nil{
//                        foundIndex = index
//                    }
//                    else{
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func shuffleCards()
    {
        matched = 0
        newGame = true
        for ind in 0..<cards.count
        {
            cards[ind].isFaceUp = false
            cards[ind].isMatched = false
        }
        for ind in 0..<cards.count
        {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(ind, randomIndex)
        }
    }
    
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)):chosen idex not in the cards")
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
//                check if cards matched
                if cards[matchIndex] == cards[index]
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matched += 2
                }
                cards[index].isFaceUp = true
            }
            else
            {
//                no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        else if matched == cards.count
        {
            shuffleCards();
        }
    }
    
    init(numberOfPairsOfCards: Int)
    {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)):you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
        for ind in 0..<cards.count
        {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(ind, randomIndex)
        }
    }
}

extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
