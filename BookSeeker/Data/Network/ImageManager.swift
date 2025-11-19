//
//  ImageManager.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

import UIKit

final class ImageManager {
    static let shared = ImageManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }

    func loadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        // 새로 다운로드
        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }

            cache.setObject(image, forKey: cacheKey)
            return image

        } catch {
            return nil
        }
    }
}
