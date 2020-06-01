//
//  ThirdPageViewController.swift
//  DwGuideAnimationDemo
//
//  Created by 吴迪玮 on 2020/5/29.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ThirdPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var handAndMobileView: UIView!
    
    fileprivate let inProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    fileprivate let outProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInProgress()
    }
    
    private func setupInProgress() {
        let inProgressInputSecondHalf = inProgressInput
            .map { $0 < 0.5 ? 0 : $0 * 2 - 1.0 }.share()
//        let inProgressInputLastQuarter = inProgressInput
//            .map { $0 < 0.75 ? 0 : ($0 - 0.75) * 4 }.share()
        
        inProgressInputSecondHalf
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                var newPercent = percent < 0.4 ? 0 : (percent - 0.4) * 2
                // 为了有那个弹一下的效果
                if newPercent > 1.1 {
                    newPercent = 1.1 - (newPercent - 1.1)
                }
                
                self.imageView1.transform = CGAffineTransform(scaleX: newPercent, y: newPercent)
                self.imageView2.transform = CGAffineTransform(scaleX: newPercent, y: newPercent)
                self.imageView3.transform = CGAffineTransform(scaleX: newPercent, y: newPercent)
                self.imageView4.transform = CGAffineTransform(scaleX: newPercent, y: newPercent)
                self.imageView1.alpha = min(newPercent, 1.0)
                self.imageView2.alpha = min(newPercent, 1.0)
                self.imageView3.alpha = min(newPercent, 1.0)
                self.imageView4.alpha = min(newPercent, 1.0)
                
            }).disposed(by: disposeBag)
        
        inProgressInputSecondHalf
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }
                // 手机
                self.handAndMobileView.alpha = percent
                self.handAndMobileView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 4 * (1 - percent))
                
                // 文字出场
                self.titleLabel.alpha = percent
                self.subtitleLabel.alpha = percent
                
                self.titleLabel.transform = CGAffineTransform(translationX: 300 - 300 * percent, y: 0).scaledBy(x: percent, y: percent)
                self.subtitleLabel.transform = CGAffineTransform(translationX: -300 + 300 * percent, y: 0).scaledBy(x: percent, y: percent)
            }).disposed(by: disposeBag)
    }
}

extension Reactive where Base: ThirdPageViewController {
    internal var inProgress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.inProgressInput.accept(percent)
        }
    }
}
