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
    
    fileprivate let inProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    fileprivate let outProgressInput = BehaviorRelay<CGFloat>(value: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInProgress()
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
}

extension Reactive where Base: ThirdPageViewController {
    internal var inProgress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.inProgressInput.accept(percent)
        }
    }
}
