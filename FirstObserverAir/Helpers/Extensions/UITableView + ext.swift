//
//  UITableView + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.02.24.
//

import UIKit

extension UITableView {
    
    func setEmptyView(emptyView: UIView) {
        
        let containerEmpty = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        containerEmpty.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        containerEmpty.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        containerEmpty.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        containerEmpty.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 10).isActive = true
        containerEmpty.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -10).isActive = true
        
        backgroundView = containerEmpty
        separatorStyle = .none
    }
}
