//
//  EmailAuthError.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-10.
//

import Foundation
import Firebase

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
    var errorDescription: String? {
        switch self {
        case .incorrectPassword:
            return NSLocalizedString("Lösenordet stämmer inte med användaren.", comment: "")
        case .invalidEmail:
             return NSLocalizedString("Ej giltig mailadress.", comment: "")
        case .accountDoesNotExist:
            return NSLocalizedString("Hittade ingen användare kopplad till den angivna mailadressen.", comment: "")
        case .couldNotCreate:
            return NSLocalizedString("Den angivna mailadressen används redan.", comment: "")
        case .unknownError:
            return NSLocalizedString("Okänt fel.", comment: "")
        case .networkError:
            return NSLocalizedString("Ett nätverksfel inträffade. Försök igen.", comment: "")
        case .weakPassword:
            return NSLocalizedString("För svagt lösenord.", comment: "")
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
