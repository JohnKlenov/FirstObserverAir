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

/// need implimentation two strategy
/// First viewWillAppear - if currentCartProducts == nil that currentCartProducts = [] and fetchCartProducts() (у нас natificationPost в didSet currentCartProducts для dissmiss SignInController мы observerNatificatinAdd в viewWillAppear)
/// Second для dissmiss SignInController 
///
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
        print("CartController viewWillAppear")
        cartModel?.fetchData()
        resetBadgeValue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CartController viewWillDisappear")
        removeObserverNotification()
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

    func reloadData(products:[ProductItem], isAnonymous:Bool) {
        isAnonymouslyUser = isAnonymous
        cartProducts = products
        tableView.reloadData()
    }
    
    func addObserverNotification() {
        /// !!! Если вы дважды вызовете addObserver, то ваш селектор будет вызван дважды при каждом уведомлении
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateCartProductNotification(_:)), name: NSNotification.Name("UpdateCartProductNotification"), object: nil)
    }
    
    func removeObserverNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UpdateCartProductNotification"), object: nil)
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
    
    /// добавляем действие по свайпу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.removeObserverNotification()
            self.removeCartProduct(tableView: tableView, indexPath: indexPath)
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }

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
        reloadData(products: cartProduct, isAnonymous: isAnonymousUser)
        if let cartModel = cartModel, cartModel.checkListenerStatus() {
            cartModel.checkingActualCurrentCartProducts(cartProducts: cartProducts)
        } else {
            print("cartModel?.restartFetchCartProducts()")
            ///addObserverNotification() ???
            cartModel?.restartFetchCartProducts()
        }
    }
}

// MARK: - Selectors
private extension CartController {
    @objc func handleUpdateCartProductNotification(_ notification: NSNotification) {
        print("handleUpdateCartProductNotification")
        removeObserverNotification()
        cartModel?.fetchData()
    }
}

// MARK: - CartViewDelegate
extension CartController: CartViewDelegate {
    func didTaplogInButton() {
        let signInVC = NewSignInViewController()
//        signInVC.cartProducts = cartProducts
        signInVC.delegate = self
        signInVC.presentationController?.delegate = self
        present(signInVC, animated: true, completion: nil)
        removeObserverNotification()
        addObserverNotification()
    }
    
    func didTapCatalogButton() {
        tabBarController?.selectedIndex = 1
    }
}

extension CartController: SignInViewControllerDelegate {
    func userIsPermanent() {
        reloadData(products: [], isAnonymous: false)
        print("userIsPermanent()")
        // refactor getCartObservser
//        managerFB.removeObserverForCartProductsUser()
        
//        configureActivityView() ?????
        
//        getData` без активного подключения к сети вернет error
        // ref.observe(.value) or think about it
        
        
//        managerFB.getCartProductOnce { cartProducts in
//            self.managerFB.userIsAnonymously { [weak self] (isAnonymously) in
//                self?.isAnonymouslyUser = isAnonymously
//                self?.cartProducts = cartProducts
////                self?.activityView.stopAnimating() ?????
////                self?.activityView.removeFromSuperview() ?????
//                self?.tableView.reloadData()
//            }
//        }
    }
}





// MARK: - Feature
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
