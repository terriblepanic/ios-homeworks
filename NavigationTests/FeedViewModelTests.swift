//
//  FeedViewModelTests.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/6/26.
//

import XCTest
@testable import Navigation

final class FeedModelMock: FeedModelProtocol {

    var wordIsCorrect: Bool = false

    func check(word: String) {
        NotificationCenter.default.post(
            name: FeedModel.checkResultNotification,
            object: nil,
            userInfo: [FeedModel.resultKey: wordIsCorrect]
        )
    }
}

final class FeedViewModelTests: XCTestCase {

    var viewModel: FeedViewModel!
    var feedModelMock: FeedModelMock!

    override func setUp() {
        super.setUp()
        feedModelMock = FeedModelMock()
        viewModel = FeedViewModel(feedModel: feedModelMock)
    }

    override func tearDown() {
        viewModel = nil
        feedModelMock = nil
        super.tearDown()
    }

    func test_checkWord_correct() {
        feedModelMock.wordIsCorrect = true
        viewModel.checkWord("Swift")
        XCTAssertEqual(viewModel.state, .correct)
    }

    func test_checkWord_incorrect() {
        feedModelMock.wordIsCorrect = false
        viewModel.checkWord("wrong")
        XCTAssertEqual(viewModel.state, .incorrect)
    }

    func test_checkWord_empty_staysIdle() {
        feedModelMock.wordIsCorrect = true
        viewModel.checkWord("")
        XCTAssertEqual(viewModel.state, .idle)
    }
}
