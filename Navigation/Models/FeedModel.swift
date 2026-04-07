//
//  FeedModel.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/1/26.
//

import Foundation

final class FeedModel: FeedModelProtocol {
    
    private let secretWord: String = "Swift"
    
    static let checkResultNotification = Notification.Name("FeedModelCheckResult")
    
    static let resultKey = "isCorrect"
    
    func check(word: String) {
        let isCorrect = word.lowercased() == secretWord.lowercased()
        
        NotificationCenter.default.post(
            name: FeedModel.checkResultNotification,
            object: nil,
            userInfo: [FeedModel.resultKey: isCorrect]
        )
    }
}
