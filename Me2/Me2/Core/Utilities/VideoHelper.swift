//
//  VideoHelper.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import AVKit

class VideoHelper {
    
    static func encodeVideo(videoUrl: URL?, outputUrl: URL? = nil, resultClosure: @escaping (URL?) -> Void) {
        guard let url = videoUrl else {
            resultClosure(nil)
            return
        }
        
        let asset = AVAsset(url: url)
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let filePath = dirPaths[0].appendingPathComponent("Video_rendered.mp4") //create new data in file manage .mp4
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720)
        
        // remove file if already exits
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: filePath)
        
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.metadata = asset.metadata
        exportSession?.outputURL = filePath
        
        exportSession?.exportAsynchronously {
            if exportSession?.status == .completed {
                print("AV export succeeded. \(filePath)")
                resultClosure(exportSession?.outputURL)
            } else if exportSession?.status == .cancelled {
                print("AV export cancelled.")
            } else {
                print("Error is \(String(describing: exportSession?.error))")
            }
        }
    }
    
    static func getVideoThumbnail(fromURL url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {
            /* error handling here */
            print("Fail durring generating thumbnail")
        }
        return nil
    }
    
    static func generateVideoTumbnail(fromURL url: URL, completion: ((UIImage?) -> ())?) {
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let frameImg = UIImage(cgImage: img)
                completion?(frameImg)
            } catch {
                /* error handling here */
                print("Fail durring generating thumbnail")
            }
            completion?(nil)
        }
    }
}
