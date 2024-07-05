//
//  VideoTrimmerVC.swift
//  Narendra Modi App
//  Created by Priyal on 15/02/24.


import UIKit
import AVFoundation
import Foundation
import AVKit
import ABVideoRangeSlider
import VideoTrim
import MobileCoreServices

class VideoTrimmerVC: UIViewController, ABVideoRangeSliderDelegate{
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        videoLayerView.pause()
        img.isHidden = false
        isEdit = true
        var s = startTimeInSeconds
        var e = endTimeInSeconds
        startTimeInSeconds = startTime
        endTimeInSeconds = endTime
        var image : UIImage?
        if e == endTime {
            s = startTimeInSeconds
            image = videoLayerView.captureThumbnailImage(time: startTime, isEdit: true)
        } else if startTime == s {
            e = endTimeInSeconds
            image = videoLayerView.captureThumbnailImage(time: endTime, isEdit: true)
        }
          img.image = image
    }
    
    func didEndValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        trimVideo(sourceURL: videoUrl!.url, startTime: startTime, endTime: endTime) { [self] url, error in
            
            if let trimmedURL = url {
                DispatchQueue.main.async { [self] in
                    trimmedUrl = trimmedURL
                    print("size in mb ",fileSizeInMB(atPath: trimmedURL) as Any)
                    lblSize.text = getString(anything: fileSizeInMB(atPath: trimmedURL))
                }
                print("Trimmed video URL: \(trimmedURL)")
            } else if let error = error {
                print("Error trimming video: \(error.localizedDescription)")
            }
        }
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        if endTimeInSeconds == position {
             videoLayerView.pause()
        } else {
        }
        print(position)      // Prints the position of the Progress indicator in seconds
    }
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var videoLayerView: NMVideoPlayer!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var trimmerView: ABVideoRangeSlider!
    @IBOutlet weak var videoView: UIView!
    
    var playerViewController: AVPlayerViewController!
    var player: AVPlayer!
    var videoUrl: AVURLAsset?
    var recordedVideo : URL?
    var isEdit : Bool = false
    var startTimeInSeconds : Double = 0.0
    var endTimeInSeconds : Double = 0.0
    var imageView: UIImageView = UIImageView()
    var exportSession: AVAssetExportSession?
    var tempUrl : AVURLAsset?
    var trimmedUrl : URL?
    var isFromRecorded : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tempUrl = videoUrl
        setupPlayer()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        videoLayerView.addGestureRecognizer(tapGesture)
        addVideoObserver()
    }
    
    func addVideoObserver() {
        videoLayerView.avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
            // This block will be called every second
            let currentTimeSeconds = CMTimeGetSeconds(time)
            if Int(currentTimeSeconds) == Int(self.endTimeInSeconds) {
                self.videoLayerView.playVideo(startTimeInSeconds: self.startTimeInSeconds)
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        img.isHidden = true
        // Pause or play the video when tapped
        if videoLayerView.isplay {
            videoLayerView.pause()
        } else {
            if !isEdit{
                videoLayerView.resume()
            } else {
                videoLayerView.playVideo(startTimeInSeconds: startTimeInSeconds)
            }
        }
    }
    
    private func setupPlayer(){
        videoLayerView.setUp(videoFileName: (videoUrl?.url.absoluteString)!)
        videoLayerView.playVideo(startTimeInSeconds: 0)
        trimmerView.setVideoURL(videoURL:videoUrl!.url)
        trimmerView.hideProgressIndicator()
        trimmerView.startTimeView.timeLabel.isHidden = true
        trimmerView.startTimeView.backgroundView.backgroundColor = .clear
        trimmerView.endTimeView.timeLabel.isHidden = true
        trimmerView.endTimeView.backgroundView.backgroundColor = .clear
        trimmerView.delegate = self
        trimmerView.delegate = self
        let asset = videoUrl
        self.exportSession = AVAssetExportSession(asset: asset!, presetName: AVAssetExportPresetMediumQuality)
        let full = CMTimeMultiplyByFloat64(exportSession!.asset.duration, multiplier: 1.0)
        let range = CMTimeRangeMake(start: .zero, duration: full)
        exportSession?.timeRange = range
        self.lblSize.text = getString(anything: fileSizeInMB(atPath: videoUrl!.url))
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        let thumbnailImage = videoLayerView.captureThumbnailImage(time: endTimeInSeconds)
        let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC") as! PostSelectImgVC
        vc.isFrom = true
        vc.btnVideoImg = thumbnailImage
        vc.videoUrl = trimmedUrl
        if trimmedUrl == nil {
            vc.videoUrl = videoUrl?.url
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: @escaping (URL?, Error?) -> Void) {
        let asset = AVURLAsset(url: sourceURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create export session"]))
            return
        }
        
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.mp4")
        // Remove existing file
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: outputURL)
        } catch {
            // Ignore if file doesn't exist
        }
        
        exportSession.outputURL = outputURL
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = AVFileType.mov
        let start = CMTimeMakeWithSeconds(startTime, preferredTimescale: asset.duration.timescale)
        let end = CMTimeMakeWithSeconds(endTime-startTime, preferredTimescale: asset.duration.timescale) // Corrected duration calculation
        let range = CMTimeRangeMake(start: start, duration: end)
        exportSession.timeRange = range
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputURL, nil)
            case .failed:
                completion(nil, exportSession.error)
            case .cancelled:
                completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Export cancelled"]))
            default:
                break
            }
        }
    }
    func fileSizeInMB(atPath path: URL) -> String? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path.path)
            if let fileSize = attributes[.size] as? UInt64 {
                // Convert bytes to megabytes
                let fileSizeInMB = String(format: "%.2f MB", Double(fileSize) / (1024 * 1024))
                return fileSizeInMB
            } else {
                print("Failed to retrieve file size attribute")
                return nil
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}

open class NMVideoPlayer: UIView {
    
    static let shared = NMVideoPlayer()
    var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    var isplay : Bool = false
    
    //MARK:- Lifecycle Methods
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avPlayerLayer?.frame = self.layer.bounds
    }
    
    func setUp(videoFileName: String) {
        if let videoURL = URL(string: videoFileName) {
            avPlayer = AVPlayer(url: videoURL)
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer?.videoGravity = .resizeAspect
            avPlayerLayer?.frame = self.layer.bounds
            self.layer.addSublayer(avPlayerLayer!)
        }
    }
    
    func playVideo(startTimeInSeconds : Double) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [self] in
            let startTime = CMTime(seconds: startTimeInSeconds, preferredTimescale: 1)
            avPlayer?.seek(to: startTime)
            avPlayer?.play()
            isplay = true
        }
    }
    
    func pause() {
        avPlayer?.pause()
        isplay = false
    }
    
    func resume() {
        isplay = true
        avPlayer?.play()
    }
    
    func stop() {
        avPlayer?.pause()
        avPlayerLayer?.removeFromSuperlayer()
        avPlayer = nil
        avPlayerLayer = nil
        isplay = false
    }
    
    func captureThumbnailImage(time: Double, isEdit: Bool = false) -> UIImage? {
        guard let playerItem = avPlayer?.currentItem else {
            return nil
        }
        
        let generator = AVAssetImageGenerator(asset: playerItem.asset)
        generator.appliesPreferredTrackTransform = true
        let customTime = CMTime(seconds: time, preferredTimescale: 1)
        do {
            let cgImage = try generator.copyCGImage(at: customTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error capturing thumbnail image: \(error)")
            return nil
        }
    }
    
}
