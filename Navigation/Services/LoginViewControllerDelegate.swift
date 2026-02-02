//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 1/31/26.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
