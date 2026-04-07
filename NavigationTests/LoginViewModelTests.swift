//
//  LoginViewModelTests.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 4/6/26.
//

import XCTest
@testable import Navigation

final class LoginDelegateMock: LoginViewControllerDelegate {

    var checkResult: Result<Void, Error> = .success(())
    var signUpResult: Result<Void, Error> = .success(())

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(checkResult)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(signUpResult)
    }
}

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    var delegateMock: LoginDelegateMock!

    override func setUp() {
        super.setUp()
        delegateMock = LoginDelegateMock()
        viewModel = LoginViewModel(loginDelegate: delegateMock)
    }

    override func tearDown() {
        viewModel = nil
        delegateMock = nil
        super.tearDown()
    }

    func test_login_emptyFields_failure() {
        viewModel.login(email: "", password: "")
        XCTAssertEqual(viewModel.state, .failure(message: "Введите email и пароль"))
    }

    func test_login_credentialsSuccess() {
        delegateMock.checkResult = .success(())
        viewModel.login(email: "test@test.com", password: "123456")
        XCTAssertEqual(viewModel.state, .success)
    }

    func test_login_credentialsFailure() {
        let error = NSError(domain: "test", code: 999, userInfo: [NSLocalizedDescriptionKey: "Ошибка"])
        delegateMock.checkResult = .failure(error)
        viewModel.login(email: "test@test.com", password: "123456")
        XCTAssertEqual(viewModel.state, .failure(message: "Ошибка"))
    }

    func test_login_userNotFound_signUpSuccess() {
        let error = NSError(domain: "FIRAuthErrorDomain", code: 17011, userInfo: nil)
        delegateMock.checkResult = .failure(error)
        delegateMock.signUpResult = .success(())
        viewModel.login(email: "new@test.com", password: "123456")
        XCTAssertEqual(viewModel.state, .success)
    }
}
