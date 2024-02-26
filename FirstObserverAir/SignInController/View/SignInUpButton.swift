//
//  SignInUpButton.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.02.24.
//

import UIKit

class SignInUpProcessButton: UIButton {
    var isSignInProcessActive = false {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }

    var titleButtonProcess: String
    var titleButtonStart: String

    init(titleButtonProcess: String, titleButtonStart: String) {
        self.titleButtonProcess = titleButtonProcess
        self.titleButtonStart = titleButtonStart
        super.init(frame: .zero)

        var configuration = UIButton.Configuration.gray()
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple
        self.configuration = configuration

        self.configurationUpdateHandler = { [weak self] button in
            guard let isSignInProcessActive = self?.isSignInProcessActive else {return}
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = R.Colors.label
                outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
                return outgoing
            }
            config?.imagePadding = 10
            config?.imagePlacement = .trailing
            config?.showsActivityIndicator = isSignInProcessActive
            config?.title = isSignInProcessActive ? self?.titleButtonProcess : self?.titleButtonStart
            button.isUserInteractionEnabled = !isSignInProcessActive
            button.configuration = config
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

