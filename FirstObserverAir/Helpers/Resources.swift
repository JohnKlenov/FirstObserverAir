//
//  Resources.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import Foundation
import UIKit


enum R {
    
    // MARK: - Colors -
    enum Colors {
        
        // DarkMode
        
        static let backgroundBlack = UIColor(hexString: "#000000")
        
        static let systemBackground = UIColor.systemBackground
        static let secondarySystemBackground = UIColor.secondarySystemBackground
        
        static let label = UIColor.label
        static let secondaryLabel = UIColor.secondaryLabel
        static let tertiaryLabel = UIColor.tertiaryLabel
        static let quaternaryLabel = UIColor.quaternaryLabel
        static let labelWhite = UIColor(hexString: "#FFFFFF")
        
        static let placeholderText = UIColor.placeholderText
        
        static let separator = UIColor.separator
        static let opaqueSeparator = UIColor.opaqueSeparator
        
        static let referenceColor = UIColor.systemBlue
        
        static let systemFill = UIColor.systemFill
        
        static let systemGray2 = UIColor.systemGray2
        static let systemGray3 = UIColor.systemGray3
        static let systemGray6 = UIColor.systemGray6
        static let systemGray5 = UIColor.systemGray5
        static let systemGray = UIColor.systemGray
        
        static let systemPurple = UIColor.systemPurple
        static let systemRed = UIColor.systemRed
        static let systemGreen = UIColor.systemGreen
       
        /// custom color for dark mode
    
//        static let customSystemBackground = UIColor {
//            traitCollection -> UIColor in
//
//            switch traitCollection.userInterfaceStyle {
//            case .light,.unspecified:
//                print(" case .light,.unspecified:")
//                return R.Colors.backgroundWhiteLith2
//            case .dark:
//                print(".dark:")
//                return UIColor(hexString: "#000000FF")
//            @unknown default:
//                print("return UIColor()")
//                return UIColor()
//            }
//        }
    }

    
    // MARK: - String  -
    enum Strings {
        enum TabBarItem {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .Home: return "Home"
                case .Catalog: return "Catalog"
                case .Mall: return "Mall"
                case .Cart: return "Cart"
                case .Profile: return "Profile"
                }
            }
        }

        enum NavBar {
            static let profile = "Profile"
        }
        
        enum TabBarController {
            enum Home {
                enum ViewsHome {
                    static let segmentedControlMan = "Man"
                    static let segmentedControlWoman = "Woman"
                    static let headerProductView = "Products"
                    static let headerShopView = "Shops"
                    static let headerMallView = "Malls"
                    static let headerCategoryViewAllShops = "AllShops"
                }
            }
            enum Catalog {
                static let title = "Catalog"
            }
            enum Malls {
                static let title = "Malls"
            }
            enum Cart {
                static let title = "Cart"
                enum CartView {
                    static let imageSystemNameCart = "cart"
                    
                    static let titleLabel = "You cart is empty yet"
                    static let subtitleLabel = "The basket is waiting to be filed!"
                    
                    static let catalogButton = "Go to the catalog"
                    static let logInButton = "SignIn/SignUp"
                }
            }
            
            enum Profile {
                enum ViewsProfile {
                    static let navBarButtonEdit = "Edit"
                    static let navBarButtonSave = "Save"
                    static let navBarButtonCancel = "Cancel"
                    
                    static let signInUpButton = "SignIn/SignUp"
                    static let signOutButton = "Sign Out"
                    static let deleteButton = "Delete Account"
                    
                    static let anonymousNameTextField = "User is anonymous"
                    static let placeholderNameTextField = "Enter you name"
                }
                enum Alert {}
            }
        }
        
        enum AuthControllers {
            enum SignIn {
                static let placeholderEmailTextField = "Enter email"
                static let placeholderPasswordTextField = "Enter password"
                
                static let emailLabel = "Email"
                static let passwordLabel = "Password"
                static let signInLabel = "Sign In"
                
                static let signUpButton = "Sign Up"
                static let forgotPasswordButton = "Forgot password?"
                static let signInButtonStart = "Sign In"
                static let signInButtonProcess = "Signing In..."
                
                static let imageSystemNameEye = "eye"
                static let imageSystemNameEyeSlash = "eye.slash"
                
            }
            enum SignUP {
                static let nameLabel = "Name"
                static let emailLabel = "Email"
                static let passwordLabel = "Password"
                static let reEnterPasswordLabel = "Re-enter password"
                static let signUpLabel = "Sign Up"
                
                static let placeholderNameTextField = "Enter user name"
                static let placeholderEmailTextField = "Enter email"
                static let placeholderPasswordTextField = "Enter password"
                static let placeholderReEnterTextField = "Enter password"
                
                static let imageSystemNameEye = "eye"
                static let imageSystemNameEyeSlash = "eye.slash"
                
                static let signUpButtonStart = "Sign In"
                static let signUpButtonProcess = "Signing In..."
            }
        }
        
        enum OtherControllers {
            enum Product {
                static let websiteButton = "Original content"
                static let descriptionTitleLabel = "Description"
                static let titleTableViewLabel = "Contact Malls"
                static let titleMapLabel = "Location Malls"
                static let addToCardButton = "Add to card"
                static let addedToCardButton = "Added to card"
                
                static let imageSystemNameCart = "cart"
                static let imageSystemNameCartFill = "cart.fill"
            }
            enum BrandProducts {
                static let title = "Brand"
            }
            enum CategoryProducts {}
            enum Mall {
                static let floorPlanButton = "Flor plan"
                static let websiteMallButton = "Website mall"
                static let titleButtonsStackLabel = "Mall navigator"
                static let titleMapViewLabel = "Location mall"
            }
            enum Map {}
            enum FullScreen {
                static let deleteImageNameAssets = "Delete50"
            }
            enum OnboardPage {
                static let nextButton = "Next page"
                static let getStartedButton = "Get started"
                static let titleLabel = "Observer"
                static let presentScreenContents = ["Как правило дорогой товар не нуждается в гарантиях качества, но как найти качественный товар по средней и низкой цене?", "Observer исследует бренды среднего ценового сегмента и рекомендует товары с потенциалом качества!", "Observer это навигатор по торговым центрам в твоем кармане!"]
            }
            enum LaunchScreen {
                static let nameBrand = "Observer"
            }
        }
    }

    
    // MARK: - Image -
    enum Images {
        enum TabBarItem {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .Home: return UIImage(systemName: "house.fill")
                case .Catalog: return UIImage(systemName: "square.grid.2x2.fill")
                case .Mall: return UIImage(systemName: "m.square")
                case .Cart: return UIImage(systemName: "cart.fill")
                case .Profile: return UIImage(systemName: "person.crop.circle.fill")
                }
            }
        }

        enum Profile {
            static let defaultAvatarImage = UIImage(named: "DefaultImage")
        }
        
        enum DefaultImage {
            static let forAllProducts = UIImage(named: "DefaultImage")
        }
    }

//    enum Fonts {
//        static func helvelticaRegular(with size: CGFloat) -> UIFont {
//            UIFont(name: "Helvetica", size: size) ?? UIFont()
//
//        }
//    }
    
    enum Fonts {
        enum helveltica: String {
            case bold = "Helvetica-Bold"
            case regular = "Helvetica"
            case medium = "Helvetica-BoldOblique"
            
            public func font(size: CGFloat) -> UIFont {
                return UIFont(name: self.rawValue, size: size)!
            }
        }
    }
  
}
