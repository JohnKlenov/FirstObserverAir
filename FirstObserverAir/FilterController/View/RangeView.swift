//
//  RangeView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

import UIKit

final class RangeView: UIView {
    
    let fromLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.label
        view.textAlignment = .center
        return view
    }()
    
    let toLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.label
        view.textAlignment = .center
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.label
        view.textAlignment = .left
        return view
    }()
    
    var lowerValue:Double?
    var upperValue:Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RangeView")
    }
}

// MARK: - Setting
extension RangeView {
    private func setupViews() {
        
        // UILabel сверху на всю ширину
        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.width - 20, height: 30)
        titleLabel.text = "Price range"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        addSubview(titleLabel)

        // Левый UILabel в одном ряду со сверху лежащим UILabel
        fromLabel.frame = CGRect(x: 10, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
        fromLabel.backgroundColor = UIColor.secondarySystemBackground
        fromLabel.layer.cornerRadius = 5
        fromLabel.clipsToBounds = true
        addSubview(fromLabel)

        // Правый UILabel в одном ряду со сверху лежащим UILabel и прижатый к правому краю
        toLabel.frame = CGRect(x: frame.width - 70, y: titleLabel.frame.maxY + 10, width: 60, height: 30)
        toLabel.backgroundColor = UIColor.secondarySystemBackground
        toLabel.layer.cornerRadius = 5
        toLabel.clipsToBounds = true
        addSubview(toLabel)
    }
    
    func updateLabels(lowerValue:Double, upperValue:Double) {

        fromLabel.text = "\(Int(lowerValue))"
        toLabel.text = "\(Int(upperValue))"
        self.lowerValue = lowerValue
        self.upperValue = upperValue
    }
}
