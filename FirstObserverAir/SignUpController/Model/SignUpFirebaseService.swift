//
//  SignUpFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.03.24.
//

import Foundation
// Протокол для модели данных
protocol SignUpModelInput: AnyObject {
    func signUp(email: String, password: String, name: String, completion: @escaping (Error?, Bool) -> Void)
}

final class SignUpFirebaseService {
    
    private let serviceFB = FirebaseService.shared
    
    deinit {
        print("deinit SignUpFirebaseService")
    }
}

extension SignUpFirebaseService: SignUpModelInput {
    func signUp(email: String, password: String, name: String, completion: @escaping (Error?, Bool) -> Void) {
        serviceFB.signUp(email: email, password: password, name: name) { error, isAnon in
            completion(error, isAnon)
        }
    }
    
    
}

