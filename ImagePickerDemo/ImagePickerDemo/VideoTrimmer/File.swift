//
//  File.swift
//  ImagePickerDemo
//
//  Created by Priyal on 22/02/24.
//

import Foundation

//let asset = AVAsset(url: sourceURL)
//let composition = AVMutableComposition()
//var videoTrack : AVAssetTrack?
//var audioTrack : AVAssetTrack?
//asset.loadTracks(withMediaType: .video) { tracks, error in
//    if let tracks {
//        videoTrack = tracks.first
//    }
//}
//
//asset.loadTracks(withMediaType: .audio) { tracks, error in
//    if let tracks {
//        audioTrack = tracks.first
//    }
//}
//
////        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
////            completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get video track"]))
////            return
////        }
////        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
////            completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get audio track"]))
////            return
////        }
//let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
//let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//do {
//    let startTimeValue = CMTime(seconds: startTime, preferredTimescale: Int32(asset.duration.timescale))
//    let endTimeValue = CMTime(seconds: endTime, preferredTimescale: Int32(asset.duration.timescale))
//    
//    if let videoTrack {
//        try compositionVideoTrack?.insertTimeRange(CMTimeRange(start: startTimeValue, end: endTimeValue),of: videoTrack, at: .zero)
//    }
//    
//    if let audioTrack {
//        try compositionAudioTrack?.insertTimeRange(CMTimeRange(start: startTimeValue, end: endTimeValue),of: audioTrack, at: .zero)
//    }
//} catch {
//    completion(nil, error)
//    return
//}
//guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
//    completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create export session"]))
//    return
//}
//let outURL = URL(string: NSTemporaryDirectory())?.appendingPathComponent("trimmedVideo.mp4")
//exportSession.outputURL = outURL
//exportSession.outputFileType = .mp4
//exportSession.exportAsynchronously {
//    switch exportSession.status {
//    case .completed:
//        completion(outURL, nil)
//    case .failed:
//        completion(nil, exportSession.error)
//    case .cancelled:
//        completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Export cancelled"]))
//    default:
//        break
//    }
//}


//func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: @escaping (URL?, Error?) -> Void) {
//    let asset = AVURLAsset(url: sourceURL)
//    
//    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
//        completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create export session"]))
//        return
//    }
//    
//    let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.mp4")
//    // Remove existing file
//    let fileManager = FileManager.default
//    do {
//        try fileManager.removeItem(at: outputURL)
//    } catch {
//        // Ignore if file doesn't exist
//    }
//    
//    exportSession.outputURL = outputURL
//    exportSession.shouldOptimizeForNetworkUse = true
//    exportSession.outputFileType = AVFileType.mov
//    let start = CMTimeMakeWithSeconds(startTime, preferredTimescale: asset.duration.timescale)
//    let end = CMTimeMakeWithSeconds(endTime-startTime, preferredTimescale: asset.duration.timescale) // Corrected duration calculation
//    let range = CMTimeRangeMake(start: start, duration: end)
//    exportSession.timeRange = range
//    
//    exportSession.exportAsynchronously {
//        switch exportSession.status {
//        case .completed:
//            completion(outputURL, nil)
//        case .failed:
//            completion(nil, exportSession.error)
//        case .cancelled:
//            completion(nil, NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Export cancelled"]))
//        default:
//            break
//        }
//    }
//}
