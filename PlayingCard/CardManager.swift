//
//  File.swift
//  File
//
//  Created by 連振甫 on 2021/8/2.
//

import Foundation

enum CardType:Int {
    case Love = 1
    case Peach = 2
    case Plum = 3
    case Cube = 4
    
    var title:String {
        switch self {
        case .Love:
            return "Love"
        case .Peach:
            return "Peach"
        case .Plum:
            return "Plum"
        case .Cube:
            return "Cube"
        }
    }
}

struct Card {
    let number:Int
    let type:CardType
    
    var imageName:String{
        return "\(self.type.title)Card\(number)"
    }
    
    var point:Int{
        
        if number > 9 {
            return 10
        }
        else if number == 1 {
            return 11
        }
        else{
            return number
        }
        
    }
}

class CardManager {
    
    static let shared = CardManager()
    
    func getNewCards() -> [Card] {
        
        var cards = [Card]()
        
        while cards.count < 52 {
            let card = Card(number: Int.random(in: 1...13), type: .init(rawValue: Int.random(in: 1...4))!)
            if cards.first(where: {$0.number == card.number && $0.type == card.type}) == nil {
                cards.append(card)
            }
        }
        
        return cards
    }
    
}
