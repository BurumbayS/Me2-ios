//
//  MediaMessageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import NVActivityIndicatorView
import AVKit
import ImageSlideshow

class MediaMessageCollectionViewCell: UICollectionViewCell {
    
    let thumbnailImageView = UIImageView()
    let imageView = ImageSlideshow()
    let timeLabel = UILabel()
    let mediaView = UIView()
    var loader: NVActivityIndicatorView!
    let mediaSideConstraints = ConstraintGroup()
    
    var presenterDelegate: ControllerPresenterDelegate!
    var parentVC: UIViewController!
    
    var message: Message!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: Message, vc: UIViewController) {
        self.message = message
        self.parentVC = vc
        
        self.timeLabel.text = message.getTime()
        
        if message.status == .pending {
            loader.startAnimating()
        }
        
        setThumbnail()
        updateMessagePostiton()
    }
    
    private func setThumbnail() {
        if let media = message.file {
            switch message.type {
            case .IMAGE:
                
                thumbnailImageView.isHidden = true
                imageView.isHidden = false
                
                if let url = URL(string: media.file) {
                    imageView.setImageInputs([KingfisherSource(url: url, placeholder: UIImage(), options: [])])
                } else {
                    imageView.setImageInputs([ImageSource(image: media.thumbnailImage ?? UIImage())])
                }
                
            case .VIDEO:
                
                thumbnailImageView.isHidden = false
                imageView.isHidden = true
                
                if media.thumbnail != "" {
                    self.thumbnailImageView.kf.setImage(with: URL(string: media.thumbnail), placeholder: UIImage(), options: [])
                } else {
                    self.thumbnailImageView.image = media.thumbnailImage
                }
                
            default:
                break
            }
        }
    }
    
    private func updateMessagePostiton() {
        if message.isMine() {
            constrain(mediaView, self.contentView, replace: mediaSideConstraints) { media, view in
                media.right == view.right - 10
            }
        } else {
            constrain(mediaView, self.contentView, replace: mediaSideConstraints) { media, view in
                media.left == view.left + 10
            }
        }
    }
    
    private func setUpViews() {
        let timeView = UIView()
        timeView.layer.cornerRadius = 7
        timeView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        timeView.addSubview(timeLabel)
        constrain(timeLabel, timeView) { label, view in
            label.left == view.left + 5
            label.right == view.right - 5
            label.top == view.top
            label.bottom == view.bottom
        }
        
        imageView.contentScaleMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMedia)))
//        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        self.mediaView.addSubview(imageView)
        constrain(imageView, self.mediaView) { image, view in
            image.centerX == view.centerX
            image.centerY == view.centerY
            image.width == 250
            image.height == 250
        }
        
        thumbnailImageView.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMedia)))
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 5
        self.mediaView.addSubview(thumbnailImageView)
        constrain(thumbnailImageView, self.mediaView) { image, view in
            image.top == view.top
            image.bottom == view.bottom
            image.left == view.left
            image.right == view.right
        }
        
        mediaView.addSubview(timeView)
        constrain(timeView, mediaView) { time, media in
            time.right == media.right - 5
            time.bottom == media.bottom - 5
            time.height == 14
        }
        
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .lineSpinFadeLoader, color: .gray, padding: 0)
        mediaView.addSubview(loader)
        constrain(loader, mediaView) { loader, media in
            loader.centerX == media.centerX
            loader.centerY == media.centerY
            loader.width == 20
            loader.height == 20
        }
        
        mediaView.layer.cornerRadius = 5
        mediaView.backgroundColor = Color.lightGray
        mediaView.clipsToBounds = true
        self.contentView.addSubview(mediaView)
        constrain(mediaView, self.contentView) { media, view in
            media.top == view.top
            media.bottom == view.bottom
            media.height == 250
            media.width == 250
        }
        constrain(mediaView, self.contentView, replace: mediaSideConstraints) { media, view in
            media.left == view.left + 10
        }
        
    }
    
    private func turnSoundOn() {
        //turn sounds on in silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    @objc private func openMedia() {
        switch message.type {
        case .IMAGE:
            imageView.presentFullScreenController(from: parentVC)
        case .VIDEO:
            playVideo()
        default:
            break
        }
    }
    
    @objc private func playVideo() {
        turnSoundOn()
        
        let path = message.file?.file ?? ""
        let encodedPath = path.removingPercentEncoding
        let player = AVPlayer(url: URL(fileURLWithPath: encodedPath ?? ""))
        let vc = AVPlayerViewController()
        vc.player = player

        parentVC.present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
