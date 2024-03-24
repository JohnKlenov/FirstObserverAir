//
//  SignInController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.02.24.
//

import UIKit

// NewSignInViewController BOSS he says Intern(NewProfileViewController) to do
protocol DidChangeUserDelegate : AnyObject {
    func userChanged(isFromAnon:Bool)
}

// class final - это ускоряет диспетчеризация от него никто не будет в дальнейшем наследоваться.
final class NewSignInViewController: UIViewController {
    
    let exitTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.backgroundColor = R.Colors.opaqueSeparator
        view.layer.cornerRadius = 2
        return view
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.AuthControllers.SignIn.signInLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    var emailTextField: AuthTextField!
    var passwordTextField: AuthTextField!
    
    var separatorEmailView: UIView!
    var separatorPasswordView: UIView!
    
    var authEmailStackView: UIStackView!
    var authPasswordStackView: UIStackView!
    
    var warningTextEmail: UILabel!
    var warningTextPassword: UILabel!
    
    let authStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let signInButton: SignInUpProcessButton = SignInUpProcessButton(titleButtonProcess: R.Strings.AuthControllers.SignIn.signInButtonProcess, titleButtonStart: R.Strings.AuthControllers.SignIn.signInButtonStart)
    
    let signUpButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.AuthControllers.SignIn.signUpButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = R.Colors.systemFill
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    let forgotPasswordButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.AuthControllers.SignIn.forgotPasswordButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .mini
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private let eyeButton = EyeButton()
    private var isPrivateEye = true
    
    var isEmailValid = false
    var isPasswordValid = false
    
    private var signInModel: SignInModelInput?
    weak var delegate:DidChangeUserDelegate?
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("Deinit SignInController")
    }
}


// MARK: - Setting Views
// Что бы не делать все методы private мы сделаем private extension.
private extension NewSignInViewController {
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        signInModel = SignInFirebaseService()
        assemblyStackView()
        addActions()
        setupStackView()
        addSubViews()
        setupLayout()
        isEnabledSignInButton(enabled: false)
    }
}


// MARK: - Setting
private extension NewSignInViewController {
    
    func assemblyStackView() {
        (authEmailStackView, emailTextField, separatorEmailView, warningTextEmail) = BuilderStackView.build(title: R.Strings.AuthControllers.SignIn.emailLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignIn.placeholderEmailTextField, textContentType: .emailAddress, isSecureTextEntry: false, eyeButton: nil, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.emailTextField)
        }, delegate: self)

        (authPasswordStackView, passwordTextField, separatorPasswordView, warningTextPassword) = BuilderStackView.build(title: R.Strings.AuthControllers.SignIn.passwordLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignIn.placeholderPasswordTextField, textContentType: .password, isSecureTextEntry: true, eyeButton: eyeButton, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.passwordTextField)
       }, delegate: self)

    }
    
    func addSubViews() {
        view.addGestureRecognizer(tapRootViewGestureRecognizer)
        view.addSubview(exitTopView)
        view.addSubview(signInLabel)
        view.addSubview(authStackView)
        view.addSubview(signUpStackView)
        view.addSubview(signInButton)
    }
    
    func addActions() {
        eyeButton.addTarget(self, action: #selector(displayBookMarks ), for: .touchUpInside)
        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureDidTap))
        signInButton.addTarget(self, action: #selector(didTapSignInButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton(_:)), for: .touchUpInside)
    }
    
    func setupStackView() {
        [signUpButton, forgotPasswordButton].forEach { signUpStackView.addArrangedSubview($0)}
        [authEmailStackView, authPasswordStackView].forEach { authStackView.addArrangedSubview($0)}
    }
    
    func isEnabledSignInButton(enabled: Bool) {
        
        if enabled {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
    }
}


// MARK: - Layout
private extension NewSignInViewController {
    func setupLayout() {
        
        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        signInLabel.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 35).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        authStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20).isActive = true
        authStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        authStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        authStackView.bottomAnchor.constraint(equalTo: signUpStackView.topAnchor, constant: -20).isActive = true
        
        signUpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Actions
private extension NewSignInViewController {
    
    func textFieldHandler(_ textField: UITextField?) {
        guard let textField = textField else { return }
        
        switch textField {
        case emailTextField:
            isEmailValid = Validators.isValidEmail(emailTextField.text ?? "")
            warningTextEmail.text = isEmailValid ? "" : "Invalid email format"
            separatorEmailView.backgroundColor = isEmailValid ? R.Colors.separator : R.Colors.systemRed
        case passwordTextField:
            let passwordValidationResult = Validators.validatePassword(passwordTextField.text ?? "")
            isPasswordValid = passwordValidationResult == "success"
            if isPasswordValid {
                separatorPasswordView.backgroundColor = R.Colors.separator
                warningTextPassword.text = ""
            } else {
                separatorPasswordView.backgroundColor = R.Colors.systemRed
                warningTextPassword.text = passwordValidationResult.replacingOccurrences(of: "failed: ", with: "")
            }
        default:
            break
        }
        isEnabledSignInButton(enabled: isEmailValid && isPasswordValid)
    }


    
    @objc private func displayBookMarks() {
        let imageName = isPrivateEye ? R.Strings.AuthControllers.SignIn.imageSystemNameEye : R.Strings.AuthControllers.SignIn.imageSystemNameEyeSlash
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        isPrivateEye.toggle()
    }
    
    @objc func gestureDidTap() {
        view.endEditing(true)
    }
    
    @objc func didTapSignInButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        signInButton.isProcessActive = true
        signInModel?.signIn(email: email, password: password, completion: { [weak self] (state, isAnon) in
            self?.signInButton.isProcessActive = false
            switch state {
            case .success:
                self?.isEnabledSignInButton(enabled: false)
                self?.delegate?.userChanged(isFromAnon: false)
                self?.signInAlert(title: "Вход выполнен успешно", message: "Поздравляем! Вы успешно вошли в систему.") { [weak self] in
                    self?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            case .networkError(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .userNotFound(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .wrongPassword(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .tooManyRequests(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .invalidCredential(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .missingEmail(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .invalidEmail(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            case .userDisabled(let errorMessage):
                self?.signInAlert(title: "Ошибка", message: errorMessage)
            default:
                self?.signInAlert(title: "Ошибка", message: "Что то пошло не так! Попробуйте еще раз!")
            }
        })
    }
    
    @objc func didTapSignUpButton(_ sender: UIButton) {
        
                let signUpVC = NewSignUpViewController()
                signUpVC.delegate = self
                present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func didTapForgotPasswordButton(_ sender: UIButton) {
        
        sendPasswordResetAlert(title: "Сброс пароля", message: "Введите адрес электронной почты, связанный с вашей учетной записью. Мы отправим вам ссылку для сброса пароля.", placeholder: "Введите email") {  [weak self] email in
            self?.signInModel?.sendPasswordReset(email: email, completion: { [weak self] state in
                switch state {
                case .success:
                    self?.signInAlert(title: "Сброс пароля", message: "Запрос на сброс пароля успешно отправлен. Пожалуйста, проверьте свою электронную почту и следуйте инструкциям для сброса пароля.")
                case .networkError(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                case .userNotFound(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                case .tooManyRequests(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                case .invalidRecipientEmail(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                case .invalidEmail(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                case .userDisabled(let errorMessage):
                    self?.signInAlert(title: "Ошибка", message: errorMessage)
                default:
                    self?.signInAlert(title: "Ошибка", message: "Что то пошло не так! Попробуйте еще раз!")
                }
            })
        }
    }
}

// MARK: - UITextFieldDelegate
extension NewSignInViewController: UITextFieldDelegate {
    
    ///Если активно emailTextField, то фокус ввода переходит к passwordTextField с помощью метода becomeFirstResponder(). Это означает, что после ввода адреса электронной почты, когда пользователь нажимает “Возврат”, клавиатура автоматически переходит к полю ввода пароля.
    ///Если активно passwordTextField или любое другое текстовое поле (обрабатывается в default), то клавиатура скрывается с помощью метода resignFirstResponder(). Это означает, что после ввода пароля, когда пользователь нажимает “Возврат”, клавиатура скрывается.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {return}
        eyeButton.isEnabled = !text.isEmpty
    }
}


// MARK: - DidChangeUserDelegate
extension NewSignInViewController: DidChangeUserDelegate {
    func userChanged(isFromAnon: Bool) {
        delegate?.userChanged(isFromAnon: isFromAnon)
    }
}



// MARK: - Alert
private extension NewSignInViewController {
    
    ///= {} означает, что по умолчанию для этого замыкания установлено пустое замыкание, то есть если замыкание не предоставлено при вызове функции, будет использоваться пустое замыкание.
    func signInAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "ok", style: .default) { (_) in
            completion()
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendPasswordResetAlert(title:String, message:String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertOK = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textField = alertController.textFields?.first
            guard let text = textField?.text else {return}
            completionHandler(text)
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            ///
        }
        
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        present(alertController, animated: true, completion: nil)
    }
}




// MARK: - Trash

//rules_version = '2';
//service cloud.firestore {
//  match /databases/{database}/documents {
//    // Allow only authenticated users
//    match /{document=**} {
//      allow read, write: if request.auth != null;
//    }
//  }
//}


//cloud firestore rules_version = '2';
//
//service cloud.firestore {
// match /databases/{database}/documents {
//   // Разрешаем чтение любых данных
//   match /{document=**} {
//     allow read: if true;
//   }
//
//   // Разрешаем запись только в документы, где идентификатор пользователя совпадает
//   match /users/{userId}/{document=**} {
//     allow write: if request.auth != null && request.auth.uid == userId;
//   }
// }
//}
//
//service cloud.firestore {
//  match /databases/{database}/documents {
//    // Разрешаем чтение любых данных
//    match /{document=**} {
//      allow read: if true;
//    }
//
//    // Разрешаем запись только в документы, где идентификатор пользователя совпадает
//    match /users/{userId}/{document=**} {
//      allow write: if request.auth != null && request.auth.uid == userId;
//    }
//
//    // Разрешаем удаление данных анонимного пользователя
//    match /users/{userId}/cartProducts/{productId} {
//      allow delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.previousUserId == userId;
//    }
//  }
//}
