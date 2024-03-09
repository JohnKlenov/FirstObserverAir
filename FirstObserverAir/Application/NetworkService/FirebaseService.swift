//
//  FirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.11.23.
//

import Foundation
import Firebase
//import FirebaseStorageUI

final class FirebaseService {
    
    static let shared = FirebaseService()
    private init() {}
    
    private let db = Firestore.firestore()
    private var handle: AuthStateDidChangeListenerHandle?
    private var listeners: [String:ListenerRegistration] = [:]
    var isOnListenerForCartProduct:Bool?
    
    /// currentUserID - может не неужен рас есть computer property currentUser
    var currentUserID:String?
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    var currentCartProducts:[ProductItem]? {
        didSet {
            print("FirebaseService")
            currentCartProducts?.forEach({ item in
                print("currentCartProducts - \(String(describing: item.model))")
            })
            updateCartProducts()
        }
    }
    var shops:[String:[Shop]] = [:]
    var pinMall: [Pin]?
    
    var currentGender:String {
        return UserDefaults.standard.string(forKey: "gender") ?? "Woman"
    }
    
    func updateCartProducts() {
        NotificationCenter.default.post(name: Notification.Name("UpdateCartProductNotification"), object: nil)
    }
    
    // MARK: - UserDefaults
    
    func setGender(gender:String) {
        UserDefaults.standard.set(gender, forKey: "gender")
    }
    
    
    // MARK: - CloudFirestore
    // если cartProducts пуст то как это может быть nil???
    func fetchCollection(for path: String, sorted: Bool = false, completion: @escaping (Any?, Error?) -> Void) {
        let collection: Query = db.collection(path)
        var query = collection
        if sorted {
            query = collection.order(by: "priorityIndex", descending: true)
        }
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                print("Returned message for analytic FB Crashlytics error FirebaseService")
                return
            }
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
    
    func fetchCollectionFiltered(for path: String, isArrayField: Bool? = nil, keyField: String? = nil, valueField: String, completion: @escaping (Any?, Error?) -> Void) {
        let collection: Query = db.collection(path)
        var query = collection
        
        if let isArrayField = isArrayField, let keyField = keyField {
            if isArrayField {
                query = collection.whereField(keyField, arrayContains: valueField)
            } else {
                query = collection.whereField(keyField, isEqualTo: valueField)
            }
        }
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let querySnapshot = querySnapshot else {
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
    }
    
    ///Если по запросу в коллекции не будет ни одного документа с искомыми полями в models: [String], то querySnapshot будет не nil, но его свойство documents будет пустым массивом.
    func checkingCurrentProducts(models: [String], for path: String, completion: @escaping (Any?, Error?) -> Void) {
        let collection = db.collection(path).whereField("model", in: models)
        
        collection.getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let querySnapshot = querySnapshot else {
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
    }

    func removeListenerForCardProducts() {
        guard let currentUserID = currentUserID else {
            return
        }
        removeListeners(for: currentUserID)
    }
    
    func removeListeners(for path: String) {
        listeners.filter { $0.key == path }
        .forEach {
            $0.value.remove()
            listeners.removeValue(forKey: $0.key)
        }
    }

    /// Cloud Firestore поддерживает сохранение и удаление данных в автономном режиме мы можем не обрабатывать ошибку.
    /// В автономном режиме Cloud Firestore сохраняет все изменения данных в локальном кэше. Когда устройство пользователя восстанавливает подключение к сети, Firestore синхронизирует данные из локального кэша с сервером Firestore. Если во время этого процесса возникают ошибки (например, из-за проблем с безопасностью или квотами), они будут переданы в ваш обработчик ошибок. Таким образом, если возникнут проблемы с интернетом, completion блок моментально не вернет ошибку, но вернет ошибку позже, если при восстановлении соединения не получится сохранить данные. Это обеспечивает более гладкий пользовательский опыт при временных проблемах с подключением к интернету.
    func addItemForCartProduct(item: [String : Any], nameDocument:String) {
        guard let uid = currentUser?.uid else {
            return
        }
        // Создайте ссылку на документ
        let docRef = db.collection("users").document(uid).collection("cartProducts").document(nameDocument)
        // Добавьте данные в Firestore
        ///перезапишет данные с таким же nameDocument
        docRef.setData(item)
    }
    
    func removeItemFromCartProduct(_ productModel: String) {
        guard let uid = currentUser?.uid else {
            return
        }
        // Создайте ссылку на документ
        let docRef = db.collection("users").document(uid).collection("cartProducts").document(productModel)
        
        // Удалите документ из Firestore
        docRef.delete()
    }


    
    // MARK: - Auth
    
    func userIsAnonymously(completionHandler: @escaping (Bool?) -> Void) {
        if let user = currentUser {
            if user.isAnonymous {
                print("user.isAnonymous - true")
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            print("Returned message for analytic FB Crashlytics error FirebaseService")
            completionHandler(nil)
        }
    }
    
    func userListener(currentUser: @escaping (User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("func userListener - \(String(describing: user?.uid))")
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

//        do {
//            try Auth.auth().signOut()
//            print("try Auth.auth().signOut()")
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
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
                self.currentCartProducts = nil
                completion(nil, nil)
            } else {
                ///signOut снова приведет сюда?
                /// ???тогда после firesStart мы не сможем обработать ошибку и останемся без user
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
    
    /// Из CartController + ProfileController мы можем при удачном SignIn, SignUp, SignOut инициализировать вызов fetchCartProducts()
    /// и как возможное следствие получить error
    /// !!! если при SecondFetchListener получаем error то у нас нет listener
    /// как его обрабатывать???
    /// !!! индикатор того что нет listener это currentCartProducts == nil Нет!!!! ведь при addProduct он уже не nill
    /// когда мы переходим на CartController мы можем снова вызыать serviceFB.fetchCartProducts() если currentCartProducts == nil
    
    func fetchCartProducts() {
        fetchData { cartProducts, error, state in
            
            guard let error = error, let state = state else {
                /// firstStartApp
                /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
                    NotificationCenter.default.post(name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
                self.currentCartProducts = cartProducts
                self.isOnListenerForCartProduct = true
                return
            }
        
            guard let _ = self.currentCartProducts else {
                let userInfo: [String: Any] = ["error": error, "enumValue": state]
                /// firstStartApp
                /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
                NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
                return
            }
        }
    }
    
    ///Если путь collectionRef не существует, то код будет работать без ошибок. В Firestore, если вы делаете запрос к коллекции или документу, который не существует, он просто вернет пустой результат, а не ошибку.
    ///В вашем коде, если collectionRef не существует (то есть, нет такой коллекции или документа), то querySnapshot будет пустым, и код просто выполнит completion([], nil, nil), возвращая пустой массив.
    ///Когда вы добавите документ в collectionRef, слушатель обнаружит это изменение и выполнит код внутри блока addSnapshotListener. Это означает, что он снова выполнит запрос, получит новые данные и вернет их через completion.
    
    func fetchData(completion: @escaping ([ProductItem]?, Error?, ListenerErrorState?) -> Void) {
        ///если мы используем этот метод только внутри if let _ = user { .. } можем убрать проверку
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(nil, error, .restartObserveUser)
            return
        }

        removeListenerForCardProducts()
        currentUserID = user.uid
        isOnListenerForCartProduct = nil

        let collectionRef = db.collection("users").document(user.uid).collection("cartProducts")

        /// вы не получите ошибку, если путь к коллекции не существует.
        /// слушатель listener будет работать. Если в какой-то момент вы добавите документ в коллекцию по пути collectionRef, слушатель обнаружит эту изменение и сработает.
        /// если произошла ошибка при  создании listener, то он не будет автоматически восстановлен. В таких случаях вам нужно будет явно повторно установить слушатель.
        let listener = collectionRef.addSnapshotListener { (querySnapshot, error) in

            if let error = error {
                completion(nil, error, .restartFetchCartProducts)
                return
            }
            ///если collectionRef не существует то querySnapshot не будет равен nil
            guard let querySnapshot = querySnapshot else {
                print("QuerySnapshot is nil")
                let error = NSError(domain: "com.yourapp.error", code: 404, userInfo: [NSLocalizedDescriptionKey: "QuerySnapshot is nil."])
                completion(nil, error, .restartFetchCartProducts)
                return
            }

            if querySnapshot.isEmpty {
                print("querySnapshot.isEmpty")
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
        listeners[user.uid] = listener
    }
}






// MARK: - New Implemintation func observeUserAndCardProducts()

//func observeUserAndCardProducts() {
//
//    updateUser { error, state in
//        if let error = error, let state = state  {
//
//            let userInfo: [String: Any] = ["error": error, "enumValue": state]
//            NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
//        } else {
//            self.fetchCartProducts()
//        }
//    }
//}
//
//func updateUser(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
//
//    userListener { user in
//        if let _ = user {
//            self.currentCartProducts = nil
//            completion(nil, nil)
//        } else {
//            ///signOut снова приведет сюда?
//            /// ???тогда после firesStart мы не сможем обработать ошибку и останемся без user
//            self.signInAnonymously { error, state in
//                guard let error = error else { return }
//                completion(error,state)
//            }
//        }
//    }
//}
//
//func fetchCartProducts() {
//    fetchData { cartProducts, error, state in
//
//        guard let error = error, let state = state else {
//            /// firstStartApp
//            /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
//                NotificationCenter.default.post(name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
//            self.currentCartProducts = cartProducts
//            return
//        }
//
//        guard let _ = self.currentCartProducts else {
//            let userInfo: [String: Any] = ["error": error, "enumValue": state]
//            /// firstStartApp
//            /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
//            NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
//            return
//        }
//    }
//}
//
//func fetchData(completion: @escaping ([ProductItem]?, Error?, ListenerErrorState?) -> Void) {
//    ///если мы используем этот метод только внутри if let _ = user { .. } можем убрать проверку
//    guard let user = currentUser else {
//        let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
//        completion(nil, error, .restartObserveUser)
//        return
//    }
//
//    removeListenerForCardProducts()
//    currentUserID = user.uid
//
//    let collectionRef = db.collection("users").document(user.uid).collection("cartProducts")
//
//    let listener = collectionRef.addSnapshotListener { (querySnapshot, error) in
//
//        if let error = error {
//            completion(nil, error, .restartFetchCartProducts)
//            return
//        }
//        ///если collectionRef не существует то querySnapshot не будет равен nil
//        guard let querySnapshot = querySnapshot else {
//            let error = NSError(domain: "com.yourapp.error", code: 404, userInfo: [NSLocalizedDescriptionKey: "QuerySnapshot is nil."])
//            completion(nil, error, .restartFetchCartProducts)
//            return
//        }
//
//        if querySnapshot.isEmpty {
//            completion([], nil, nil)
//            return
//        }
//        var documents = [[String : Any]]()
//
//        for document in querySnapshot.documents {
//            let documentData = document.data()
//            documents.append(documentData)
//        }
//        do {
//            let response = try FetchProductsDataResponse(documents: documents)
//            completion(response.items, nil, nil)
//        } catch {
//            completion(nil, error, .restartFetchCartProducts)
//        }
//    }
//    listeners[user.uid] = listener
//}



// MARK: - Last Implemintation func observeUserAndCardProducts()

//func observeUserAndCardProducts() {
////                do {
////                    try Auth.auth().signOut()
////                    print("try Auth.auth().signOut()")
////                } catch let signOutError as NSError {
////                    print("Error signing out: %@", signOutError)
////                }
//
//
////        / .tooManyRequests(anonimus) + .logIn
//    updateUser { error, state in
//        if let error = error, let state = state  {
//
//            let userInfo: [String: Any] = ["error": error, "enumValue": state]
//            NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
//        } else {
//            self.fetchCartProducts()
//        }
//    }
//}

//func updateUser(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
//
//    userListener { user in
//        if let _ = user {
//            /// !!! currentCartProducts = nil эта строка нужна чтобы иметь барьер при первом запуске listener
//            self.currentCartProducts = nil
//            /// может имеет смысл сдесь removeListenerForCardProducts()
//            /// ведь если мы к примеру signIn, signUp, signOut
//            /// setupCartProducts  может вернуть error и тогда если это не превый старт мы не оповестим об это user
//            /// и останемся без cartProduct + у нас будет висеть observer for cartProduct
//            /// то есть мы можем остаться без cartProduct если у нас setupCartProducts с error или fetchCartProducts с error
//            /// при первом старте эти ошибки обрабатываются через Notification а потом уже нет
//            /// как мы можем обработать? - всегда товара нет в корзине? сможем ли добавить его в корзину если нет места по пути(setupCartProducts error)?
//            ///можно signIn, signUp, signOut оповещать о success как и с первым стартом
//
//            ///мы создали setupCartProducts что бы создать явно путь если его не существует в консоли
//            ///для того видимо, что бы гарантировать что наблюдатель в fetchCartProducts() сработал.
//            /// !!! но есть гипотеза что listener сработает и при не существующем пути и при его появлении вернет данные
//            ///  !!! значит можно убрать setupCartProducts ???
//            self.setupCartProducts { error, state in
//                completion(error, state)
//            }
//        } else {
//            ///signOut снова приведет сюда?
//            /// ???тогда после firesStart мы не сможем обработать ошибку и останемся без user
//            self.signInAnonymously { error, state in
//                guard let error = error else { return }
//                completion(error,state)
//            }
//        }
//    }
//}

//func setupCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
//    guard let user = currentUser else {
//        let error = NSError(domain: "com.FirstObserverAir.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
//        completion(error, .restartObserveUser)
//        return
//    }
//
//    let docRef = db.collection("users").document(user.uid).collection("cartProducts").document(user.uid)
//
//    docRef.getDocument { (document, error) in
//        guard error == nil else {
//            completion(error, .restartObserveUser)
//            return
//        }
//
//        /// document.exists - если по ссылки нет документа(пустые поля) вернет false даже если там лежит коллекция
//        if let document = document, document.exists {
//            completion(nil, nil)
//        } else {
//            self.addEmptyCartProducts { error, state in
//                completion(error,state)
//            }
//        }
//    }
//}

//func fetchCartProducts() {
//    fetchData { cartProducts, error, state in
//
//        guard let error = error, let state = state else {
//            /// firstStartApp
//            /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
//                NotificationCenter.default.post(name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
//            self.currentCartProducts = cartProducts
//            return
//        }
//
//        guard let _ = self.currentCartProducts else {
//            let userInfo: [String: Any] = ["error": error, "enumValue": state]
//            /// firstStartApp
//            /// этот NotificationCenter.default.post работает один раз для HomeController потом после успеха NotificationCenter.default.removeObserver
//            NotificationCenter.default.post(name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil, userInfo: userInfo)
//            return
//        }
//    }
//}

/////Если путь collectionRef не существует, то код будет работать без ошибок. В Firestore, если вы делаете запрос к коллекции или документу, который не существует, он просто вернет пустой результат, а не ошибку.
/////В вашем коде, если collectionRef не существует (то есть, нет такой коллекции или документа), то querySnapshot будет пустым, и код просто выполнит completion([], nil, nil), возвращая пустой массив.
/////Когда вы добавите документ в collectionRef, слушатель обнаружит это изменение и выполнит код внутри блока addSnapshotListener. Это означает, что он снова выполнит запрос, получит новые данные и вернет их через completion.
//
//func fetchData(completion: @escaping ([ProductItem]?, Error?, ListenerErrorState?) -> Void) {
//    ///если мы используем этот метод только внутри if let _ = user { .. } можем убрать проверку
//    guard let user = currentUser else {
//        let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
//        completion(nil, error, .restartObserveUser)
//        return
//    }
//
//    removeListenerForCardProducts()
//    currentUserID = user.uid
//
//    let collectionRef = db.collection("users").document(user.uid).collection("cartProducts")
//
//    ///вот это для теста нужно будет убрать
//    let quary = collectionRef.order(by: "priorityIndex", descending: false)
//
//    /// если в момент прослушивание пропадет инет придет error и те данные которые мы пропусти
//    /// после подключения инета мы не получим
//    /// получим только те данные которые придут после нового прослушивание
//
//    /// ???  вы не получите ошибку, если путь к коллекции не существует.
//    /// ???слушатель listener будет работать. Если в какой-то момент вы добавите документ в коллекцию по пути collectionRef, слушатель обнаружит эту изменение и сработает.
//    /// если произошла ошибка при  создании listener, то он не будет автоматически восстановлен. В таких случаях вам нужно будет явно повторно установить слушатель.
//    let listener = quary.addSnapshotListener { (querySnapshot, error) in
//
//        if let error = error {
//            completion(nil, error, .restartFetchCartProducts)
//            return
//        }
//        ///если collectionRef не существует то querySnapshot не будет равен nil
//        guard let querySnapshot = querySnapshot else {
//            let error = NSError(domain: "com.yourapp.error", code: 404, userInfo: [NSLocalizedDescriptionKey: "QuerySnapshot is nil."])
//            completion(nil, error, .restartFetchCartProducts)
//            return
//        }
//
//        if querySnapshot.isEmpty {
//            completion([], nil, nil)
//            return
//        }
//        var documents = [[String : Any]]()
//
//        for document in querySnapshot.documents {
//            let documentData = document.data()
//            documents.append(documentData)
//        }
//        do {
//            let response = try FetchProductsDataResponse(documents: documents)
//            completion(response.items, nil, nil)
//        } catch {
//            completion(nil, error, .restartFetchCartProducts)
//        }
//    }
//    listeners[user.uid] = listener
//}
//
//func addEmptyCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
//    guard let user = currentUser else {
//        let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
//        completion(error, .restartObserveUser)
//        return
//    }
//
//    let userDocumentRef = db.collection("users").document(user.uid).collection("cartProducts").document(user.uid)
//
//    userDocumentRef.setData(["uid": user.uid]) { error in
//        if let error = error {
//            completion(error, .restartObserveUser)
//        } else {
//            completion(nil, nil)
//        }
//    }
//}



// MARK: - Trash


//    func addItemForCartProduct(item: [String : Any], nameDocument:String, completion: @escaping (Error?) -> Void) {
//
//        guard let uid = currentUser?.uid else {
//            let error = NSError(domain: "com.FirstObserverAir.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
//            completion(error)
//            return
//        }
//        // Создайте ссылку на документ
//        let docRef = db.collection("users").document(uid).collection("cartProducts").document(nameDocument)
//
//        // Добавьте данные в Firestore
//        docRef.setData(item) { error in
//            completion(error)
//        }
//    }

//    func fetchCollectionSortedByIndex(for path: String, completion: @escaping (Any?, Error?) -> Void) {
//        let collection = db.collection(path)
//        let quary = collection.order(by: "priorityIndex", descending: true)
//
//        let listener = quary.addSnapshotListener { (querySnapshot, error) in
//
//            if let error = error {
//                completion(nil, error)
//                print("Returned message for analytic FB Crashlytics error")
//                return
//            }
//            // !querySnapshot.isEmpty ??????????
//            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
//                completion(nil, error)
//                return
//            }
//            var documents = [[String : Any]]()
//
//            for document in querySnapshot.documents {
//                let documentData = document.data()
//                documents.append(documentData)
//            }
//            completion(documents, nil)
//        }
//        listeners[path] = listener
//    }
    
//    func fetchCollection(for path: String, completion: @escaping (Any?, Error?) -> Void) {
//        let collection = db.collection(path)
//        let listener = collection.addSnapshotListener { (querySnapshot, error) in
//
//            if let error = error {
//                completion(nil, error)
//                print("Returned message for analytic FB Crashlytics error")
//                return
//            }
//            // !querySnapshot.isEmpty ??????????
//            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
//                completion(nil, error)
//                return
//            }
//            var documents = [[String : Any]]()
//
//            for document in querySnapshot.documents {
//                let documentData = document.data()
//                documents.append(documentData)
//            }
//            completion(documents, nil)
//        }
//        listeners[path] = listener
//    }

//
//    func createItem(malls: [PreviewSection]? = nil, shops: [PreviewSection]? = nil, products: [ProductItem]? = nil) -> [Item] {
//
//        var items = [Item]()
//        if let malls = malls {
//            items = malls.map {Item(mall: $0, shop: nil, popularProduct: nil)}
//        } else if let shops = shops {
//            items = shops.map {Item(mall: nil, shop: $0, popularProduct: nil)}
//        } else if let products = products {
//            items = products.map {Item(mall: nil, shop: nil, popularProduct: $0)}
//        }
//        return items
//    }

//    func fetchCartProducts(completion: @escaping ([ProductItem]?) -> Void) {
//
//        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
//
//        fetchCollection(for: path, sorted: true) { documents, error in
//            guard let documents = documents else {
//                completion(nil)
//                return
//            }
//
//            do {
//                let response = try FetchProductsDataResponse(documents: documents)
//                completion(response.items)
//            } catch {
//                //                ManagerFB.shared.CrashlyticsMethod
//                completion(nil)
//            }
//
//        }
//    }
