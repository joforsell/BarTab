//
//  UserRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class UserHandling: ObservableObject {
    
    // MARK: - User profile
    
    let db = Firestore.firestore().collection("users")
    
    @Published var user = User()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUser()
    }
    
    func loadUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { return }
                guard let data = try? document.data(as: User.self) else { return }
                
                self.user = data
            }
    }
    
    func updateUserEmail(_ email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "email": email ] , merge: true)
    }
    
    func updateUserAssociation(_ association: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "association": association ] , merge: true)
    }
    
    func updateUserTagUsage(_ isUsingTags: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "usingTags": isUsingTags ] , merge: true)
    }
    
    
    // MARK: - User authentication state
    
    @Published var userAuthState: AuthState = .undefined
    
    enum AuthState {
        case undefined, signedOut, signedIn
    }
        
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            guard let _ = user else {
                self.userAuthState = .signedOut
                return
            }
            self.userAuthState = .signedIn
        }
    }
}
