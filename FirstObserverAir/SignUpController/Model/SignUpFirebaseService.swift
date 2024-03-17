//
//  SignUpFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.03.24.
//

import Foundation
// Протокол для модели данных
protocol SignUpModelInput: AnyObject {
    func signUp(email: String, password: String, name: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void)
    func verificationEmail()
    func fetchValueAuthErrorCodeState(state: AuthErrorCodeState, completion: @escaping (AuthErrorCodeState, String?) -> Void)
}

final class SignUpFirebaseService {
    
    private let serviceFB = FirebaseService.shared
    
    deinit {
        print("deinit SignUpFirebaseService")
    }
}

extension SignUpFirebaseService: SignUpModelInput {
    
    func verificationEmail() {
        serviceFB.verificationEmail()
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void) {
        serviceFB.signUp(email: email, password: password, name: name, completion: completion)
//        serviceFB.signUp(email: email, password: password, name: name) { state, isAnon in
//            completion(state,isAnon)
//        }
    }
    
    func fetchValueAuthErrorCodeState(state: AuthErrorCodeState, completion: @escaping (AuthErrorCodeState, String?) -> Void) {
        serviceFB.fetchValueAuthErrorCodeState(state: state, completion: completion)
    }
    
}

