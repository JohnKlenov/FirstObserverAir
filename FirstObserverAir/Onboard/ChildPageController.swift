//
//  ChildPageController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.11.23.
//

import UIKit


protocol ChildPageDelegate: AnyObject {
    func hiddenNextButton()
    func pageChangedTo(index: Int)
}

class ChildPageViewController: UIPageViewController {
    
    private let presentScreenContents = R.Strings.OtherControllers.OnboardPage.presentScreenContents
    private var currentIndex: Int?
    private var pendingIndex: Int?
    private var arrayVC: [ChildContentViewController] = []
    weak var childPageDelegate: ChildPageDelegate?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        print("deinit ChildPageViewController")
    }
}


// MARK: - Setting Views
private extension ChildPageViewController {
    
    func setupView() {
        setupArray()
        delegate = self
        dataSource = self
        setViewControllers([arrayVC[0]], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - Setting
private extension ChildPageViewController {
    
    func setupArray() {
        presentScreenContents.forEach { message in
            let vc = ChildContentViewController()
            vc.messageLabel.text = message
            arrayVC.append(vc)
        }
    }
    
    func hiddenNextButtonForPresentVC(index: Int) {
        if index == presentScreenContents.count - 1 {
            childPageDelegate?.hiddenNextButton()
        }
    }
    
}


// MARK: - UIPageViewControllerDataSource
extension ChildPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = arrayVC.firstIndex(of: viewController as! ChildContentViewController)!
                if currentIndex == 0 {
                    return nil
                }
                let previousIndex = abs((currentIndex - 1) % arrayVC.count)
                return arrayVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = arrayVC.firstIndex(of: viewController as! ChildContentViewController)!
        if currentIndex == arrayVC.count-1 {
                    return nil
                }
                let nextIndex = abs((currentIndex + 1) % arrayVC.count)
                return arrayVC[nextIndex]
    }
    
    
}


// MARK: - UIPageViewControllerDelegate
extension ChildPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstVC = pendingViewControllers.first {
            pendingIndex = arrayVC.firstIndex(of: firstVC as! ChildContentViewController)!
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
                 currentIndex = pendingIndex
                 if let index = currentIndex {
                     childPageDelegate?.pageChangedTo(index: index)
                     hiddenNextButtonForPresentVC(index: index)
                 }
             }
    }
}

extension ChildPageViewController {
    
    func nextPage(index: Int) {
        if index <= arrayVC.count-1 {
            setViewControllers([arrayVC[index]], direction: .forward, animated: true, completion: nil)
            childPageDelegate?.pageChangedTo(index: index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.hiddenNextButtonForPresentVC(index: index)
            }
        }
    }
}
