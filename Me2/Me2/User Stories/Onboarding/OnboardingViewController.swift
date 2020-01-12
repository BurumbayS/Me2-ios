//
//  OnboardingViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let titles = ["Общий чат в любом заведении","Удобный поиск на карте","Бронирование столиков онлайн"]
    let pageImages = ["onboarding_1","onboarding_2","onboarding_3"]
    let texts = ["Отмечайся в заведении и общайся в общем чате с другими посетителями!",
                 "Легко находи лучшие заведения и интересные события в твоем городе!",
                 "Забронируй столик в одном из наших заведениях-партнерах, и мы уведомим твоих приглашенных друзей"]
    
    var currentPage = 0
    var currentScrollContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCOllectionView()
    }
    
    private func configureCOllectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(OnboardingPageCollectionViewCell.self)
    }

    @IBAction func startPressed(_ sender: Any) {
        window.rootViewController = Storyboard.signInOrUpViewController()
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingPageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let model = OnboardingModel(title: titles[indexPath.row], text: texts[indexPath.row], illustration: pageImages[indexPath.row])
        cell.configure(model: model)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(ceil(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        
        currentPage = page
    }
}
