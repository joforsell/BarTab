//
//  EmailAuthError.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-10.
//

import Foundation
import Firebase
import SwiftUI

enum UserError: Error {
    case incorrectPassword
    case invalidEmail
    case accountDoesNotExist
    case unknownError
    case couldNotCreate
    case networkError
    case weakPassword
}

extension UserError: LocalizedError {
    var errorDescription: LocalizedStringKey? {
        switch self {
        case .incorrectPassword:
            return LocalizedStringKey("The password does not match the user.")
        case .invalidEmail:
            return LocalizedStringKey("Invalid e-mail address.")
        case .accountDoesNotExist:
            return LocalizedStringKey("Could not find a user with the given e-mail address.")
        case .couldNotCreate:
            return LocalizedStringKey("The given e-mail address is already in use.")
        case .unknownError:
            return LocalizedStringKey("Unknown error.")
        case .networkError:
            return LocalizedStringKey("A network error occurred. Please try again.")
        case .weakPassword:
            return LocalizedStringKey("Password too weak.")
        }
    }
}

extension UserError {
    static func convertedError(_ errorCode: AuthErrorCode) -> UserError {
        switch errorCode {
        case .wrongPassword:
            return .incorrectPassword
        case .invalidEmail:
            return .invalidEmail
        case .userNotFound:
            return .accountDoesNotExist
        case .emailAlreadyInUse:
            return .couldNotCreate
        case .networkError:
            return .networkError
        case .weakPassword:
            return .weakPassword
        default:
            return .unknownError
        }
    }
}
