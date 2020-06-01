//
//  FirstPageViewController.swift
//  DwGuideAnimationDemo
//
//  Created by 吴迪玮 on 2020/5/29.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    fileprivate let progressInput = BehaviorRelay<CGFloat>(value: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        progressInput.subscribe(onNext: { [weak self] percent in
            guard let self = self else { return }
            self.view.transform = CGAffineTransform(scaleX: 1.0 - 0.3 * percent, y: 1.0 - 0.3 * percent)
        }).disposed(by: disposeBag)
        
        progressInput.subscribe(onNext: { [weak self] percent in
            guard let self = self else { return }
            let rotationAngle = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * percent)
            
            self.imageView1.transform = rotationAngle
            self.imageView2.transform = rotationAngle
            self.imageView3.transform = rotationAngle
            self.imageView4.transform = rotationAngle
        }).disposed(by: disposeBag)
        
        // 出场动画
        progressInput
            .map { min($0 * 2, 1.0) }
            .subscribe(onNext: { [weak self] percent in
                guard let self = self else { return }

                self.titleLabel.alpha = max(1 - percent * 1.5, 0.0)
                self.subtitleLabel.alpha = max(1 - percent * 1.5, 0.0)
                
                self.titleLabel.transform = CGAffineTransform(translationX: 300 * percent, y: 0).scaledBy(x: 1 - percent / 2, y: 1 - percent / 2)
                self.subtitleLabel.transform = CGAffineTransform(translationX: -300 * percent, y: 0).scaledBy(x: 1 - percent / 2, y: 1 - percent / 2)
            }).disposed(by: disposeBag)
    }

}

extension Reactive where Base: FirstPageViewController {
    internal var progress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.progressInput.accept(percent)
        }
    }
}
