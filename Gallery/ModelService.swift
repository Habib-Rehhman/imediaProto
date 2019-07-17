//
//  ModelService.swift
//  iMediaProto
//
//  Created by Habib on 7/12/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit

class ModalService {
    
    enum presentationDirection {
        case left
        case right
        case top
        case bottom
    }
    
    class func present(_ modalViewController: UIViewController,
                       presenter fromViewController: UIViewController,
                       enterFrom direction: presentationDirection = .right,
                       duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype(rawValue: ModalService.transitionSubtype(for: direction))
        let containerView: UIView? = fromViewController.view.window
        containerView?.layer.add(transition, forKey: nil)
        fromViewController.present(modalViewController, animated: false)
    }
    
    class func dismiss(_ modalViewController: UIViewController,
                       exitTo direction: presentationDirection = .right,
                       duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype(rawValue: ModalService.transitionSubtype(for: direction, forExit: true))
        if let layer = modalViewController.view?.window?.layer {
            layer.add(transition, forKey: nil)
        }
        modalViewController.dismiss(animated: false)
    }
    
    private class func transitionSubtype(for direction: presentationDirection, forExit: Bool = false) -> String {
        if (forExit == false) {
            switch direction {
            case .left:
                return CATransitionSubtype.fromLeft.rawValue
            case .right:
                return CATransitionSubtype.fromRight.rawValue
            case .top:
                return CATransitionSubtype.fromBottom.rawValue
            case .bottom:
                return CATransitionSubtype.fromTop.rawValue
            }
        } else {
            switch direction {
            case .left:
                return CATransitionSubtype.fromRight.rawValue
            case .right:
                return CATransitionSubtype.fromLeft.rawValue
            case .top:
                return CATransitionSubtype.fromTop.rawValue
            case .bottom:
                return CATransitionSubtype.fromBottom.rawValue
            }
        }
    }
}
