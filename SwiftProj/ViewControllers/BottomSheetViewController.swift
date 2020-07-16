//
//  BottomSheetViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 16/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

extension BottomSheetViewController {
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYposition: CGFloat = 100
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height - 220 }
    }
}

class BottomSheetViewController: UIViewController {

    var task: Task?
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var otherInfoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        roundViews()
        
        infoView.layer.cornerRadius = 10
        otherInfoView.layer.cornerRadius = 10
//        if self.traitCollection.userInterfaceStyle == .dark {
//            infoView.layer.borderColor = UIColor.white
//        }
        print(task?.taskName)
        titleLabel.text = task?.taskName
        descLabel.text = task?.taskDesc
        subjectLabel.text = task?.subject
        importanceLabel.text = task?.importance
        repeatLabel.text = task?.repeatType
        ownerLabel.text = task?.taskOwner
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: {
            self.moveView(state: .partial)
        })
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYposition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYposition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 10
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 0.7
        view.clipsToBounds = true
    }

}
