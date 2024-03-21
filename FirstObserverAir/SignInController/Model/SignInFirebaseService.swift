//
//  SignInFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.03.24.
//



//rules_version = '2';
//service cloud.firestore {
//  match /databases/{database}/documents {
//    // Allow only authenticated users
//    match /{document=**} {
//      allow read, write: if request.auth != null;
//    }
//  }
//}


//cloud firestore rules_version = '2';
//
//service cloud.firestore {
// match /databases/{database}/documents {
//   // Разрешаем чтение любых данных
//   match /{document=**} {
//     allow read: if true;
//   }
//
//   // Разрешаем запись только в документы, где идентификатор пользователя совпадает
//   match /users/{userId}/{document=**} {
//     allow write: if request.auth != null && request.auth.uid == userId;
//   }
// }
//}

//service cloud.firestore {
//  match /databases/{database}/documents {
//    // Разрешаем чтение любых данных
//    match /{document=**} {
//      allow read: if true;
//    }
//
//    // Разрешаем запись только в документы, где идентификатор пользователя совпадает
//    match /users/{userId}/{document=**} {
//      allow write: if request.auth != null && request.auth.uid == userId;
//    }
//
//    // Разрешаем удаление данных анонимного пользователя
//    match /users/{userId}/cartProducts/{productId} {
//      allow delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.previousUserId == userId;
//    }
//  }
//}

import Foundation

// Протокол для модели данных
protocol SignInModelInput: AnyObject {
    func signIn(email: String, password: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void)
    func sendPasswordReset(email: String, completion: @escaping (AuthErrorCodeState) -> Void)
    func fetchValueAuthErrorCodeState(state: AuthErrorCodeState, completion: @escaping (AuthErrorCodeState, String?) -> Void)
}

final class SignInFirebaseService {
    
    private let serviceFB = FirebaseService.shared
    
    deinit {
        print("deinit SignInFirebaseService")
    }
}

extension SignInFirebaseService: SignInModelInput {
    func fetchValueAuthErrorCodeState(state: AuthErrorCodeState, completion: @escaping (AuthErrorCodeState, String?) -> Void) {
        serviceFB.fetchValueAuthErrorCodeState(state: state, completion: completion)
    }
    
    func sendPasswordReset(email: String, completion: @escaping (AuthErrorCodeState) -> Void) {
        serviceFB.sendPasswordReset(email: email, completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthErrorCodeState, Bool) -> Void) {
        serviceFB.signIn(email: email, password: password, completion: completion)
//        serviceFB.signIn(email: email, password: password) { state, isAnon in
//            completion(state,isAnon)
//        }
    }
    
    
}
