//
//  Validators.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.02.24.
//

import Foundation

class Validators {
    
    /// Проверяет, что все переданные параметры не пусты.
    static func isFilled(name: String?, email: String?, password: String?, reNamePassword: String?) -> Bool {
        
        guard !(name ?? "").isEmpty, !(email ?? "").isEmpty, !(password ?? "").isEmpty, !(reNamePassword ?? "").isEmpty else {return false}
        
        return true
    }
    
    /// Проверяет, что пароль и подтверждение пароля совпадают.
    static func isReNamePassword(password: String?, reNamePassword: String?) -> Bool {
        guard password == reNamePassword else {return false}
        return true
    }
    

    ///проверки адресов электронной почты
    ///метод надежен, потому что он использует встроенные функции iOS для проверки электронной почты, и он может обрабатывать большинство вариаций адресов электронной почты.
    ///NSDataDetector может находить даты, адреса, ссылки, номера телефонов и информацию о транзите в тексте на естественном языке1
    static func isValidEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))

        guard let res = matches, res.count == 1 else { return false }

        return res.first?.url?.scheme == "mailto"
    }

    ///выполняет базовую проверку сложности пароля, учитывая его длину. 
    static func validatePassword(_ password: String) -> String {
        // Проверка длины пароля
        if password.count < 8 {
            return "failed: Пароль должен содержать не менее 8 символов."
        }

        // Проверка на наличие цифры
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        if !hasNumber {
            return "failed: Пароль должен содержать хотя бы одну цифру."
        }

        // Проверка на наличие строчной буквы
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        if !hasLowercase {
            return "failed: Пароль должен содержать хотя бы одну строчную букву."
        }

        // Проверка на наличие заглавной буквы
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        if !hasUppercase {
            return "failed: Пароль должен содержать хотя бы одну заглавную букву."
        }

        // Если все проверки пройдены
        return "success"
    }
    
    static func validateName(_ name:String) -> String {
        
        if name.count < 2 {
            return "failed: Поле должно содержать минимум 2 символа."
        }
        // Если все проверки пройдены
        return "success"
    }
    
    static func validateCountPassword(_ password: String) -> String {
        // Проверка длины пароля
        if password.count < 8 {
            return "failed: Пароль должен содержать не менее 8 символов."
        }
        // Если все проверки пройдены
        return "success"
    }
}


// MARK: - Feature

/// Проверяет, что переданная строка является валидным адресом электронной почты.
//    static func isValidEmailAddr(strToValidate: String) -> Bool {
//      let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
//
//      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
//
//      return emailValidationPredicate.evaluate(with: strToValidate)
//    }

/// Проверяет, что пароль содержит хотя бы одну строчную и прописную латинскую букву, а также цифру.
//    static func isValidPassword(passwordText: String) -> Bool {
//        let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$")
//        let isBool = password.evaluate(with: passwordText)
//        print("isValidPassword \(isBool)")
//        return password.evaluate(with: passwordText)
//    }




