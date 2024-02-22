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
    func updateOutdatedProducts(products: [ProductItem])
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
    
    private var cartProducts: [ProductItem] = [] {
        didSet {
            configureTableViewIsEmpty(products: cartProducts, tableView: tableView)
        }
    }
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
        cartViewIsEmpty = CartView(frame: view.frame)
        cartViewIsEmpty?.delegate = self
        cartViewIsEmpty?.signInSignUpButton.isHidden = isAnonymouslyUser ? false : true
    }
    
    func configureTableViewIsEmpty(products:[ProductItem], tableView:UITableView) {
        if products.count == 0 {
            createCartViewIsEmpty()
            tableView.backgroundView = cartViewIsEmpty
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            cartViewIsEmpty = nil
        }
    }
    
    func removeCartProduct(tableView: UITableView, indexPath: IndexPath) {
        ///tableView.beginUpdates(), вы сообщаете таблице, что вы собираетесь сделать несколько изменений, которые нужно анимировать одновременно.
        tableView.beginUpdates()
        let product = cartProducts[indexPath.row]
        tableView.deleteRows(at: [indexPath], with: .automatic)
        cartProducts.remove(at: indexPath.row)
        cartModel?.removeCartProduct(model: product.model ?? "", index: indexPath.row)
        ///Когда вы заканчиваете внесение изменений, вы вызываете tableView.endUpdates(), и все ваши изменения будут анимированы одновременно.
        tableView.endUpdates()
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
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configureCell(model: cartProducts[indexPath.row])
        return cell
    }
    
    ///создаем контекстное меню которое появляется при долгом нажатии
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                self.removeCartProduct(tableView: tableView, indexPath: indexPath)
//            }
//            return UIMenu(title: "", children: [deleteAction])
//        }
//        return configuration
//    }
    
    /// добавляем действие по свайпу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.removeCartProduct(tableView: tableView, indexPath: indexPath)
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }

    /// был объявлен устаревшим с ios13
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            removeCartProduct(tableView: tableView, indexPath: indexPath)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = cartProducts[indexPath.row]
        guard product.isNotAvailoble == nil else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let productVC = BuilderViewController.buildProductController(product: product)
        navigationController?.pushViewController(productVC, animated: true)
    }
}

// MARK: - CartModelOutput
extension CartController:CartModelOutput {
    func updateOutdatedProducts(products: [ProductItem]) {
        cartProducts = products
        tableView.reloadData()
    }
    
    func updateData(cartProduct: [ProductItem], isAnonymousUser:Bool) {
        isAnonymouslyUser = isAnonymousUser
        cartProducts = cartProduct
        cartModel?.checkingActualCurrentCartProducts(cartProducts: cartProducts)
        tableView.reloadData()
    }
}


// MARK: - CartViewDelegate
extension CartController: CartViewDelegate {
    func didTaplogInButton() {
//        let signInVC = NewSignInViewController()
////        signInVC.cartProducts = cartProducts
//        signInVC.delegate = self
//        signInVC.presentationController?.delegate = self
//        present(signInVC, animated: true, completion: nil)
    }
    
    func didTapCatalogButton() {
        tabBarController?.selectedIndex = 1
    }
}



// MARK: - Trash

//    func updateCartProducts(products: [ProductItem], with models: [String]) -> ([ProductItem], [ProductItem]) {
//        var cartProducts = products
//        // Находим устаревшие продукты, которые есть в models
//        let available = cartProducts.filter { product in
//            guard let model = product.model else { return false }
//            return models.contains(model)
//        }
//
//        // Удаляем устаревшие продукты из cartProducts
//        cartProducts.removeAll { product in
//            guard let model = product.model else { return false }
//            return models.contains(model)
//        }
//
//        /// сравнение для активации addedButton должно быть по id
//        // Обновляем поля продуктов в устаревших продуктах
//        let updatedAvailable = available.map { product -> ProductItem in
//            var dict = product.dictionaryRepresentation
//            dict["category"] = nil
//            dict["strengthIndex"] = nil
//            dict["season"] = nil
//            dict["color"] = nil
//            dict["material"] = nil
//            dict["description"] = nil
//            dict["price"] = nil
//            dict["refImage"] = nil
//            dict["shops"] = ["Нет в наличии"]
//            dict["originalContent"] = nil
//            dict["gender"] = nil
//            dict["isNotAvailoble"] = true
//            return ProductItem(dict: dict)
//        }
//
//        // Добавляем обновленные продукты обратно в cartProducts
//        cartProducts.append(contentsOf: updatedAvailable)
//        return (cartProducts, updatedAvailable)
//    }
