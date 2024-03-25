//
//  ImageService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 25.03.24.
//

import FirebaseStorageUI
import UIKit

class ImageService {
    static let shared = ImageService()
    
    private init() {}
    
    func loadImage(from url: String, to imageView: UIImageView, placeholderImage: UIImage?) {
//        let reference = Storage.storage().reference(forURL: url)
//        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        let urlRef = Storage.storage().reference(forURL: url)
        imageView.sd_setImage(with: urlRef, placeholderImage: nil) { (image, error, cacheType, url) in
            guard let image = image, error == nil else {
                // Обработка ошибок
                imageView.image = nil
                print("Returned message for analytic FB Crashlytics error ShopCell - \(String(describing: error?.localizedDescription))")
                return
            }
            // Настройка цвета изображения в зависимости от текущей темы
            if #available(iOS 13.0, *) {
                let tintableImage = image.withRenderingMode(.alwaysTemplate)
                imageView.image = tintableImage
            } else {
                imageView.image = image
            }
        }
    }
}
