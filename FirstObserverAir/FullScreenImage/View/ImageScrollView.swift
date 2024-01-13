//
//  ImageScrollView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 12.01.24.
//

import UIKit
import FirebaseStorageUI

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    
    var imageZoomView: UIImageView!
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    
    var storage: Storage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        storage = Storage.storage()
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = UIScrollView.DecelerationRate.normal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ImageScrollView")
    }
    
    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        self.imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView)
        configure(image: image.size)
    }
    
    func configure(image:CGSize) {
        self.contentSize = image
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        
        self.imageZoomView.addGestureRecognizer(self.zoomingTap)
        self.imageZoomView.isUserInteractionEnabled = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageZoomView == nil {
        } else {
            self.centerImage()
        }
    }
    
    // Сдесь мы высчитываем minimumZoomScale maximumZoomScale в зависимости от величины нашего изображения
    func setCurrentMaxandMinZoomScale() {
        
        // minimumZoomScale
        let bounds = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let xScale = bounds.width / imageSize.width
        let yScale = bounds.height / imageSize.height
        
        let minScale = min(xScale, yScale)
        
        // maximumZoomScale
        var maxScale: CGFloat = 1.0
        
        if minScale > 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    // Цунтрируем наше изображение
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        imageZoomView.frame = frameToCenter
    }
    
    
    // Gesture
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    func zoomRect(scale:CGFloat, center:CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
    
    
    // Mark: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}

