//
//  LiveChatViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class LiveChatViewController: UIViewController {

    @IBOutlet weak var participantsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }

    private func configureCollectionView() {
        participantsCollectionView.delegate = self
        participantsCollectionView.dataSource = self
        
        participantsCollectionView.registerNib(ParticipantCollectionViewCell.self)
    }
}

extension LiveChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ParticipantCollectionViewCell = participantsCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        return cell
    }
    
    
}
