//
//  ResourceServ.swift
//  ServiceKit
//
//  1. Purpose
//     Loads and caches app resources (images, models, sound).
// 2. Dependencies
//     Foundation, UIKit, ModelIO, AVFoundation
// 3. Overview
//     Provides synchronous and asynchronous load methods,
//     and simple in-memory cache.
// 4. Usage
//     let img = ResourceServ.shared.image(named: "icon")
// 5. Notes
//     Extend for remote fetching or LRU caching.

import Foundation
import UIKit
import ModelIO
import AVFoundation

public final class ResourceServ {
    public static let shared = ResourceServ()
    private init() {}

    private var imageCache: [String: UIImage] = [:]
    private var soundCache: [String: AVAudioPlayer] = [:]

    /// Loads a UIImage from main bundle, with caching.
    public func image(named name: String) -> UIImage? {
        if let img = imageCache[name] { return img }
        guard let img = UIImage(named: name) else { return nil }
        imageCache[name] = img
        return img
    }

    /// Loads a mesh asset via ModelIO.
    public func mesh(filename: String) throws -> MDLMesh {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)!
        let asset = MDLAsset(url: url)
        guard let mesh = asset.object(at: 0) as? MDLMesh else {
            throw NSError(domain: "ResourceServ", code: 2, userInfo: nil)
        }
        return mesh
    }

    /// Loads and caches an AVAudioPlayer for a sound file.
    public func sound(filename: String) throws -> AVAudioPlayer {
        if let pl = soundCache[filename] { return pl }
        let url = Bundle.main.url(forResource: filename, withExtension: nil)!
        let player = try AVAudioPlayer(contentsOf: url)
        soundCache[filename] = player
        return player
    }
}
