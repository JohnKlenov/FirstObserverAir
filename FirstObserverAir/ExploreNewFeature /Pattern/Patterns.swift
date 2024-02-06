//
//  Patterns.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 6.02.24.
//

import Foundation


// MARK: Strategy



//// Протокол, определяющий общий интерфейс стратегий для сетевых запросов
//protocol NetworkRequestStrategy {
//    func performRequest(url: URL, completion: @escaping (Data?, Error?) -> Void)
//}
//
//// Конкретная стратегия - выполняет GET-запросы
//class GetRequestStrategy: NetworkRequestStrategy {
//    func performRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
//        // Реализация GET-запроса с использованием URLSession или другой библиотеки ввода/вывода данных
//        // ...
//        // В результате выполнения запроса вызываем completion с полученными данными или ошибкой
//        completion(data, error)
//    }
//}
//
//// Конкретная стратегия - выполняет POST-запросы
//class PostRequestStrategy: NetworkRequestStrategy {
//    func performRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
//        // Реализация POST-запроса с использованием URLSession или другой библиотеки ввода/вывода данных
//        // ...
//        // В результате выполнения запроса вызываем completion с полученными данными или ошибкой
//        completion(data, error)
//    }
//}
//
//// Контекст, использующий выбранную стратегию для выполнения сетевого запроса
//class NetworkClient {
//
//    private var strategy: NetworkRequestStrategy
//
//    init(strategy: NetworkRequestStrategy) {
//        self.strategy = strategy
//    }
//
//    func performRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
//        // Вызываем метод performRequest выбранной стратегии
//        strategy.performRequest(url: url, completion: completion)
//    }
//}
//
//// Использование паттерна стратегия для выполнения сетевых запросов
//let getRequestStrategy = GetRequestStrategy()
//let postRequestStrategy = PostRequestStrategy()
//
//let networkClientForGet = NetworkClient(strategy: getRequestStrategy)
//networkClientForGet.performRequest(url: someURL) { data, error in
//    // Обработка полученных данных или ошибки после выполнения GET-запроса
//}
//
//let networkClientForPost = NetworkClient(strategy: postRequestStrategy)
//networkClientForPost.performRequest(url: someURL) { data, error in
//    // Обработка полученных данных или ошибки после выполнения POST-запроса
//}



//// Протокол стратегии для чтения данных из Firestore
//protocol ReadStrategy {
//    func readData(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void)
//}
//
//// Конкретная стратегия для чтения всех документов из коллекции
//class ReadAllDocumentsStrategy: ReadStrategy {
//    func readData(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        db.collection(collection).getDocuments { (snapshot, error) in
//            completion(snapshot?.documents, error)
//        }
//    }
//}
//
//// Конкретная стратегия для чтения документа по идентификатору
//class ReadDocumentByIdStrategy: ReadStrategy {
//    func readData(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        // Ваш код для получения документа по идентификатору
//
//        // Пример:
//        let documentId = "your-document-id"
//
//        db.collection(collection).document(documentId).getDocument { (snapshot, error) in
//            var documents: [DocumentSnapshot]? = nil
//
//            if let snapshot = snapshot {
//                documents = [snapshot]
//            }
//
//            completion(documents, error)
//        }
//    }
//}
//
//// Клиентский класс, использующий выбранную стратегию чтения данных из Firestore
//class FirestoreClient {
//    private let readStrategy: ReadStrategy
//
//    init(readStrategy: ReadStrategy) {
//        self.readStrategy = readStrategy
//    }
//
//    func readData(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        readStrategy.readData(from: collection, completion: completion)
//    }
//}
//
//// Использование паттерна стратегия при работе с Firestore
//let readAllDocumentsStrategy = ReadAllDocumentsStrategy()
//let readDocumentByIdStrategy = ReadDocumentByIdStrategy()
//
//let firestoreClientForReadingAllDocuments = FirestoreClient(readStrategy: readAllDocumentsStrategy)
//firestoreClientForReadingAllDocuments.readData(from: "your-collection") { documents, error in
//    // Обработка полученных документов или ошибки после чтения всех документов из коллекции
//}
//
//let firestoreClientForReadingDocumentById = FirestoreClient(readStrategy: readDocumentByIdStrategy)
//firestoreClientForReadingDocumentById.readData(from: "your-collection") { documents, error in
//    // Обработка полученного документа или ошибки после чтения документа по идентификатору
//}

//Использование паттерна стратегия при работе с Firebase Cloud Firestore и архитектуре MVC может иметь следующие преимущества:
//
//1. Разделение ответственностей: Паттерн стратегия позволяет выделить конкретные операции чтения данных в отдельные классы-стратегии, что помогает разделить логику работы с базой данных от контроллера или модели.
//
//2. Гибкость и расширяемость: Стратегии могут быть легко добавлены или изменены без необходимости менять основной код контроллера или модели. Это обеспечивает гибкость и возможность расширения функциональности без большого количества изменений.
//
//3. Тестируемость: Использование стратегий упрощает юнит-тестирование, поскольку каждая стратегия может быть протестирована независимо от других частей системы.
//
//Пример использования паттерна стратегия в архитектуре MVC для работы с Firebase Cloud Firestore:
//
//1. Модель (Model): Модель отвечает за доступ к данным и бизнес-логику приложения. В данном случае, модель будет содержать методы для чтения данных из Firestore, которые будут вызывать соответствующую стратегию.
//
//swift
//protocol FirestoreReadingStrategy {
//    func readData(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void)
//}
//
//class FirestoreModel {
//    private let firestoreClient: FirestoreClientProtocol
//
//    init(firestoreClient: FirestoreClientProtocol) {
//        self.firestoreClient = firestoreClient
//    }
//
//    func readAllDocuments(from collection: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        firestoreClient.readData(from: collection, completion: completion)
//    }
//}
//
//// Пример использования модели:
//let readAllDocumentsStrategy = ReadAllDocumentsStrategy()
//let firestoreClientForReadingAllDocuments = FirestoreClient(readStrategy: readAllDocumentsStrategy)
//let model = FirestoreModel(firestoreClient: firestoreClientForReadingAllDocuments)
//
//model.readAllDocuments(from: "your-collection") { documents, error in
//    // Обработка полученных документов или ошибки после чтения всех документов из коллекции
//}
//
//
//2. Контроллер (Controller): Контроллер обрабатывает пользовательский ввод и управляет обновлением модели и представления. В данном случае, контроллер будет вызывать методы чтения данных из Firestore через модель.
//
//swift
//class ViewController: UIViewController {
//    private var model: FirestoreModel?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let readDocumentByIdStrategy = ReadDocumentByIdStrategy()
//        let firestoreClientForReadingDocumentById = FirestoreClient(readStrategy: readDocumentByIdStrategy)
//        model = FirestoreModel(firestoreClient: firestoreClientForReadingDocumentById)
//
//        // Вызов метода чтения данных из Firestore через модель
//        model?.readAllDocuments(from: "your-collection") { documents, error in
//            // Обработка полученных документов или ошибки после чтения всех документов из коллекции
//        }
//    }
//}
//
//
//В данном примере контроллер ViewController создает экземпляр модели FirestoreModel с выбранной стратегией чтения данных, а затем вызывает методы чтения данных через эту модель.






// MARK: - Factory method


//Один из примеров использования фабричного паттерна в Swift с UIKit может быть создание различных типов кнопок.
//
//Вместо явного создания экземпляра каждого типа кнопки (например, обычной кнопки, кнопки с изображением, округлой кнопки), вы можете использовать фабрику для создания объекта нужного типа на основе переданных параметров.
//
//Ниже приведен пример кода:
//
//swift
//import UIKit
//
//// Протокол для определения общего интерфейса всех кнопок
//protocol Button {
//    func setTitle(_ title: String?, for state: UIControl.State)
//}
//
//// Конкретная реализация обычной UIButton
//class DefaultButton: UIButton, Button {}
//
//// Конкретная реализация UIButton с изображением
//class ImageButton: UIButton, Button {
//    func setImage(_ image: UIImage?, for state: UIControl.State) {
//        // код для установки изображения
//    }
//}
//
//// Конкретная реализация округлой UIButton
//class RoundButton: UIButton, Button {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = bounds.height / 2
//    }
//}
//
//// Фабрика для создания различных типов кнопок
//struct ButtonFactory {
//    static func createButton(type: ButtonType) -> Button {
//        switch type {
//        case .default:
//            return DefaultButton()
//        case .image:
//            return ImageButton()
//        case .round:
//            return RoundButton()
//        }
//    }
//}
//
//// Возможные типы кнопок
//enum ButtonType {
//    case default, image, round
//}
//
//// Пример использования фабрики
//let defaultButton = ButtonFactory.createButton(type: .default)
//defaultButton.setTitle("Default", for: .normal)
//
//let imageButton = ButtonFactory.createButton(type: .image)
//imageButton.setTitle("Image", for: .normal)
//imageButton.setImage(UIImage(named: "icon"), for: .normal)
//
//let roundButton = ButtonFactory.createButton(type: .round)
//roundButton.setTitle("Round", for: .normal)
//
//
//В этом примере фабрика ButtonFactory отвечает за создание различных типов кнопок в зависимости от переданного параметра type. Каждый тип кнопки реализует общий интерфейс Button, что позволяет им работать с ним одинаковым образом.



//Вот пример паттерна "Фабричный метод" в Swift, используя UIKit:
//
//swift
//import UIKit
//
//// Протокол для создания различных типов представлений
//protocol ViewFactory {
//    func createView() -> UIView
//}
//
//// Конкретная реализация фабрики для создания кнопок
//struct ButtonFactory: ViewFactory {
//    func createView() -> UIView {
//        let button = UIButton()
//        button.setTitle("Button", for: .normal)
//        button.backgroundColor = .blue
//        button.tintColor = .white
//        return button
//    }
//}
//
//// Конкретная реализация фабрики для создания меток
//struct LabelFactory: ViewFactory {
//    func createView() -> UIView {
//        let label = UILabel()
//        label.text = "Label"
//        label.textColor = .black
//        return label
//    }
//}
//
//// Пример использования фабрик для создания различных представлений
//let buttonFactory = ButtonFactory()
//let buttonView = buttonFactory.createView()
//
//let labelFactory = LabelFactory()
//let labelView = labelFactory.createView()
//
//
//В этом примере есть две конкретные реализации ButtonFactory и LabelFactory, которые реализуют общий протокол ViewFactory. Каждая фабрика имеет свой метод createView, который создает соответствующее представление (кнопку или метку) и настраивает его параметры. Затем можно использовать эти фабрики для создания нужных представлений (buttonView и labelView) с помощью вызова метода createView().
