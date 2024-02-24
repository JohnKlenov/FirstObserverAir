//
//  CacheManager.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 16.02.24.
//

//import UIKit
//import FirebaseStorageUI
//
//class CacheManager {
//    
//    ///удаляем кэш из памяти(оперативная и диск), кэшируются данные по forKey
//    ///удаляются сразу со всех mageView проекта
//    static func cacheImageRemoveMemoryAndDisk(imageView: UIImageView) {
//        if let cacheKey = imageView.sd_imageURL?.absoluteString {
//            SDImageCache.shared.removeImageFromDisk(forKey: cacheKey)
//            SDImageCache.shared.removeImageFromMemory(forKey: cacheKey)
//            
//            let imageCache = SDImageCache.shared
//            // Проверяем наличие изображения в кэше памяти
//            let isImageInMemoryCache = imageCache.imageFromMemoryCache(forKey: imageView.sd_imageURL?.absoluteString)
//            print("isImageInMemoryCache - \(String(describing: isImageInMemoryCache))")
//
//            // Проверяем наличие изображения в кэше диска
//            imageCache.diskImageExists(withKey: imageView.sd_imageURL?.absoluteString) { (isImageInDiskCache) in
//                if isImageInDiskCache {
//                    print("Изображение есть в кэше диска")
//                } else {
//                    print("Изображение удалено из кэша диска")
//                }
//            }
//
//        }
//    }
//}

