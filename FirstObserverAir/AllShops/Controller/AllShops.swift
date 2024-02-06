//
//  AllShops.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.12.23.
//

import UIKit

final class AllShopsController: UIViewController {
    
    var shops:SectionModel
    var gender: String
    
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(shops:SectionModel, currentGender:String) {
        self.shops = shops
        self.gender = currentGender
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit AllShopsController")
    }
}

// MARK: - Setting Views
private extension AllShopsController {
    
    func setupView() {
        title = "AllShops"
        view.backgroundColor = R.Colors.systemBackground
        setupTableView()
        setupConstraints()
    }
}

// MARK: - Setting
private extension AllShopsController {
    func setupTableView() {
        tableView.register(AllShopCell.self, forCellReuseIdentifier: AllShopCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}


// MARK: TableViewDelegate + TableViewDataSource
extension AllShopsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllShopCell.reuseID, for: indexPath) as? AllShopCell else {
            // Обработка ошибки
            print("Returned message for analytic FB Crashlytics error AllShopsController")
            return UITableViewCell()
        }
        cell.configureCell(model: shops.items[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let valueField = shops.items[indexPath.row].shop?.name ?? ""
        let shopProductVC = BuilderViewController.buildListProductController(gender: gender, keyField: "shops", valueField: valueField, isArrayField: true)
        navigationController?.pushViewController(shopProductVC, animated: true)
    }
}

// MARK: - Layout
private extension AllShopsController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
}

