
import Foundation

class QuoteDeck {
    
    // MARK: - Properties
    
    var tagSet: [String] = []
    
    var quotes: [Quote] = []
//        Quote(text: "one",
//              tags: [ "Chapter 1"]),
//        Quote(text: "two",
//              tags: [ "ملكففححخ"]),
//        Quote(text: "three",
//              tags: [ "chapter 3"]),
//        Quote(text: "Four",
//              tags: [ "Chapter 4"]),
//        Quote(text: "Five",
//              tags: [ "chapter 5"]),
//        Quote(text: "Six",
//              tags: [ "chapter 6"])
    
    
    
    // MARK: - Singleton pattern
    
    static let sharedInstance = QuoteDeck()
    
    private init() {
        update()
    }
    
    // MARK: - Private helpers
    
    func update() {
        for quote in quotes {
            for tag in quote.tags {
                if !tagSet.contains(tag) {
                    tagSet.append(tag)
                }
            }
        }
    }
    
    func quotesForTag(_ tag: String) -> [Quote] {
        var matchingQuotes: [Quote] = []
        
        for quote in quotes {
            if quote.tags.contains(tag) {
                matchingQuotes.append(quote)
            }
        }
        
        return matchingQuotes
    }
}
