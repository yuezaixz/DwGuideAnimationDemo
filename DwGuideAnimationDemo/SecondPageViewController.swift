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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    fileprivate let progressInput = BehaviorRelay<CGFloat>(value: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension Reactive where Base: SecondPageViewController {
    internal var progress: Binder<CGFloat> {
        return Binder(base) { vc, percent in
            vc.progressInput.accept(percent)
        }
    }
}
