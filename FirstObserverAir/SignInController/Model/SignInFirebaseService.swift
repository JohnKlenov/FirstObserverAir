//
//  SignInFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.03.24.
//

import Foundation

// Протокол для модели данных
protocol SignInModelInput: AnyObject {
    func signIn(email: String, password: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void)
    func sendPasswordReset(email: String, completion: @escaping (AuthErrorCodeState) -> Void)
}

final class SignInFirebaseService {
    
    private let serviceFB = FirebaseService.shared
    
    deinit {
        print("deinit SignInFirebaseService")
    }
}

extension SignInFirebaseService: SignInModelInput {
    
    func sendPasswordReset(email: String, completion: @escaping (AuthErrorCodeState) -> Void) {
        serviceFB.sendPasswordReset(email: email, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void) {
        serviceFB.signIn(email: email, password: password, completion: completion)
    }
    
    
}