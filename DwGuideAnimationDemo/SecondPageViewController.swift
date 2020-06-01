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
        
        let inProgressInputSecondHalf = inProgressInput
            .map { $0 < 0.5 ? 0 : $0 * 2 - 1.0 }.share()
            
        // 菜篮里的元素出场动画
        inProgressInputSecondHalf.subscribe(onNext: { [weak self] percent in
            guard let self = self else { return }
            let scalePercent = (percent + 0.5) / 1.5
            self.imageView3.transform = CGAffineTransform(translationX: 0, y: 140 - 140 * percent).scaledBy(x: scalePercent, y: scalePercent)
        }).disposed(by: disposeBag)
        
        // 胡萝卜和柠檬入场动画
        inProgressInput
            .map { $0 < 0.75 ? 0 : ($0 - 0.75) * 4 }
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                self.imageView1.alpha = percent
                self.imageView2.alpha = percent
                
                self.imageView1.transform = CGAffineTransform(translationX: 53 - 53 * percent, y: 129 - 129 * percent)
                self.imageView2.transform = CGAffineTransform(translationX: -43 + 43 * percent, y: 184 - 184 * percent)
                
            }).disposed(by: disposeBag)
        
        // 文字出场
        inProgressInputSecondHalf
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                self.titleLabel.alpha = percent
                self.subtitleLabel.alpha = percent
                
                self.titleLabel.transform = CGAffineTransform(translationX: 300 - 300 * percent, y: 0).scaledBy(x: percent, y: percent)
                self.subtitleLabel.transform = CGAffineTransform(translationX: -300 + 300 * percent, y: 0).scaledBy(x: percent, y: percent)
            }).disposed(by: disposeBag)
    }
    
    private func setupOutProgress() {
        
        let outProgressInputFirstHalf = outProgressInput
            .map { min($0 * 2, 1.0) }.share()
        
        outProgressInputFirstHalf.subscribe(onNext: { [weak self] percent in
            guard let self = self else { return }
//            self.imageView1.alpha = percent //胡萝卜不消失
            self.imageView2.alpha = 1 - percent
            self.imageView3.alpha = 1 - percent
            
            self.imageView1.transform = CGAffineTransform(translationX: -10 * percent, y: -25 * percent)
            self.imageView2.transform = CGAffineTransform(translationX: 15 * percent, y: -60 * percent)
            
        }).disposed(by: disposeBag)
        
        // 文字出场
        outProgressInputFirstHalf
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
