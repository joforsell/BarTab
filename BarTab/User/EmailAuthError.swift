//
//  EmailAuthError.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-10.
//

import Foundation

enum EmailAuthError: Error {
    case incorrectPassword
    case invalidEmail
    case accoundDoesNotExist
    case unknownError
    case couldNotCreate
    case extraDataNotCreated
}

extension EmailAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectPassword:
            return NSLocalizedString("Lösenordet stämmer inte med användaren.", comment: "")
        case .invalidEmail:
             return NSLocalizedString("Ej giltig mailadress.", comment: "")
        case .accoundDoesNotExist:
            return NSLocalizedString("Mailadress ej registrerad till en användare.", comment: "")
        case .unknownError:
            return NSLocalizedString("Okänt fel.", comment: "")
        case .couldNotCreate:
            return NSLocalizedString("Kunde inte skapa ett konto.", comment: "")
        case .extraDataNotCreated:
            return NSLocalizedString("Kunde inte spara användarnamn.", comment: "")
        }
    }
}
