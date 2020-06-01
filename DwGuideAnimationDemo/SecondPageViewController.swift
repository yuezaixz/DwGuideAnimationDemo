//
//  SecondPageViewController.swift
//  DwGuideAnimationDemo
//
//  Created by 吴迪玮 on 2020/5/29.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SecondPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    fileprivate let inProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    fileprivate let outProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInProgress()
        setupOutProgress()
    }
    
    private func setupInProgress() {
        // 文字出场
        inProgressInput
            .map { $0 < 0.5 ? 0 : $0 * 2 - 1.0 }
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                self.titleLabel.alpha = percent
                self.subtitleLabel.alpha = percent
                
                self.titleLabel.transform = CGAffineTransform(translationX: 300 - 300 * percent, y: 0).scaledBy(x: percent, y: percent)
                self.subtitleLabel.transform = CGAffineTransform(translationX: -300 + 300 * percent, y: 0).scaledBy(x: percent, y: percent)
            }).disposed(by: disposeBag)
    }
    
    private func setupOutProgress() {
        
        outProgressInput.subscribe(onNext: { [weak self] percent in
            guard let self = self else { return }
            
        }).disposed(by: disposeBag)
        
        // 文字出场
        outProgressInput
            .map { min($0 * 2, 1.0) }
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                
                self.titleLabel.alpha = max(1 - percent * 1.5, 0.0)
                self.subtitleLabel.alpha = max(1 - percent * 1.5, 0.0)
                
                CGAffineTransform(translationX: -150 * percent, y: 0).scaledBy(x: 1 - percent, y: 1 - percent)
                self.titleLabel.transform = CGAffineTransform(translationX: 300 * percent, y: 0).scaledBy(x: 1 - percent / 2, y: 1 - percent / 2)
                self.subtitleLabel.transform = CGAffineTransform(translationX: -300 * percent, y: 0).scaledBy(x: 1 - percent / 2, y: 1 - percent / 2)
            }).disposed(by: disposeBag)
    }
}


extension Reactive where Base: SecondPageViewController {
    internal var inProgress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.inProgressInput.accept(percent)
        }
    }
    internal var outProgress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.outProgressInput.accept(percent)
        }
    }
}
