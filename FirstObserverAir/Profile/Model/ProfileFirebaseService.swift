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
    func userIsAnonymously(completionHandler: @escaping (Bool) -> Void)
    func updateProfileData(withImage image: Data?, name: String?, completion: @escaping (StateEditProfile, String?) -> ())
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
    func updateProfileData(withImage image: Data?, name: String?, completion: @escaping (StateEditProfile, String?) -> ()) {
        serviceFB.updateProfileData(withImage: image, name: name, completion)
    }
    
    func userIsAnonymously(completionHandler: @escaping (Bool) -> Void) {
        serviceFB.userIsAnonymously(completionHandler: completionHandler)
    }
    
    func fetchUserData() {
        let currentUser = serviceFB.currentUser
        let user = UserProfile(name: currentUser?.displayName ?? "No name", email: currentUser?.email ?? "No email", url: currentUser?.photoURL?.absoluteString)
        output?.updateUserProfile(with: user)
    }
}
