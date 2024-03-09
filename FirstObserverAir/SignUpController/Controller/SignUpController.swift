//
//  SignUpController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 29.02.24.
//

import UIKit

@objc protocol NewSignUpViewControllerDelegate: AnyObject {
//    @objc optional func saveCartProductFBNew()
    @objc optional func userDidRegisteredNew()
}

final class NewSignUpViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.backgroundColor = .blue
        return scroll
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var nameTextField: AuthTextField!
    var emailTextField: AuthTextField!
    var passwordTextField: AuthTextField!
    var reEnterTextField: AuthTextField!
    var activeTextField: UITextField?

    var separatorNameView: UIView!
    var separatorEmailView: UIView!
    var separatorPasswordView: UIView!
    var separatorReEnterPasswordView: UIView!

    var nameStackView: UIStackView!
    var emailStackView: UIStackView!
    var passwordStackView: UIStackView!
    var reEnterPasswordStackView: UIStackView!

    var warningTextName: UILabel!
    var warningTextEmail: UILabel!
    var warningTextPassword: UILabel!
    var warningTextRePassword: UILabel!

    let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .systemGreen
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.AuthControllers.SignUP.signUpLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()

    let exitTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.backgroundColor = R.Colors.opaqueSeparator
        view.layer.cornerRadius = 2
        return view
    }()

    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()

    let signUpButton: SignInUpProcessButton = SignInUpProcessButton(titleButtonProcess: R.Strings.AuthControllers.SignUP.signUpButtonProcess, titleButtonStart: R.Strings.AuthControllers.SignUP.signUpButtonStart)

    private let eyePassswordButton = EyeButton()
    private let eyeRePassswordButton = EyeButton()
    private var isPrivateEye = true

    var isNameValid = false
    var isEmailValid = false
    var isPasswordValid = false
    var isRePasswordValid = false

//    var isInvalidSignIn = false
    weak var signInDelegate:NewSignUpViewControllerDelegate?

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignUpController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SignUpController viewWillDisappear")
    }

    deinit {
        print("deinit NewSignUpViewController")
    }
}


// MARK: - Setting Views
private extension NewSignUpViewController {
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        observeKeyboardNotifications()
        assemblyStackView()
        addActions()
        setupStackView()
        addSubViews()
        setupLayout()
        isEnabledSignUpButton(enabled: false)
    }
}

// MARK: - Setting
private extension NewSignUpViewController {
    
    func assemblyStackView() {
        (nameStackView, nameTextField, separatorNameView, warningTextName) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.nameLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderNameTextField, textContentType: .username, isSecureTextEntry: false, eyeButton: nil, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.nameTextField)
        }, delegate: self)

        (emailStackView, emailTextField, separatorEmailView, warningTextEmail) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.emailLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderEmailTextField, textContentType: .emailAddress, isSecureTextEntry: false, eyeButton: nil, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.emailTextField)
        }, delegate: self)

        (passwordStackView, passwordTextField, separatorPasswordView, warningTextPassword) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.passwordLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderPasswordTextField, textContentType: .newPassword, isSecureTextEntry: true, eyeButton: eyePassswordButton, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.passwordTextField)
       }, delegate: self)

        (reEnterPasswordStackView, reEnterTextField, separatorReEnterPasswordView, warningTextRePassword) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.reEnterPasswordLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderReEnterTextField, textContentType: .newPassword, isSecureTextEntry: true, eyeButton: eyeRePassswordButton, actionForTextField: UIAction { [weak self] _ in
            self?.textFieldHandler(self?.reEnterTextField)
       }, delegate: self)
    }
    
    func addSubViews() {
        view.addGestureRecognizer(tapRootViewGestureRecognizer)
        view.addSubview(exitTopView)
        [signUpLabel, allStackView].forEach {
            containerView.addSubview($0)
        }
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(signUpButton)
    }

    func addActions() {
        eyePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
        eyeRePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
        tapRootViewGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
    }


    func setupStackView() {
        [nameStackView, emailStackView, passwordStackView, reEnterPasswordStackView].forEach {allStackView.addArrangedSubview($0)}
    }

    func isEnabledSignUpButton(enabled: Bool) {
        if enabled {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }
    
    func observeKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    func resetScrollViewInsetsAndOffset() {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - Layout
private extension NewSignUpViewController {
    func setupLayout() {
        
        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 35).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        signUpLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        allStackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20).isActive = true
        allStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        allStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        allStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true

        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Actions

private extension NewSignUpViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        print("keyboardWillShow")
        if activeTextField == reEnterTextField,
           let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let textFieldBottomPosition = reEnterTextField.convert(reEnterTextField.bounds, to: self.view).maxY
            let visibleArea = self.view.frame.height - keyboardHeight
            
            if textFieldBottomPosition > visibleArea { // Если клавиатура перекрывает UITextField
                let diff = textFieldBottomPosition - visibleArea + 20 // Вычисляем разницу + 10 точек отступа
                let scrollPoint = CGPoint(x: 0, y: diff)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        } else {
            ///Смещение scrollView не равно .zero
            if scrollView.contentOffset != .zero {
                resetScrollViewInsetsAndOffset()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("keyboardWillHide")
        resetScrollViewInsetsAndOffset()
    }
    
func textFieldHandler(_ textField: UITextField?) {
        guard let textField = textField else { return }

        switch textField {
        case nameTextField:
            let nameValidationResult = Validators.validateName(nameTextField.text ?? "")
            isNameValid = nameValidationResult == "success"
            if isNameValid {
                separatorNameView.backgroundColor = R.Colors.separator
                warningTextName.text = ""
            } else {
                separatorNameView.backgroundColor = R.Colors.systemRed
                warningTextName.text = nameValidationResult.replacingOccurrences(of: "failed: ", with: "")
            }
        case emailTextField:
            isEmailValid = Validators.isValidEmail(emailTextField.text ?? "")
            warningTextEmail.text = isEmailValid ? "" : "Invalid email format"
            separatorEmailView.backgroundColor = isEmailValid ? R.Colors.separator : R.Colors.systemRed
        case passwordTextField:
            let passwordValidationResult = Validators.validateCountPassword(passwordTextField.text ?? "")
            isPasswordValid = passwordValidationResult == "success"
            if isPasswordValid {
                separatorPasswordView.backgroundColor = R.Colors.separator
                warningTextPassword.text = ""
            } else {
                separatorPasswordView.backgroundColor = R.Colors.systemRed
                warningTextPassword.text = passwordValidationResult.replacingOccurrences(of: "failed: ", with: "")
            }
        case reEnterTextField:
            let rePasswordValidationResult = Validators.validateCountPassword(reEnterTextField.text ?? "")
            isRePasswordValid = rePasswordValidationResult == "success"
            if isRePasswordValid {
                        // Дополнительная проверка на совпадение паролей
                        if passwordTextField.text != reEnterTextField.text {
                            isRePasswordValid = false
                            warningTextRePassword.text = "Проверка пароля не совпадает"
                        } else {
                            separatorReEnterPasswordView.backgroundColor = R.Colors.separator
                            warningTextRePassword.text =  ""
                        }
                    } else {
                        separatorReEnterPasswordView.backgroundColor = R.Colors.systemRed
                        warningTextRePassword.text = rePasswordValidationResult.replacingOccurrences(of: "failed: ", with: "")
                    }
        default:
            break
        }
    isEnabledSignUpButton(enabled: isNameValid && isEmailValid && isPasswordValid && isRePasswordValid)
}

@objc private func displayBookMarksSignUp() {

    let imageName = isPrivateEye ? R.Strings.AuthControllers.SignUP.imageSystemNameEye : R.Strings.AuthControllers.SignUP.imageSystemNameEyeSlash
    passwordTextField.isSecureTextEntry.toggle()
    eyePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)

    reEnterTextField.isSecureTextEntry.toggle()
    eyeRePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    isPrivateEye.toggle()
}

@objc func dismissKeyboard() {
    print("gestureSignUpDidTap")
    view.endEditing(true)
}

@objc func didTapSignUpButton(_ sender: UIButton) {
    print("didTapSignUpButton")

//        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
//
//        self.signingIn = true
////
////        if isInvalidSignIn {
////            signInDelegate?.saveCartProductFBNew?()
////            isInvalidSignIn = false
////        }
//
//        managerFB.registerUserSignUpVC(email: email, password: password, name: name) { [weak self] stateAuthError in
//
//            self?.signingIn = false
//            switch stateAuthError {
//            case .success:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                // это нужно для ProfileVC и CartVC что бы обновить UI
//                self?.signInDelegate?.userDidRegisteredNew?()
//                self?.registerShowAlert(title: "Success", message: "An email has been sent to \(email), please confirm your email address.") {
//                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//                }
//            case .failed:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
//            case .providerAlreadyLinked:
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "Attempt to associate a provider already associated with this account!")
//            case .credentialAlreadyInUse:
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "You are trying to associate credentials that have already been associated with another account!")
//            case .userTokenExpired:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
//            case .invalidUserToken:
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
//            case .requiresRecentLogin:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
//            case .networkError:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "Server connection problems. Try again!")
//            case .tooManyRequests:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "Try again later!")
//            case .invalidEmail:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
//                self?.registerShowAlert(title: "Error", message: "Email address is not in the correct format!")
//            case .emailAlreadyInUse:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
//                self?.registerShowAlert(title: "Error", message: "The email address used to attempt registration already exists!")
//            case .weakPassword:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.separatorPasswordView.backgroundColor = R.Colors.systemRed
//                self?.registerShowAlert(title: "Error", message: "The entered password is too weak!")
//            default:
////                self?.signingIn = false
//                self?.isEnabledSignUpButton(enabled: false)
//                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
//            }
//        }
}
}

// MARK: - UITextFieldDelegate
extension NewSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {

        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            reEnterTextField.becomeFirstResponder()
        case reEnterTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

        guard let text = textField.text else {return}

        switch textField {
        case passwordTextField:
            eyePassswordButton.isEnabled = !text.isEmpty
        case reEnterTextField:
            eyeRePassswordButton.isEnabled = !text.isEmpty
        default:
            break
        }
    }
    
    /// Устанавливаем activeTextField, когда пользователь начинает редактировать UITextField
       func textFieldDidBeginEditing(_ textField: UITextField) {
           print("textFieldDidBeginEditing")
           activeTextField = textField
       }
    
//    ///если активное текстовое поле является reEnterTextField, то клавиатура скрывается, когда пользователь нажимает на другое текстовое поле.
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
//        if activeTextField == reEnterTextField {
//            print("activeTextField == reEnterTextField")
//            activeTextField?.resignFirstResponder()
//            resetScrollViewInsetsAndOffset()
//            activeTextField = nil
//        }
//        return true
//    }

}


// MARK: - Alert

private extension NewSignUpViewController {

    func registerShowAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "ok", style: .default) { (_) in
            completion()
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }

}



// MARK: - Second Version Copy

//@objc protocol NewSignUpViewControllerDelegate: AnyObject {
////    @objc optional func saveCartProductFBNew()
//    @objc optional func userDidRegisteredNew()
//}
//
//
//final class NewSignUpViewController: UIViewController {
//
//    var nameTextField: AuthTextField!
//    var emailTextField: AuthTextField!
//    var passwordTextField: AuthTextField!
//    var reEnterTextField: AuthTextField!
//
//    var separatorNameView: UIView!
//    var separatorEmailView: UIView!
//    var separatorPasswordView: UIView!
//    var separatorReEnterPasswordView: UIView!
//
//    var nameStackView: UIStackView!
//    var emailStackView: UIStackView!
//    var passwordStackView: UIStackView!
//    var reEnterPasswordStackView: UIStackView!
//
//    var warningTextName: UILabel!
//    var warningTextEmail: UILabel!
//    var warningTextPassword: UILabel!
//    var warningTextRePassword: UILabel!
//
//    let allStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        return stackView
//    }()
//
//    let signUpLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.signUpLabel
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let exitTopView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        view.backgroundColor = R.Colors.opaqueSeparator
//        view.layer.cornerRadius = 2
//        return view
//    }()
//
//    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
//        let gesture = UITapGestureRecognizer()
//        gesture.numberOfTapsRequired = 1
//        return gesture
//    }()
//
//    let signUpButton: SignInUpProcessButton = SignInUpProcessButton(titleButtonProcess: R.Strings.AuthControllers.SignUP.signUpButtonProcess, titleButtonStart: R.Strings.AuthControllers.SignUP.signUpButtonStart)
//
//    private let eyePassswordButton = EyeButton()
//    private let eyeRePassswordButton = EyeButton()
//    private var isPrivateEye = true
//
//    var isNameValid = false
//    var isEmailValid = false
//    var isPasswordValid = false
//    var isRePasswordValid = false
//
//
////    var isInvalidSignIn = false
//    weak var signInDelegate:NewSignUpViewControllerDelegate?
//
//    // MARK: - Methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//
//    deinit {
//        print("deinit NewSignUpViewController")
//    }
//}
//
//
//// MARK: - Setting Views
//private extension NewSignUpViewController {
//    func setupView() {
//        view.backgroundColor = R.Colors.systemBackground
//        assemblyStackView()
//        addActions()
//        setupStackView()
//        addSubViews()
//        setupLayout()
//        isEnabledSignUpButton(enabled: false)
//    }
//}
//
//// MARK: - Setting
//private extension NewSignUpViewController {
//
//    func assemblyStackView() {
//        (nameStackView, nameTextField, separatorNameView, warningTextName) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.nameLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderNameTextField, textContentType: .username, isSecureTextEntry: false, eyeButton: nil, actionForTextField: UIAction { [weak self] _ in
//            self?.textFieldHandler(self?.nameTextField)
//        }, delegate: self)
//
//        (emailStackView, emailTextField, separatorEmailView, warningTextEmail) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.emailLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderEmailTextField, textContentType: .emailAddress, isSecureTextEntry: false, eyeButton: nil, actionForTextField: UIAction { [weak self] _ in
//            self?.textFieldHandler(self?.emailTextField)
//        }, delegate: self)
//
//        (passwordStackView, passwordTextField, separatorPasswordView, warningTextPassword) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.passwordLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderPasswordTextField, textContentType: .newPassword, isSecureTextEntry: true, eyeButton: eyePassswordButton, actionForTextField: UIAction { [weak self] _ in
//            self?.textFieldHandler(self?.passwordTextField)
//       }, delegate: self)
//
//        (reEnterPasswordStackView, reEnterTextField, separatorReEnterPasswordView, warningTextRePassword) = BuilderStackView.build(title: R.Strings.AuthControllers.SignUP.reEnterPasswordLabel, textFieldPlaceholder: R.Strings.AuthControllers.SignUP.placeholderReEnterTextField, textContentType: .newPassword, isSecureTextEntry: true, eyeButton: eyeRePassswordButton, actionForTextField: UIAction { [weak self] _ in
//            self?.textFieldHandler(self?.reEnterTextField)
//       }, delegate: self)
//    }
//
//    func addSubViews() {
//        view.addGestureRecognizer(tapRootViewGestureRecognizer)
//        view.addSubview(exitTopView)
//        view.addSubview(signUpLabel)
//        view.addSubview(allStackView)
//        view.addSubview(signUpButton)
//    }
//
//    func addActions() {
//        eyePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
//        eyeRePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
//        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureSignUpDidTap))
//        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
//    }
//
//
//    func setupStackView() {
//        [nameStackView, emailStackView, passwordStackView, reEnterPasswordStackView].forEach {allStackView.addArrangedSubview($0)}
//    }
//
//    func isEnabledSignUpButton(enabled: Bool) {
//        if enabled {
//            signUpButton.isEnabled = true
//        } else {
//            signUpButton.isEnabled = false
//        }
//    }
//}
//
//// MARK: - Layout
//private extension NewSignUpViewController {
//    func setupLayout() {
//        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
//        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
//
//        signUpLabel.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 35).isActive = true
//        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//
//        allStackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20).isActive = true
//        allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
//        allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
//
//        NSLayoutConstraint.activate([
//            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            signUpButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//}
//
//// MARK: - Actions
//
//private extension NewSignUpViewController {
//func textFieldHandler(_ textField: UITextField?) {
//        guard let textField = textField else { return }
//
//        switch textField {
//        case nameTextField:
//            let nameValidationResult = Validators.validateName(nameTextField.text ?? "")
//            isNameValid = nameValidationResult == "success"
//            if isNameValid {
//                separatorNameView.backgroundColor = R.Colors.separator
//                warningTextName.text = ""
//            } else {
//                separatorNameView.backgroundColor = R.Colors.systemRed
//                warningTextName.text = nameValidationResult.replacingOccurrences(of: "failed: ", with: "")
//            }
//        case emailTextField:
//            isEmailValid = Validators.isValidEmail(emailTextField.text ?? "")
//            warningTextEmail.text = isEmailValid ? "" : "Invalid email format"
//            separatorEmailView.backgroundColor = isEmailValid ? R.Colors.separator : R.Colors.systemRed
//        case passwordTextField:
//            let passwordValidationResult = Validators.validateCountPassword(passwordTextField.text ?? "")
//            isPasswordValid = passwordValidationResult == "success"
//            if isPasswordValid {
//                separatorPasswordView.backgroundColor = R.Colors.separator
//                warningTextPassword.text = ""
//            } else {
//                separatorPasswordView.backgroundColor = R.Colors.systemRed
//                warningTextPassword.text = passwordValidationResult.replacingOccurrences(of: "failed: ", with: "")
//            }
//        case reEnterTextField:
//            let rePasswordValidationResult = Validators.validateCountPassword(reEnterTextField.text ?? "")
//            isRePasswordValid = rePasswordValidationResult == "success"
//            if isRePasswordValid {
//                        // Дополнительная проверка на совпадение паролей
//                        if passwordTextField.text != reEnterTextField.text {
//                            isRePasswordValid = false
//                            warningTextRePassword.text = "Проверка пароля не совпадает"
//                        } else {
//                            separatorReEnterPasswordView.backgroundColor = R.Colors.separator
//                            warningTextRePassword.text =  ""
//                        }
//                    } else {
//                        separatorReEnterPasswordView.backgroundColor = R.Colors.systemRed
//                        warningTextRePassword.text = rePasswordValidationResult.replacingOccurrences(of: "failed: ", with: "")
//                    }
//        default:
//            break
//        }
//    isEnabledSignUpButton(enabled: isNameValid && isEmailValid && isPasswordValid && isRePasswordValid)
//}
//
//@objc private func displayBookMarksSignUp() {
//
//    let imageName = isPrivateEye ? R.Strings.AuthControllers.SignUP.imageSystemNameEye : R.Strings.AuthControllers.SignUP.imageSystemNameEyeSlash
//    passwordTextField.isSecureTextEntry.toggle()
//    eyePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
//
//    reEnterTextField.isSecureTextEntry.toggle()
//    eyeRePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
//    isPrivateEye.toggle()
//}
//
//@objc func gestureSignUpDidTap() {
//    view.endEditing(true)
//}
//
//@objc func didTapSignUpButton(_ sender: UIButton) {
//    print("didTapSignUpButton")
//
////        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
////
////        self.signingIn = true
//////
//////        if isInvalidSignIn {
//////            signInDelegate?.saveCartProductFBNew?()
//////            isInvalidSignIn = false
//////        }
////
////        managerFB.registerUserSignUpVC(email: email, password: password, name: name) { [weak self] stateAuthError in
////
////            self?.signingIn = false
////            switch stateAuthError {
////            case .success:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                // это нужно для ProfileVC и CartVC что бы обновить UI
////                self?.signInDelegate?.userDidRegisteredNew?()
////                self?.registerShowAlert(title: "Success", message: "An email has been sent to \(email), please confirm your email address.") {
////                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
////                }
////            case .failed:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
////            case .providerAlreadyLinked:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Attempt to associate a provider already associated with this account!")
////            case .credentialAlreadyInUse:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You are trying to associate credentials that have already been associated with another account!")
////            case .userTokenExpired:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .invalidUserToken:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .requiresRecentLogin:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .networkError:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Server connection problems. Try again!")
////            case .tooManyRequests:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Try again later!")
////            case .invalidEmail:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "Email address is not in the correct format!")
////            case .emailAlreadyInUse:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "The email address used to attempt registration already exists!")
////            case .weakPassword:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorPasswordView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "The entered password is too weak!")
////            default:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
////            }
////        }
//}
//}
//
//// MARK: - UITextFieldDelegate
//extension NewSignUpViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        switch textField {
//
//        case nameTextField:
//            emailTextField.becomeFirstResponder()
//        case emailTextField:
//            passwordTextField.becomeFirstResponder()
//        case passwordTextField:
//            reEnterTextField.becomeFirstResponder()
//        case reEnterTextField:
//            textField.resignFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//
//        guard let text = textField.text else {return}
//
//        switch textField {
//        case passwordTextField:
//            eyePassswordButton.isEnabled = !text.isEmpty
//        case reEnterTextField:
//            eyeRePassswordButton.isEnabled = !text.isEmpty
//        default:
//            break
//        }
//    }
//
//}
//
//
//// MARK: - Alert
//
//private extension NewSignUpViewController {
//
//    func registerShowAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let actionOK = UIAlertAction(title: "ok", style: .default) { (_) in
//            completion()
//        }
//        alert.addAction(actionOK)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//}


// MARK: - Copy


//@objc protocol NewSignUpViewControllerDelegate: AnyObject {
////    @objc optional func saveCartProductFBNew()
//    @objc optional func userDidRegisteredNew()
//}
//
//
//final class NewSignUpViewController: UIViewController {
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.nameLabel
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let emailLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.emailLabel
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let passwordLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.passwordLabel
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let reEnterPasswordLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.reEnterPasswordLabel
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let nameTextField: AuthTextField = {
//        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignUP.placeholderNameTextField)
//        textField.textContentType = .name
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let emailTextField: AuthTextField = {
//        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignUP.placeholderEmailTextField)
//        textField.textContentType = .emailAddress
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let passwordTextField: AuthTextField = {
//        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignUP.placeholderPasswordTextField)
//        textField.textContentType = .newPassword
//        textField.isSecureTextEntry = true
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let reEnterTextField: AuthTextField = {
//        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignUP.placeholderReEnterTextField)
//        textField.textContentType = .newPassword
//        textField.isSecureTextEntry = true
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let separatorNameView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        view.backgroundColor = R.Colors.separator
//        return view
//    }()
//
//    let separatorEmailView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        view.backgroundColor = R.Colors.separator
//        return view
//    }()
//
//    let separatorPasswordView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        view.backgroundColor = R.Colors.separator
//        return view
//    }()
//
//    let separatorReEnterPasswordView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        view.backgroundColor = R.Colors.separator
//        return view
//    }()
//
//    let nameStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 0
//        return stackView
//    }()
//
//    let emailStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 0
//        return stackView
//    }()
//
//    let passwordStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 0
//        return stackView
//    }()
//
//    let reEnterPasswordStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 0
//        return stackView
//    }()
//
//    let allStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        return stackView
//    }()
//
//    let signUpLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.AuthControllers.SignUP.signUpLabel
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let exitTopView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        view.backgroundColor = R.Colors.opaqueSeparator
//        view.layer.cornerRadius = 2
//        return view
//    }()
//
//    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
//        let gesture = UITapGestureRecognizer()
//        gesture.numberOfTapsRequired = 1
//        return gesture
//    }()
//
//    let signUpButton: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        var grayButton = UIButton(configuration: configuration)
//        return grayButton
//    }()
//
//    private let eyePassswordButton = EyeButton()
//    private let eyeRePassswordButton = EyeButton()
//    private var isPrivateEye = true
//    private var buttonCentre: CGPoint!
//
//    var signingIn = false {
//        didSet {
//            signUpButton.setNeedsUpdateConfiguration()
//        }
//    }
//
////    let managerFB = FBManager.shared
////    var isInvalidSignIn = false
//    weak var signInDelegate:NewSignUpViewControllerDelegate?
//
//    // MARK: - Methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = R.Colors.systemBackground
//        nameTextField.delegate = self
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        reEnterTextField.delegate = self
//        setupView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSignUp), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSignUp), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//
//
//    }
//
//
//    // MARK: - Actions
//
//    @IBAction func signUpTextFieldChanged(_ sender: UITextField) {
//
//        switch sender {
//        case emailTextField:
//            separatorEmailView.backgroundColor = emailTextField.text?.isEmpty ?? true ? R.Colors.systemRed : R.Colors.separator
//        case nameTextField:
//            separatorNameView.backgroundColor = nameTextField.text?.isEmpty ?? true ? R.Colors.systemRed : R.Colors.separator
//        case passwordTextField:
//            separatorPasswordView.backgroundColor = passwordTextField.text?.isEmpty ?? true ? R.Colors.systemRed : R.Colors.separator
//        case reEnterTextField:
//            separatorReEnterPasswordView.backgroundColor = reEnterTextField.text?.isEmpty ?? true ? R.Colors.systemRed : R.Colors.separator
//        default:
//            return
//        }
//
//        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let rePassword = reEnterTextField.text else {return}
//
//        let isValid = !(name.isEmpty) && !(email.isEmpty) && !(password.isEmpty) && password == rePassword
//        isEnabledSignUpButton(enabled: isValid)
//    }
//
//    @objc private func displayBookMarksSignUp() {
//
//        let imageName = isPrivateEye ? R.Strings.AuthControllers.SignUP.imageSystemNameEye : R.Strings.AuthControllers.SignUP.imageSystemNameEyeSlash
//        passwordTextField.isSecureTextEntry.toggle()
//        eyePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
//
//        reEnterTextField.isSecureTextEntry.toggle()
//        eyeRePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
//        isPrivateEye.toggle()
//    }
//
//    @objc func gestureSignUpDidTap() {
//        view.endEditing(true)
//    }
//
//    @objc func didTapSignUpButton(_ sender: UIButton) {
//
//
////        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
////
////        self.signingIn = true
//////
//////        if isInvalidSignIn {
//////            signInDelegate?.saveCartProductFBNew?()
//////            isInvalidSignIn = false
//////        }
////
////        managerFB.registerUserSignUpVC(email: email, password: password, name: name) { [weak self] stateAuthError in
////
////            self?.signingIn = false
////            switch stateAuthError {
////            case .success:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                // это нужно для ProfileVC и CartVC что бы обновить UI
////                self?.signInDelegate?.userDidRegisteredNew?()
////                self?.registerShowAlert(title: "Success", message: "An email has been sent to \(email), please confirm your email address.") {
////                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
////                }
////            case .failed:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
////            case .providerAlreadyLinked:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Attempt to associate a provider already associated with this account!")
////            case .credentialAlreadyInUse:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You are trying to associate credentials that have already been associated with another account!")
////            case .userTokenExpired:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .invalidUserToken:
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .requiresRecentLogin:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "You need to re-login to your account!")
////            case .networkError:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Server connection problems. Try again!")
////            case .tooManyRequests:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Try again later!")
////            case .invalidEmail:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "Email address is not in the correct format!")
////            case .emailAlreadyInUse:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorEmailView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "The email address used to attempt registration already exists!")
////            case .weakPassword:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.separatorPasswordView.backgroundColor = R.Colors.systemRed
////                self?.registerShowAlert(title: "Error", message: "The entered password is too weak!")
////            default:
//////                self?.signingIn = false
////                self?.isEnabledSignUpButton(enabled: false)
////                self?.registerShowAlert(title: "Error", message: "Something went wrong! Try again!")
////            }
////        }
//    }
//
//    @objc func keyboardWillHideSignUp(notification: Notification) {
//        signUpButton.center = buttonCentre
//    }
//
//    @objc func keyboardWillShowSignUp(notification: Notification) {
//
//        let userInfo = notification.userInfo!
//        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//
//        signUpButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 15 - signUpButton.frame.height/2)
//    }
//
//    deinit {
//        print("deinit NewSignUpViewController")
//    }
//}
//
//
//// MARK: - Setting Views
//private extension NewSignUpViewController {
//    func setupView() {
//        setupPasswordTF()
//        addActions()
//        setupStackView()
//        addSubViews()
//        setupLayout()
//        isEnabledSignUpButton(enabled: false)
//    }
//}
//
//// MARK: - Setting
//private extension NewSignUpViewController {
//
//    func addSubViews() {
//        view.addGestureRecognizer(tapRootViewGestureRecognizer)
//        view.addSubview(exitTopView)
//        view.addSubview(signUpLabel)
//        view.addSubview(allStackView)
//        view.addSubview(signUpButton)
//    }
//    func addActions() {
//
//        nameTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
//        emailTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
//        reEnterTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
//
//        eyePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
//        eyeRePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
//        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureSignUpDidTap))
//        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
//        signUpButton.configurationUpdateHandler = { [weak self] button in
//
//            guard let signingIn = self?.signingIn else {return}
//            var config = button.configuration
//            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//                var outgoing = incoming
//                outgoing.foregroundColor = R.Colors.label
//                outgoing.font = UIFont.boldSystemFont(ofSize: 17)
//                return outgoing
//            }
//            config?.imagePadding = 10
//            config?.imagePlacement = .trailing
//            config?.showsActivityIndicator = signingIn
//            config?.title = signingIn ? R.Strings.AuthControllers.SignUP.signUpButtonProcess : R.Strings.AuthControllers.SignUP.signUpButtonStart
//            button.isUserInteractionEnabled = !signingIn
//            button.configuration = config
//        }
//    }
//
//
//    func setupStackView() {
//
//        nameStackView.addArrangedSubview(nameLabel)
//        nameStackView.addArrangedSubview(nameTextField)
//        nameStackView.addArrangedSubview(separatorNameView)
//
//        emailStackView.addArrangedSubview(emailLabel)
//        emailStackView.addArrangedSubview(emailTextField)
//        emailStackView.addArrangedSubview(separatorEmailView)
//
//        passwordStackView.addArrangedSubview(passwordLabel)
//        passwordStackView.addArrangedSubview(passwordTextField)
//        passwordStackView.addArrangedSubview(separatorPasswordView)
//
//        reEnterPasswordStackView.addArrangedSubview(reEnterPasswordLabel)
//        reEnterPasswordStackView.addArrangedSubview(reEnterTextField)
//        reEnterPasswordStackView.addArrangedSubview(separatorReEnterPasswordView)
//
//        allStackView.addArrangedSubview(nameStackView)
//        allStackView.addArrangedSubview(emailStackView)
//        allStackView.addArrangedSubview(passwordStackView)
//        allStackView.addArrangedSubview(reEnterPasswordStackView)
//    }
//
//    func setupPasswordTF() {
//        passwordTextField.rightView = eyePassswordButton
//        passwordTextField.rightViewMode = .always
//
//        reEnterTextField.rightView = eyeRePassswordButton
//        reEnterTextField.rightViewMode = .always
//    }
//
//    func isEnabledSignUpButton(enabled: Bool) {
//
//        if enabled {
//            signUpButton.isEnabled = true
//        } else {
//            signUpButton.isEnabled = false
//        }
//    }
//}
//
//// MARK: - Layout
//private extension NewSignUpViewController {
//    func setupLayout() {
//
//        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
//        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
//
//        signUpLabel.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 45).isActive = true
//        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//
//        allStackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20).isActive = true
//        allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
//        allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
//
//        signUpButton.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 50)
//        signUpButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
//        buttonCentre = signUpButton.center
//    }
//}
//
//// MARK: - UITextFieldDelegate
//extension NewSignUpViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        switch textField {
//
//        case nameTextField:
//            emailTextField.becomeFirstResponder()
//        case emailTextField:
//            passwordTextField.becomeFirstResponder()
//        case passwordTextField:
//            reEnterTextField.becomeFirstResponder()
//        case reEnterTextField:
//            textField.resignFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//
//        guard let text = textField.text else {return}
//
//        switch textField {
//        case passwordTextField:
//            eyePassswordButton.isEnabled = !text.isEmpty
//        case reEnterTextField:
//            eyeRePassswordButton.isEnabled = !text.isEmpty
//        default:
//            break
//        }
//    }
//
//}
//
//
//// MARK: - Alert
//
//private extension NewSignUpViewController {
//
//    func registerShowAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let actionOK = UIAlertAction(title: "ok", style: .default) { (_) in
//            completion()
//        }
//        alert.addAction(actionOK)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//}
