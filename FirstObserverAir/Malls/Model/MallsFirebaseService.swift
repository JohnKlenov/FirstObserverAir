//
//  MallsFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 1.02.24.
//

import Foundation

// Протокол для модели данных
protocol MallsModelInput: AnyObject {
    //    func isEmptyPathsGenderListener() -> Bool
    //    func toggleLocalGender()
    //    func toggleGlobalAndLocalGender()
    //    func returnLocalGender() -> String
    //    func setGlobalGender(gender:String)
    func updateLocalGender()
    func fetchGenderData()
    func isSwitchGender(completion: @escaping () -> Void)
    
}

class MallsFirebaseService {
    
    weak var output: MallsModelOutput?
    private let serviceFB = FirebaseService.shared
    
    init(output: MallsModelOutput) {
        self.output = output
//        updateLocalGender()
    }
}

extension MallsFirebaseService: MallsModelInput {
    func updateLocalGender() {
        print("")
    }
    
    func fetchGenderData() {
        print("")
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        print("")
    }
    
    
}
