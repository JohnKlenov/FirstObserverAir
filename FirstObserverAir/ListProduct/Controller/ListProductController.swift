//
//  ListProductController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//

import UIKit

final class ListProductController: UIViewController {
    
    private var dataSource:[ProductItem] = [] {
        didSet {
            
        }
    }
    
    private var listProductModel: ListProductModelInput
    
    init(modelInput: ListProductModelInput) {
        self.listProductModel = modelInput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
