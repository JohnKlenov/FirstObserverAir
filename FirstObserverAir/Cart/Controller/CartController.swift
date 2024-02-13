//
//  CartController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

// Протокол для обработки полученных данных
protocol CartModelOutput:AnyObject {
    func updateData(cartProduct: [ProductItem], isAnonymousUser:Bool)
}

final class CartController: UIViewController {
    
    private var cartModel: CartModelInput?
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private var cartProducts: [ProductItem] = []
    private var cartViewIsEmpty: CartView?
    private var isAnonymouslyUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartModel?.fetchData()
        resetBadgeValue()
    }
}

// MARK: - Setting Views
private extension CartController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        title = R.Strings.TabBarController.Cart.title
        cartModel = CartFirebaseService(output: self)
        view.addSubview(tableView)
        setupConstraints()
    }
}

// MARK: - Setting
private extension CartController {
    func resetBadgeValue() {
        if let items = self.tabBarController?.tabBar.items {
            items[3].badgeValue = nil
        }
    }
    
    func createCartViewIsEmpty() {
        cartViewIsEmpty = CartView()
        cartViewIsEmpty?.delegate = self
        cartViewIsEmpty?.signInSignUpButton.isHidden = isAnonymouslyUser ? false : true
    }
    
    func configureTableViewIsEmpty(products:[ProductItem], tableView:UITableView) {
        if products.count == 0 {
            createCartViewIsEmpty()
            tableView.setEmptyView(emptyView: cartViewIsEmpty ?? UIView())

        } else {
            tableView.backgroundView = nil
            cartViewIsEmpty = nil
        }
    }
    
    func removeCartProduct(tableView: UITableView, indexPath: IndexPath) {
            let product = cartProducts[indexPath.row]
            cartProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            cartModel?.removeCartProduct(model: product.model ?? "", index: indexPath.row)
    }
    
    func setupAlertNotConnected() {
        let alert = UIAlertController(title: "Oops!", message: "No internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Layout
private extension CartController {
    func setupConstraints() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor), tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configureTableViewIsEmpty(products: cartProducts, tableView: tableView)
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configureCell(model: cartProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeCartProduct(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

// MARK: - CartModelOutput
extension CartController:CartModelOutput {
    func updateData(cartProduct: [ProductItem], isAnonymousUser:Bool) {
        cartProducts = cartProduct
        isAnonymouslyUser = isAnonymousUser
        tableView.reloadData()
    }
}


// MARK: - CartViewDelegate
extension CartController: CartViewDelegate {
    func didTaplogInButton() {
        print("didTaplogInButton")
    }
    
    func didTapCatalogButton() {
        print("didTapCatalogButton")
    }
    
    
}
