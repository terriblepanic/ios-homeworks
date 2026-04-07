//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/6/26.
//

import Foundation

enum FeedState: Equatable {
    case idle
    case correct
    case incorrect
}

final class FeedViewModel {

    private let feedModel: FeedModelProtocol
    private(set) var state: FeedState = .idle

    var onStateChanged: ((FeedState) -> Void)?

    init(feedModel: FeedModelProtocol = FeedModel()) {
        self.feedModel = feedModel
        setupNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCheckResult(_:)),
            name: FeedModel.checkResultNotification,
            object: nil
        )
    }

    @objc private func handleCheckResult(_ notification: Notification) {
        guard let isCorrect = notification.userInfo?[FeedModel.resultKey] as? Bool else { return }
        state = isCorrect ? .correct : .incorrect
        onStateChanged?(state)
    }

    func checkWord(_ word: String) {
        guard !word.isEmpty else {
            state = .idle
            onStateChanged?(state)
            return
        }
        feedModel.check(word: word)
    }
}
