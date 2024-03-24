//
//  ProfileFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.03.24.
//

import Foundation

// Протокол для модели данных
protocol ProfileModelInput: AnyObject {
    func fetchUserData()
    func userIsAnonymously(completionHandler: @escaping (Bool?) -> Void)
}
    
final class ProfileFirebaseService {
    
    weak var output: ProfileModelOutput?
    private let serviceFB = FirebaseService.shared
    
    init(output: ProfileModelOutput) {
        self.output = output
    }
    
    deinit {
        print("deinit CartFirebaseService")
    }
}

extension ProfileFirebaseService:ProfileModelInput {
    func userIsAnonymously(completionHandler: @escaping (Bool?) -> Void) {
        serviceFB.userIsAnonymously(completionHandler: completionHandler)
    }
    
    func fetchUserData() {
        let user = UserProfile(name: "Evgeny", email: "klenovminsk@mail.ru", url: "nil")
        output?.updateUserProfile(with: user)
    }
}
