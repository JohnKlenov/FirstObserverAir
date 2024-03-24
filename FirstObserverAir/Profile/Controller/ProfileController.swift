//
//  ProfileController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

enum StateProfileInfo {
    case success
    case failed(image:Bool? = nil, name:Bool? = nil)
    case nul
}

struct UserProfile {
    var name:String
    var email:String
    var url:String
}

protocol ProfileModelOutput:AnyObject {
    func updateUserProfile(with userData:UserProfile)
}

final class ProfileController: UIViewController {
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = R.Colors.backgroundBlackLith
        view.backgroundColor = R.Colors.systemGray5
        return view
    }()
    
    private let imageUser: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 10
        image.layer.borderColor = UIColor.label.cgColor
        image.layer.borderWidth = 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.tintColor = R.Colors.label
        image.image?.withRenderingMode(.alwaysTemplate)
        image.backgroundColor = R.Colors.secondarySystemBackground
        return image
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 20, weight: .medium)
//        textField.font = R.Fonts.helveltica.regular.font(size: 20)
        textField.tintColor = R.Colors.placeholderText
        textField.textContentType = .name
        textField.backgroundColor = .clear
        textField.placeholder = R.Strings.TabBarController.Profile.ViewsProfile.placeholderNameTextField
        return textField
    }()
    
    let emailUserTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.tintColor = R.Colors.placeholderText
        textField.textContentType = .emailAddress
        textField.backgroundColor = .clear
        return textField
    }()
    
    let infoUserStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
   
    let signInSignUp: UIButton = {
    
        var configuration = UIButton.Configuration.gray()

        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.TabBarController.Profile.ViewsProfile.signInUpButton, attributes: container)

        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemFill
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let signOutButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.TabBarController.Profile.ViewsProfile.signOutButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemFill
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let deleteAccountButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = R.Colors.systemRed
        configuration.attributedTitle = AttributedString(R.Strings.TabBarController.Profile.ViewsProfile.deleteButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemFill
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let editButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = R.Strings.TabBarController.Profile.ViewsProfile.navBarButtonEdit
        configButton.baseForegroundColor = R.Colors.systemPurple
        configButton.titleAlignment = .trailing
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = R.Strings.TabBarController.Profile.ViewsProfile.navBarButtonCancel
        configButton.baseForegroundColor = R.Colors.systemPurple
        configButton.titleAlignment = .trailing
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let imageUserTapGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
//    private var cartProducts: [PopularProduct] = []
    private var isStateEditingModeProfile = true {
        didSet {
            disableAuthorizationButtons(isEdittButtonState: isStateEditingModeProfile)
        }
    }
    private var isAnimatedRemovalOfButtonsForAnonUser = false
    
    
    // MARK: property for working with image
    private let encoder = JSONEncoder()
    private var isChangedCurrentImageUser = false
    private var dataForNewImageUser: Data?
    private var casheImageUserSavedOnTheServer: UIImage?
    
    private var profileModel: ProfileModelInput?
    
    // MARK: FB property
//    let managerFB = FBManager.shared
//    private var currentUser: User?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//            return .portrait // Здесь указываем ориентацию, которую вы хотите разрешить (например, только портретную)
//        }

}

// MARK: - Setting Views
private extension ProfileController {
    func setupView() {
        //        setNeedsStatusBarAppearanceUpdate()
        //        self.navigationController?.navigationBar.barStyle = .black
        
        //        managerFB.userListener { [weak self] (user) in
        //            self?.currentUser = user
        //
        //            if let user = user, !user.isAnonymous {
        //                self?.updateUIForPermanentUser(user)
        //            } else {
        //                self?.updateUIForAnonymousUser()
        //            }
        //        }
        profileModel = ProfileFirebaseService(output: self)
        view.backgroundColor = R.Colors.systemBackground
        updateUIForPermanentUser()
        //        navigationController?.navigationBar.prefersLargeTitles = true
        configureNavigationBar(largeTitleColor: R.Colors.label, backgoundColor: R.Colors.systemGray5, tintColor: R.Colors.label, title: R.Strings.NavBar.profile, preferredLargeTitle: true)
        configureNavigationItem()
        setupStackView()
        imageUser.addGestureRecognizer(imageUserTapGestureRecognizer)
        addActions()
        addSubview()
        //        imageUser.image = UIImage(named: "DefaultImage")
        setupConstraints()
    }
}

// MARK: - Setting
private extension ProfileController {
    
    func configureNavigationItem() {
        editButton.addTarget(self, action: #selector(editingModeButtonHandler), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonHandler), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    func setupStackView() {
        infoUserStackView.addArrangedSubview(userNameTextField)
        infoUserStackView.addArrangedSubview(emailUserTextField)
        buttonsStackView.addArrangedSubview(signInSignUp)
        buttonsStackView.addArrangedSubview(signOutButton)
        buttonsStackView.addArrangedSubview(deleteAccountButton)
    }
    
    func addActions() {
        userNameTextField.addTarget(self, action: #selector(didChangeNameTextField), for: .editingChanged)
        signInSignUp.addTarget(self, action: #selector(didTapsignInSignUp(_:)), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccount(_:)), for: .touchUpInside)
        imageUserTapGestureRecognizer.addTarget(self, action: #selector(handleTapSingleGesture))
    }
    
    func addSubview() {
        view.addSubview(topView)
        view.addSubview(imageUser)
        view.addSubview(infoUserStackView)
        view.addSubview(buttonsStackView)
    }
    
    // MARK: update UI methods

    ///updateUIForPermanentUser(_ user:User)
    ///emailUserTextField.text = user.email
    ///userNameTextField.text = user.displayName
    ///if let photoURL = user.photoURL?.absoluteString, photoURL != "nil" {
    ///можем создать струтуру UserProfile с полями для этих данных
    
    private func updateUIForPermanentUser() {
        editButton.isHidden = false
        emailUserTextField.isHidden = false
        emailUserTextField.text = "user.email"
//        print("user.displayName - \(String(describing: user.displayName))")
        userNameTextField.text = "user.displayName"
        cancelButton.isHidden = true
        userNameTextField.isUserInteractionEnabled = false
        emailUserTextField.isUserInteractionEnabled = false
        imageUser.isUserInteractionEnabled = false

        signOutButton.isHidden = false
        deleteAccountButton.isHidden = false
        
//        print("user.photoURL?.absoluteString - \(String(describing: user.photoURL?.absoluteString))")
//        if let photoURL = user.photoURL?.absoluteString, photoURL != "nil" {
//            print("photoURL - \(photoURL)")
//            imageUser.fetchingImageWithPlaceholder(url: photoURL, defaultImage: R.Images.Profile.defaultAvatarImage)
//
//        } else {
//            self.imageUser.image = R.Images.Profile.defaultAvatarImage
//        }
        let image = R.Images.Profile.defaultAvatarImage
//        let tintableImage = image?.withRenderingMode(.alwaysTemplate)
        imageUser.image = image
    }
   

    private func updateUIForAnonymousUser() {
        editButton.isHidden = true
        cancelButton.isHidden = true
        userNameTextField.text = R.Strings.TabBarController.Profile.ViewsProfile.anonymousNameTextField
        userNameTextField.isUserInteractionEnabled = false
        imageUser.image = R.Images.Profile.defaultAvatarImage
        imageUser.isUserInteractionEnabled = false
        emailUserTextField.isHidden = true
        signInSignUp.isHidden = false
        signOutButton.configuration?.showsActivityIndicator = false
        if isAnimatedRemovalOfButtonsForAnonUser {
            UIView.animate(withDuration: 0.2) {
                self.signOutButton.isHidden = true
                self.deleteAccountButton.isHidden = true
                self.isAnimatedRemovalOfButtonsForAnonUser = false
            }
        } else {
            signOutButton.isHidden = true
            deleteAccountButton.isHidden = true
        }
    }
    
    // MARK: methods for changing state buttons
    
    private func enableEditingModeForProfile(isSwitch: Bool) {
         isSwitch ? enableSaveButton(isSwitch: !isSwitch) : enableEditButton(isSwitch: !isSwitch)
         self.cancelButton.isHidden = !isSwitch
         self.userNameTextField.isUserInteractionEnabled = isSwitch
         self.imageUser.isUserInteractionEnabled = isSwitch
         self.isStateEditingModeProfile = !isSwitch
    }

    private func enableSaveButton(isSwitch: Bool) {
        editButton.configuration?.title = R.Strings.TabBarController.Profile.ViewsProfile.navBarButtonSave
        editButton.configuration?.baseForegroundColor = isSwitch ? R.Colors.systemPurple : R.Colors.systemGray
        editButton.isUserInteractionEnabled = isSwitch ? true : false
    }

    private func enableEditButton(isSwitch: Bool) {
        editButton.configuration?.title = R.Strings.TabBarController.Profile.ViewsProfile.navBarButtonEdit
        editButton.configuration?.baseForegroundColor = isSwitch ? R.Colors.systemPurple : R.Colors.systemGray
        editButton.isUserInteractionEnabled = isSwitch ? true : false
    }
    
    private func changedToSaveNameTextField(comletion: (Bool) -> Void) {
        // logic valid email need not
//        guard let email = emailUserTextField.text, let name = userNameTextField.text, let emailUser = currentUser?.email else { return }
//        let isValid = (!(email.isEmpty) && email != emailUser) || (!(name.isEmpty) && name != currentUser?.displayName)
//        comletion(isValid)
    }
    
    private func disableAuthorizationButtons(isEdittButtonState: Bool) {
        signInSignUp.isEnabled = isEdittButtonState ? true : false
        signOutButton.isEnabled = isEdittButtonState ? true : false
        deleteAccountButton.isEnabled = isEdittButtonState ? true : false
    }
    
    // MARK: helper methods for func managerFB.updateProfileInfo()

    private func failedUpdateImage() {
        editButton.configuration?.showsActivityIndicator = false
//        switchSaveButton(isSwitch: false)
        if isChangedCurrentImageUser {
            imageUser.image = casheImageUserSavedOnTheServer
            resetAvatarBufferProperties()
        }
    }
    
    private func successUpdateImage() {
        if isChangedCurrentImageUser {
//            managerFB.cacheImageRemoveMemoryAndDisk(imageView: imageUser)
            resetAvatarBufferProperties()
        }
    }

    private func failedUpdateName() {
//        self.userNameTextField.text = self.currentUser?.displayName
    }
    
    private func resetAvatarBufferProperties() {
        dataForNewImageUser = nil
        casheImageUserSavedOnTheServer = nil
        isChangedCurrentImageUser = false
    }
    
    // MARK: helper methods for updateImageProfile
    
    private func startRemoveAvatarUpdateUI() {
        editButton.configuration?.showsActivityIndicator = true
        editButton.isUserInteractionEnabled = false
    }

    private func endRemoveAvatarUpdateUI() {
        self.editButton.configuration?.showsActivityIndicator = false
        self.enableEditingModeForProfile(isSwitch: self.isStateEditingModeProfile)
        self.setupAlert(title: "Success", message: "Profile avatar is delete!")
        self.isChangedCurrentImageUser = false
    }
    
    private func failedRemoveAvatarUpdateUI(additionalMessage: String) {
        self.editButton.configuration?.showsActivityIndicator = false
        self.enableSaveButton(isSwitch: false)
        self.setupAlert(title: "Error", message: additionalMessage)
    }
    
}

// MARK: - Layout
private extension ProfileController {
    func setupConstraints() {
        topView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        imageUser.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        imageUser.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        imageUser.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        let yConstraint = NSLayoutConstraint(item: imageUser, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.4, constant: 0)
        let yConstraint = NSLayoutConstraint(item: imageUser, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.3, constant: 0)
        yConstraint.isActive = true
        infoUserStackView.topAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: 20).isActive = true
        infoUserStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        infoUserStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
    }
}

// MARK: - Selectors
private extension ProfileController {
    
    @objc func didTapsignInSignUp(_ sender: UIButton) {
        
        let signInVC = NewSignInViewController()
        signInVC.delegate = self
        signInVC.presentationController?.delegate = self
        present(signInVC, animated: true, completion: nil)
        
//        if segue.identifier == "signInVCfromProfile" {
//            getFetchDataHVC()
//            let destination = segue.destination as! SignInViewController
//            destination.addedToCardProducts = self.addedToCardProducts
//            destination.profileDelegate = self
//        }
    }
    
//    self?.managerFB.signOut { (stateCallback, error) in
//
//        switch stateCallback {
//        case .success:
//            self?.setupAlert(title: "Success", message: "You are logged out!")
//            self?.managerFB.avatarRef = nil
//        case .failed:
//            self?.signOutButton.configuration?.showsActivityIndicator = false
//            self?.isAnimatedRemovalOfButtonsForAnonUser = false
//            self?.setupAlert(title: "Failed SignOut", message: "Something went wrong! Try again!")
//        }
//    }
    @objc func didTapSignOut(_ sender: UIButton) {
        
        setupSignOutAlert(title: "Warning", message: "You want to log out?") { isSignOut in
        
            if isSignOut {
                self.isAnimatedRemovalOfButtonsForAnonUser = true
                self.signOutButton.configuration?.showsActivityIndicator = true
                self.signOutAccountUser()
            } else {
                self.isAnimatedRemovalOfButtonsForAnonUser = false
            }
        }
    }
    
    @objc func didTapDeleteAccount(_ sender: UIButton) {
        
//        getFetchDataHVC()
        setupDeleteAlert(title: "Warning", message: "Deleting your account will permanently lose your data!") { isDelete in

            if isDelete {
                self.isAnimatedRemovalOfButtonsForAnonUser = true
//                     удаляем корзину user и в случае не успеха deleteAccaunt должны ее вернуть
//                self.managerFB.deleteCurrentUserProducts()
                self.deleteAccountButton.configuration?.showsActivityIndicator = true
                self.deleteAccountUser()
            } else {
                self.isAnimatedRemovalOfButtonsForAnonUser = false
            }
        }
    }
    
    @objc func editingModeButtonHandler() {
        
//        if isStateEditingModeProfile {
//            enableEditingModeForProfile(isSwitch: isStateEditingModeProfile)
//        } else {
//            editButton.configuration?.showsActivityIndicator = true
//            editButton.isUserInteractionEnabled = false
//
//            let image = isChangedCurrentImageUser ? dataForNewImageUser : nil
//            // if currentUser = nil ???
//            let name = userNameTextField.text != currentUser?.displayName ? userNameTextField.text : nil
//            managerFB.updateProfileInfo(withImage: image, name: name) { (state, error) in
//                self.handleFirebaseAuthError(error) { isNeedAuthorization in
//                    let needAuthorization = isNeedAuthorization ? "Log in and " : ""
//                    self.stateHandlingForUpdateProfileInfo(state: state, additionalMessage: needAuthorization)
//                }
//            }
//        }
    }
    
    func stateHandlingForUpdateProfileInfo(state: StateProfileInfo, additionalMessage: String) {
        
        switch state {
            
        case .success:
            self.editButton.configuration?.showsActivityIndicator = false
            self.enableEditingModeForProfile(isSwitch: self.isStateEditingModeProfile)
            self.setupAlert(title: "Success", message: "Data changed!")
            self.successUpdateImage()
            
        case .failed(image: let image, name: let name):
            if let image = image, let name = name {
                if image && name {
                    self.enableSaveButton(isSwitch: false)
                    self.failedUpdateImage()
                    self.failedUpdateName()
                    self.setupAlert(title: "Error", message: "Something went wrong! \(additionalMessage)Try again!")
                } else if image {
                    self.enableSaveButton(isSwitch: false)
                    self.failedUpdateImage()
                    self.setupAlert(title: "Error", message: "Avatar not saved! \(additionalMessage)Try again!")
                    
                } else if name {
                    
                    self.editButton.configuration?.showsActivityIndicator = false
                    self.enableSaveButton(isSwitch: false)
                    self.failedUpdateName()
                    self.successUpdateImage()
                    self.setupAlert(title: "Error", message: "Name not saved! \(additionalMessage)Try again!")
                }
            } else if let name = name, name {
                self.editButton.configuration?.showsActivityIndicator = false
                self.enableSaveButton(isSwitch: false)
                self.failedUpdateName()
                self.setupAlert(title: "Error", message: "Name not saved! \(additionalMessage)Try again!")
            }
        case .nul:
            self.editButton.configuration?.showsActivityIndicator = false
            self.enableSaveButton(isSwitch: false)
            self.setupAlert(title: "Error", message: "Something went wrong! \(additionalMessage)Try again!")
        }
    }
    
    func handleFirebaseAuthError(_ error: Error?, callBack: (Bool) -> Void) {
//        guard let error = error else {
//            callBack(false)
//            return
//        }
//
//        if let error = error as? AuthErrorCode {
//            switch error.code {
//            case .requiresRecentLogin:
//                print("Пользователь давно не входил в свой аккаунт Firebase, нужно авторизоваться")
//                callBack(true)
//            default:
//                print("Another StorageErrorCode")
//                callBack(false)
//            }
//        } else if let error = error as? StorageErrorCode {
//            switch error {
//            case .unauthenticated:
//                print("Пользователь не аутентифицирован и не имеет доступа к хранилищу Firebase")
//                callBack(true)
//            default:
//                print("Another StorageErrorCode")
//                callBack(false)
//            }
//        } else {
//            callBack(false)
//        }
    }

    
    
    @objc func cancelButtonHandler() {
        
        if isChangedCurrentImageUser {
            imageUser.image = casheImageUserSavedOnTheServer
            resetAvatarBufferProperties()
        }
        cancelButton.isHidden = true
//        userNameTextField.text = currentUser?.displayName
        enableEditButton(isSwitch: true)
        userNameTextField.isUserInteractionEnabled = false
        imageUser.isUserInteractionEnabled = false
        isStateEditingModeProfile = !isStateEditingModeProfile
    }
    
    @objc func didChangeNameTextField() {
        
        changedToSaveNameTextField { (isValid) in
            enableSaveButton(isSwitch: isValid)
        }
    }
    
    @objc func handleTapSingleGesture() {
        setupAlertEditImageAvatar()
    }
}

// MARK: - Alert
private extension ProfileController {

    func setupAlertEditImageAvatar() {

        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.overrideUserInterfaceStyle = .dark

        let camera = UIAlertAction(title: "Camera", style: .default) { action in
            self.chooseImagePicker(source: .camera)
        }

        let gallery = UIAlertAction(title: "Gallery", style: .default) { action in
            self.chooseImagePicker(source: .photoLibrary)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        let deleteAvatar = UIAlertAction(title: "Delete Avatar", style: .destructive) { action in
            self.startRemoveAvatarUpdateUI()
//            self.managerFB.removeAvatarFromCurrentUser { stateAuthError in
//                switch stateAuthError {
//                case .success:
//                    self.managerFB.cacheImageRemoveMemoryAndDisk(imageView: self.imageUser)
//                    self.endRemoveAvatarUpdateUI()
//                    self.imageUser.image = UIImage(named: "DefaultImage")
//                case .failed:
//                    self.failedRemoveAvatarUpdateUI(additionalMessage: "Failed to delete profile avatar! Try again!")
//                case .requiresRecentLogin:
//                    self.failedRemoveAvatarUpdateUI(additionalMessage: "Failed to delete profile avatar! Please Log in!")
//                case .userTokenExpired:
//                    self.failedRemoveAvatarUpdateUI(additionalMessage: "Failed to delete profile avatar! Please Log in!")
//                case .invalidUserToken:
//                    self.failedRemoveAvatarUpdateUI(additionalMessage: "Failed to delete profile avatar! Please Log in!")
//                default:
//                    self.failedRemoveAvatarUpdateUI(additionalMessage: "Failed to delete profile avatar! Try again!")
//                }
//            }
        }

        let titleAlertController = NSAttributedString(string: "Add image to avatar", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        alert.setValue(titleAlertController, forKey: "attributedTitle")

        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)

//        if let _ = managerFB.avatarRef, isChangedCurrentImageUser == false {
//            alert.addAction(deleteAvatar)
//        }
        present(alert, animated: true, completion: nil)

    }

    // alert for signOut account
    
    func alertAuthorizationForSignOutAccount(title:String, message:String, placeholder: String, completionHandler: @escaping (String) -> Void ) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let text = textField?.text else {return}
            completionHandler(text)
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }

        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func wrapperOverSignOutAlert(title:String, message: String) {
        self.alertAuthorizationForSignOutAccount(title: title, message: message, placeholder: "enter password") { password in

            self.signOutButton.configuration?.showsActivityIndicator = true
            self.isAnimatedRemovalOfButtonsForAnonUser = true

//            self.managerFB.reauthenticateUser(password: password) { stateAuthError in
//
//                switch stateAuthError {
//
//                case .success:
//                    self.signOutAccountUser()
//                case .failed:
//                    self.failedSignOut()
//                    self.setupAlert(title: "Error", message: "Something went wrong! Try again!")
//                case .wrongPassword:
//                    self.failedSignOut()
//                    self.wrapperOverSignOutAlert(title: "Invalid password", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
//                case .networkError:
//                    self.failedSignOut()
//                    self.setupAlert(title: "Error", message: "Server connection problems. Try again!")
//                case .tooManyRequests:
//                    self.failedSignOut()
//                    self.setupAlert(title: "Error", message: "The number of requests has exceeded the maximum allowable value. Try again later!")
//                case .invalidCredential:
//                    self.failedSignOut()
//                    self.setupAlert(title: "Error", message: "You need to re-login to your account!")
//                default:
//                    self.failedSignOut()
//                    self.setupAlert(title: "Failed SignOut", message: "Something went wrong! Try again!")
//                }
//            }
        }
    }

    private func signOutAccountUser() {
//        managerFB.signOut { stateAuthError in
//
//            switch stateAuthError {
//            case .success:
//                self.signOutButton.configuration?.showsActivityIndicator = false
//                self.setupAlert(title: "Success", message: "You are logged out!")
//                self.managerFB.avatarRef = nil
//            case .failed:
//                self.failedSignOut()
//                self.setupAlert(title: "Error", message: "Something went wrong! Try again!")
//            case .requiresRecentLogin:
//                self.failedSignOut()
//                self.wrapperOverSignOutAlert(title: "Error", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
//            case .networkError:
//                self.failedSignOut()
//                self.setupAlert(title: "Error", message: "Server connection problems. Try again!")
//            case .userNotFound:
//                self.failedSignOut()
//                self.setupAlert(title: "Error", message: "You need to re-login to your account!")
//            case .keychainError:
//                self.failedSignOut()
//                self.setupAlert(title: "Error", message: "You need to re-login to your account!")
//            default:
//                self.failedSignOut()
//                self.setupAlert(title: "Error", message: "Something went wrong! Try again!")
//            }
//        }
    }
    
    private func failedSignOut() {
        signOutButton.configuration?.showsActivityIndicator = false
        isAnimatedRemovalOfButtonsForAnonUser = false
    }
    // alert for delete account
    
    // Log in again before retrying this request
    func alertAuthorizationForDeleteAccount(title:String, message:String, placeholder: String, completionHandler: @escaping (String) -> Void ) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let text = textField?.text else {return}
            completionHandler(text)
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // если у нас не получается удалить аккаунт то нужно оставить его корзину
//            self.saveRemuveCartProductFB()
        }

        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        present(alertController, animated: true, completion: nil)
    }


    func wrapperOverDeleteAlert(title:String, message: String) {
        self.alertAuthorizationForDeleteAccount(title: title, message: message, placeholder: "enter password") { password in

            self.deleteAccountButton.configuration?.showsActivityIndicator = true
            self.isAnimatedRemovalOfButtonsForAnonUser = true

//            self.managerFB.reauthenticateUser(password: password) { (stateAuthError) in
//
//                switch stateAuthError {
//
//                case .success:
//                    self.deleteAccountUser()
//                case .failed:
//                    self.failedDeleteAccount()
//                    self.setupFailedAlertDeleteAccount(title: "Error", message: "Something went wrong. Try again later!")
//                case .wrongPassword:
//                    self.failedDeleteAccount()
//                    self.wrapperOverDeleteAlert(title: "Invalid password", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
//                case .networkError:
//                    self.failedDeleteAccount()
//                    self.setupFailedAlertDeleteAccount(title: "Error", message: "Server connection problems. Try again!")
//                case .tooManyRequests:
//                    self.failedDeleteAccount()
//                    self.setupFailedAlertDeleteAccount(title: "Error", message: "The number of requests has exceeded the maximum allowable value. Try again later!")
//                case .invalidCredential:
//                    self.failedDeleteAccount()
//                    self.setupFailedAlertDeleteAccount(title: "Error", message: "You need to re-login to your account!")
//                default:
//                    self.failedDeleteAccount()
//                    self.setupFailedAlertDeleteAccount(title: "Error", message: "Something went wrong. Try again later!")
//                }
//            }
        }
    }

    private func deleteAccountUser() {
//        self.managerFB.deleteAccaunt { (stateAuthError) in
//            switch stateAuthError {
//
//            case .success:
//                self.managerFB.removeAvatarFromDeletedUser()
//                self.deleteAccountButton.configuration?.showsActivityIndicator = false
//                self.setupAlert(title: "Success", message: "Current accaunt delete!")
//            case .failed:
//                self.failedDeleteAccount()
//                self.setupFailedAlertDeleteAccount(title: "Error", message: "Something went wrong. Try again!")
//            case .requiresRecentLogin:
//                self.failedDeleteAccount()
//                self.wrapperOverDeleteAlert(title: "Error", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
//            case .networkError:
//                self.failedDeleteAccount()
//                self.setupFailedAlertDeleteAccount(title: "Error", message: "Server connection problems. Try again!")
//            case .userNotFound:
//                self.failedDeleteAccount()
//                self.setupFailedAlertDeleteAccount(title: "Error", message: "You need to re-login to your account!")
//            default:
//                self.failedDeleteAccount()
//                self.setupFailedAlertDeleteAccount(title: "Error", message: "Something went wrong. Try again!")
//            }
//        }
    }
    
    private func failedDeleteAccount() {
        self.isAnimatedRemovalOfButtonsForAnonUser = false
        self.deleteAccountButton.configuration?.showsActivityIndicator = false
    }

    func setupAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in

        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func setupFailedAlertDeleteAccount(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // save data user remuveProducts
//            self.saveRemuveCartProductFB()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }



    func setupDeleteAlert(title: String, message: String, isDeleteCompletion: @escaping (Bool) -> Void) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "DELETE", style: .destructive) { action in
            isDeleteCompletion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            isDeleteCompletion(false)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupSignOutAlert(title: String, message: String, isDeleteCompletion: @escaping (Bool) -> Void) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let signOutAction = UIAlertAction(title: "SignOut", style: .destructive) { action in
            isDeleteCompletion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            isDeleteCompletion(false)
        }

        alert.addAction(signOutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

}


// MARK: -SignInViewControllerDelegate

extension ProfileController:DidChangeUserDelegate {
    func userChanged(isFromAnon: Bool) {
        print("func userChanged(isFromAnon: Bool)")
    }
//    SignInViewControllerDelegate
//    func userIsPermanent() {
//        guard let user = currentUser else {return}
//        self.updateUIForPermanentUser(user)
//    }
}


// MARK: - ProfileModelOutput
extension ProfileController:ProfileModelOutput {
    func updateUserProfile(with userData: UserProfile) {
        <#code#>
    }
}


// MARK: - UIImagePickerControllerDelegate + UINavigationControllerDelegate

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker(source:UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originImage = info[.editedImage] as? UIImage {
        let size = CGSize(width: 400, height: 400)
        // а что если compressedImage придет nil?
        let compressedImage = originImage.thumbnailOfSize(size)
        casheImageUserSavedOnTheServer = imageUser.image
        imageUser.image = compressedImage
        imageUser.contentMode = .scaleAspectFill
        imageUser.clipsToBounds = true
        dataForNewImageUser = compressedImage?.jpegData(compressionQuality: 0.2)
        isChangedCurrentImageUser = true
        enableSaveButton(isSwitch: true)
        } else {
            setupAlert(title: "Error", message: "Failed to get edited image! Try again!")
        }
        dismiss(animated: true, completion: nil)
    }
}


extension UIImageView {

    func fetchingImageWithPlaceholder(url: String, defaultImage: UIImage?) {
//        let storage = Storage.storage()
//        let urlRef = storage.reference(forURL: url)
//        self.sd_setImage(with: urlRef, maxImageSize: 1024*1024, placeholderImage: defaultImage, options: .refreshCached) { (image, error, cashType, storageRef) in
////            print(" func fetchingImageWithPlaceholder - storageRef - \(storageRef)")
//            FBManager.shared.avatarRef = storageRef
//            if error != nil {
//                self.image = defaultImage
//            }
//        }
    }
}

// MARK: - configureNavigationBar
//UIViewController

//extension ProfileController {
//
//    /// configure navigationBar and combines status bar with navigationBar
//    func configureProfileNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
//    if #available(iOS 13.0, *) {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.backgroundColor = backgoundColor
//        navBarAppearance.shadowColor = .clear
//
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.compactAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//
//        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationItem.title = title
//
//    } else {
//        // Fallback on earlier versions
//        navigationController?.navigationBar.barTintColor = backgoundColor
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationController?.navigationBar.isTranslucent = false
////        navigationController?.navigationBar.layer.shadowColor = nil
//        navigationItem.title = title
//    }
//}}
