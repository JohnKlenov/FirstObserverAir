//
//  FirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.11.23.
//

import Foundation
import Firebase

final class FirebaseService {
    
    static let shared = FirebaseService()
    private init() {}
    
    private let db = Firestore.firestore()
    private var handle: AuthStateDidChangeListenerHandle?
    private var listeners: [String:ListenerRegistration] = [:]
    
    var currentUserID:String?
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    var currentCartProducts:[ProductItem]? {
        didSet {
            updateCartProducts()
        }
    }
    var shops:[String:[Shop]]?
    var pinMall: [Pin]?
   
    
    var currentGender:String = {
        return UserDefaults.standard.string(forKey: "gender") ?? "Woman"
    }()
    
    
    // MARK: - helper methods
    
    func createItem(malls: [PreviewSection]? = nil, shops: [PreviewSection]? = nil, products: [ProductItem]? = nil) -> [Item] {

        var items = [Item]()
        if let malls = malls {
            items = malls.map {Item(mall: $0, shop: nil, popularProduct: nil)}
        } else if let shops = shops {
            items = shops.map {Item(mall: nil, shop: $0, popularProduct: nil)}
        } else if let products = products {
            items = products.map {Item(mall: nil, shop: nil, popularProduct: $0)}
        }
        return items
    }
    
    func updateCartProducts() {
        NotificationCenter.default.post(name: Notification.Name("UpdateCartProducts"), object: nil)
    }
    
    // MARK: - UserDefaults
    
    func setGender(gender:String) {
        UserDefaults.standard.set(gender, forKey: "gender")
    }
    
    
    // MARK: - CloudFirestore
    // если cartProducts пуст то как это может быть nil???
    func fetchStartCollection(for path: String, completion: @escaping (Any?, Error?) -> Void) {
        let collection = db.collection(path)
        let quary = collection.order(by: "priorityIndex", descending: false)
        
        let listener = quary.addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                completion(nil, error)
                print("Returned message for analytic FB Crashlytics error")
                return
            }
            // !querySnapshot.isEmpty ??????????
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            var documents = [[String : Any]]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                documents.append(documentData)
            }
            completion(documents, nil)
        }
        listeners[path] = listener
    }
    
    func fetchCartProducts(completion: @escaping ([ProductItem]?) -> Void) {
        
        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
        
        fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items)
            } catch {
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
    func removeListenerForCardProducts() {
        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
        removeListeners(for: path)
    }
    
    func removeListeners(for path: String) {
        listeners.filter { $0.key == path }
        .forEach { $0.value.remove() }
    }
    
    
    // MARK: - Auth
    
    func userIsAnonymously(completionHandler: @escaping (Bool?) -> Void) {
        if let user = currentUser {
            if user.isAnonymous {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func userListener(currentUser: @escaping (User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            currentUser(user)
        }
    }
    
    func removeStateDidChangeListener() {
                if let handle = handle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
    }
    
    
    // MARK: UserListener + FetchCartProducts

    /// оповещаем  VCs(Home, Cart, Profile) (через NotificationCenter) об ощибках при получении user и cartProducts
    /// оповещаем  model homeVC(через NotificationCenter) о том что мы получили user и его cartProducts и инициализируем получение следующих данных
    
    func observeUserAndCardProducts() {
        /// .tooManyRequests(anonimus) + .logIn
        updateUser { error, state in
            
            if let error = error, let state = state  {
                
                    let userInfo: [String: Any] = ["error": error, "enumValue": state]
                    NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
            } else {
                self.fetchCartProducts()
            }
        }
    }
    
    func updateUser(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
    
        userListener { user in
            if let _ = user {
                // можем делать его пустым currentCartProducts = []
                // потому что его состояние контролируется.
                self.currentCartProducts = nil
                self.setupCartProducts { error, state in
                    completion(error, state)
                }
            } else {
                self.signInAnonymously { error, state in
                    guard let error = error else { return }
                    completion(error,state)
                }
            }
        }
    }
    
    func signInAnonymously(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let error = error else { return }
            completion(error, .restartObserveUser)
        }
    }
    
    func setupCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(error, .restartObserveUser)
            return
        }
        
        let path = "usersAccount/\(user.uid)"
        let docRef = Firestore.firestore().document(path)
        
        docRef.getDocument { (document, error) in
            
            guard error == nil else {
                completion(error, .restartObserveUser)
                return
            }
            
            if let document = document, document.exists {
                completion(nil, nil)
            } else {
                self.addEmptyCartProducts { error, state in
                    completion(error,state)
                }
            }
        }
    }
    
    func fetchCartProducts() {
        fetchData { cartProducts, error, state in
            guard let error = error, let state = state else {
            
                    NotificationCenter.default.post(name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
                self.currentCartProducts = cartProducts
                return
            }
        
            guard let _ = self.currentCartProducts else {
                let userInfo: [String: Any] = ["error": error, "enumValue": state]
                NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
                return
            }
        }
    }
    
    func fetchData(completion: @escaping ([ProductItem]?, Error?, ListenerErrorState?) -> Void) {
        
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(nil, error, .restartObserveUser)
            return
        }
        
        removeListenerForCardProducts()
        currentUserID = user.uid
        
        let path = "usersAccount/\(user.uid)/cartProducts"
        
        let collection = db.collection(path)
        let quary = collection.order(by: "priorityIndex", descending: false)
        
        /// если в момент прослушивание пропадет инет придет error и те данные которые мы пропусти
        /// после подключения инета мы не получим
        /// получим только те данные которые придут после нового прослушивание
        let listener = quary.addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                completion(nil, error, .restartFetchCartProducts)
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(nil, error, .restartFetchCartProducts)
                return
            }
            
            if querySnapshot.isEmpty {
                completion([], nil, nil)
                return
            }
            var documents = [[String : Any]]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                documents.append(documentData)
            }
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items, nil, nil)
            } catch {
                completion(nil, error, .restartFetchCartProducts)
            }
        }
        listeners[path] = listener
    }
    
    func addEmptyCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(error, .restartObserveUser)
            return
        }
        let usersCollection = Firestore.firestore().collection("usersAccount")
        let userDocument = usersCollection.document(user.uid)
        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
            if error != nil {
                completion(error, .restartObserveUser)
            } else {
                completion(nil, nil)
            }
        }
    }
    
}


struct FetchProductsDataResponse {
    typealias JSON = [String : Any]
    let items:[ProductItem]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
//        HomeScreenCloudFirestoreService.
        var items = [ProductItem]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ProductItem(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

