//
//  ViewController.swift
//  DwGuideAnimationDemo
//
//  Created by 吴迪玮 on 2020/5/29.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

fileprivate extension Reactive where Base: UIScrollView {
    var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        })
    }
}

fileprivate extension UIScrollView {
    func setCurrentPage(_ page: Int, animated: Bool) {
        var rect = bounds
        rect.origin.x = rect.width * CGFloat(page)
        rect.origin.y = 0
        scrollRectToVisible(rect, animated: animated)
    }
}


class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var bgViews: [UIView]!
    var currentBgIndex = 0
    var videoIndex = -1
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playView(0)
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height)
        mainScrollView.rx.currentPage
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pageControl.currentPage = $0
                self.playView($0)
            })
            .disposed(by: disposeBag)
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FirstPageViewController") as! FirstPageViewController
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FirstPageViewController") as! FirstPageViewController
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FirstPageViewController") as! FirstPageViewController
        mainScrollView.addSubview(vc1.view)
        mainScrollView.addSubview(vc2.view)
        mainScrollView.addSubview(vc3.view)
        vc1.view.snp.makeConstraints { make in
            make.width.height.left.top.bottom.equalToSuperview()
        }
        vc2.view.snp.makeConstraints { make in
            make.width.height.top.bottom.equalToSuperview()
            make.left.equalTo(vc1.view.snp.right)
        }
        vc3.view.snp.makeConstraints { make in
            make.width.height.right.top.bottom.equalToSuperview()
            make.left.equalTo(vc2.view.snp.right)
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // 放开的情况调用
    func playView(_ index: Int) {
        guard videoIndex != index else { return }
        videoIndex = index
        let duration: TimeInterval = mainScrollView.isTracking ? 0.2 : 0.5
        let currentBg = self.bgViews[self.currentBgIndex % 2]
        self.currentBgIndex += 1
        let nextBg = self.bgViews[self.currentBgIndex % 2]
        if currentBgIndex % 2 == 0 {
            try? VideoBackground.shared.play(
                view: nextBg,
                videoName: "clip\(videoIndex + 1)",
                videoType: "mp4",
                isMuted: true
            )
        } else {
            try? VideoBackground.shared2.play(
                view: nextBg,
                videoName: "clip\(videoIndex + 1)",
                videoType: "mp4",
                isMuted: true
            )
        }
        
        
        UIView.animate(withDuration: duration, animations: {
            currentBg.alpha = 0.0
        }) {  _ in
            if self.currentBgIndex % 2 == 0 {
                VideoBackground.shared2.cleanUp()
            } else {
                VideoBackground.shared.cleanUp()
            }
        }
        UIView.animate(withDuration: duration, animations: {
            nextBg.alpha = 1.0
        })
        
    }
}

