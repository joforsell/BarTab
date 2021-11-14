//
//  Authentication.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-10.
//

import SwiftUI
import FirebaseAuth
import CryptoKit
import AuthenticationServices

struct Authentication {
    // MARK: - Sign In with Email functions
    
    static func resetPassword(email: String, resetCompletion: @escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        }
        )}
    
    static func authenticate(withEmail email: String, password: String, completionHandler: @escaping (Result<Bool, EmailAuthError>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // check the NSError code and convert the error to an AuthError type
            var newError: NSError
            if let err = error {
                newError = err as NSError
                var authError: EmailAuthError?
                switch newError.code {
                case 17009:
                    authError = .incorrectPassword
                case 17008:
                    authError = .invalidEmail
                case 17011:
                    authError = .accoundDoesNotExist
                default:
                    authError = .unknownError
                }
                completionHandler(.failure(authError!))
            } else {
                completionHandler(.success(true))
            }
        }
    }
    
    // MARK: - User creation
    static func createUser(withEmail email: String, password: String, completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.link(with: credential) { authResult, error in
            if let err = error {
                completionHandler(.failure(err))
                return
            }
            guard let _ = authResult?.user else {
                completionHandler(.failure(error!))
                return
            }
            
            completionHandler(.success(true))
        }
    }
    
    // MARK: - Logout
    
    static func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            completion(.success(true))
        } catch let err {
            completion(.failure(err))
        }
    }
    
    // MARK: - Re-authenticate
    
    static func reauthenticate(withEmail email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("Could not reauthenticate")
                completion(.failure(error))
            }
            
            completion(.success(true))
        }
    }
    
}
