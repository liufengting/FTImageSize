//
//  FTImageSize.swift
//  FTImageSize
//
//  Created by liufengting on 02/12/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

public extension FTImageSize {
    
    /// get image size, with perfered width and max height
    ///
    /// - Parameters:
    ///   - imageURL: image url
    ///   - perferdWidth: perferd Width
    ///   - maxHeight: max height
    /// - Returns: image size
    func getImageSizeFromImageURL(_ imageURL: String, perferdWidth: CGFloat, maxHeight: CGFloat = CGFloat(MAXFLOAT)) -> CGSize {
        return self.convertSize(size: self.getImageSize(imageURL), perferdWidth: perferdWidth, maxHeight: maxHeight)
    }
    
    /// private function: convertImageSize
    ///
    /// - Parameters:
    ///   - size: original image size
    ///   - perferdWidth: perfered width
    ///   - maxHeight: max height
    /// - Returns: image size
    func convertSize(size: CGSize, perferdWidth: CGFloat, maxHeight: CGFloat = CGFloat(MAXFLOAT)) -> CGSize {
        var convertedSize : CGSize = CGSize.zero
        if size.width == 0 || size.height == 0 {
            return CGSize(width: perferdWidth, height: perferdWidth)
        }
        convertedSize.width = perferdWidth
        convertedSize.height = min((size.height * perferdWidth) / size.width, maxHeight)
        return convertedSize
    }
}

public class FTImageSize: NSObject {
    
    public static var shared: FTImageSize = {
        return FTImageSize()
    }()
    
    /// get remote image original size with image url
    ///
    /// - Parameter imageURL: image url
    /// - Returns: image original size
    public func getImageSize(_ urlString: String) -> CGSize {
        self.getImageSize(URL(string: urlString))
    }

    
    public func getImageSize(_ url: URL?)  -> CGSize {
        guard let url = url else {
            return  CGSize.zero
        }
        var size = CGSize.zero
        let pathExtendsion = url.pathExtension.lowercased()
        if pathExtendsion == "png" {
            size = self.getPNGImageSize(url)
        } else if pathExtendsion == "gif" {
            size = self.getGIFImageSize(url)
        } else {
            size = self.getJPGImageSize(url)
        }
        if CGSize.zero.equalTo(size) {
            size = self.getImageSizeByDownload(url)
        }
        return size
    }
    
    
    private func sendSynchronousRequest(_ urlRequest: URLRequest) -> Data? {
        var data: Data?
        let semaphore = DispatchSemaphore(value:0)
        URLSession.shared.dataTask(with: urlRequest) { (resData, response, error) in
            data = resData
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return data
    }
    
    private func getImageSizeByDownload(_ url: URL) -> CGSize {
        let data = self.sendSynchronousRequest(URLRequest(url: url))
        guard let data = data else {
            return CGSize.zero
        }
        guard let image = UIImage(data: data) else {
            return CGSize.zero
        }
        return image.size
    }
    
    
    /// private function: getPNGImageSize
    ///
    /// - Parameter request: image request
    /// - Returns: image original size
    private func getPNGImageSize(_ url: URL) -> CGSize {
        var request: URLRequest = URLRequest(url: url)
        request.setValue("bytes=16-23", forHTTPHeaderField: "Range")
        guard let data = self.sendSynchronousRequest(request) else {
            return CGSize.zero
        }

        if data.count == 8 {
            var w1:Int = 0
            var w2:Int = 0
            var w3:Int = 0
            var w4:Int = 0
            (data as NSData).getBytes(&w1, range: NSMakeRange(0, 1))
            (data as NSData).getBytes(&w2, range: NSMakeRange(1, 1))
            (data as NSData).getBytes(&w3, range: NSMakeRange(2, 1))
            (data as NSData).getBytes(&w4, range: NSMakeRange(3, 1))
            
            let w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4
            var h1:Int = 0
            var h2:Int = 0
            var h3:Int = 0
            var h4:Int = 0
            (data as NSData).getBytes(&h1, range: NSMakeRange(4, 1))
            (data as NSData).getBytes(&h2, range: NSMakeRange(5, 1))
            (data as NSData).getBytes(&h3, range: NSMakeRange(6, 1))
            (data as NSData).getBytes(&h4, range: NSMakeRange(7, 1))
            let h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4
            
            return CGSize(width: CGFloat(w), height: CGFloat(h));
        }
        return CGSize.zero;
    }
    
    /// private function: getGIFImageSize
    ///
    /// - Parameter request: image request
    /// - Returns: image original size
    private func getGIFImageSize(_ url: URL) -> CGSize {
        var request = URLRequest(url: url)
        request.setValue("bytes=6-9", forHTTPHeaderField: "Range")
        guard let data = self.sendSynchronousRequest(request) else {
            return CGSize.zero
        }
        if data.count == 4 {
            var w1:Int = 0
            var w2:Int = 0
                        
            (data as NSData).getBytes(&w1, range: NSMakeRange(0, 1))
            (data as NSData).getBytes(&w2, range: NSMakeRange(1, 1))
            
            let w = w1 + (w2 << 8)
            var h1:Int = 0
            var h2:Int = 0
            
            (data as NSData).getBytes(&h1, range: NSMakeRange(2, 1))
            (data as NSData).getBytes(&h2, range: NSMakeRange(3, 1))
            let h = h1 + (h2 << 8)
            
            return CGSize(width: CGFloat(w), height: CGFloat(h));
        }

        return CGSize.zero
    }
    
    /// private function: getJPGImageSize
    ///
    /// - Parameter request: image request
    /// - Returns: image original size
    private func getJPGImageSize(_ url: URL) -> CGSize {
        var request = URLRequest(url: url)
        request.setValue("bytes=0-209", forHTTPHeaderField: "Range")
        guard let data = self.sendSynchronousRequest(request) else {
            return CGSize.zero
        }
        
        if data.count <= 0x58 {
            return CGSize.zero
            
        }
        if data.count < 210 {
            var w1:Int = 0
            var w2:Int = 0
            
            (data as NSData).getBytes(&w1, range: NSMakeRange(0x60, 0x1))
            (data as NSData).getBytes(&w2, range: NSMakeRange(0x61, 0x1))
            
            let w = (w1 << 8) + w2
            var h1:Int = 0
            var h2:Int = 0
            
            (data as NSData).getBytes(&h1, range: NSMakeRange(0x5e, 0x1))
            (data as NSData).getBytes(&h2, range: NSMakeRange(0x5f, 0x1))
            let h = (h1 << 8) + h2
            
            return CGSize(width: CGFloat(w), height: CGFloat(h));
            
        } else {
            var word = 0x0
            (data as NSData).getBytes(&word, range: NSMakeRange(0x15, 0x1))
            if word == 0xdb {
                (data as NSData).getBytes(&word, range: NSMakeRange(0x5a, 0x1))
                if word == 0xdb {
                    var w1:Int = 0
                    var w2:Int = 0
                    
                    (data as NSData).getBytes(&w1, range: NSMakeRange(0xa5, 0x1))
                    (data as NSData).getBytes(&w2, range: NSMakeRange(0xa6, 0x1))
                    
                    let w = (w1 << 8) + w2
                    var h1:Int = 0
                    var h2:Int = 0
                    
                    (data as NSData).getBytes(&h1, range: NSMakeRange(0xa3, 0x1))
                    (data as NSData).getBytes(&h2, range: NSMakeRange(0xa4, 0x1))
                    let h = (h1 << 8) + h2
                    
                    return CGSize(width: CGFloat(w), height: CGFloat(h));
                } else {
                    var w1:Int = 0
                    var w2:Int = 0
                    
                    (data as NSData).getBytes(&w1, range: NSMakeRange(0x60, 0x1))
                    (data as NSData).getBytes(&w2, range: NSMakeRange(0x61, 0x1))
                    
                    let w = (w1 << 8) + w2
                    var h1:Int = 0
                    var h2:Int = 0
                    
                    (data as NSData).getBytes(&h1, range: NSMakeRange(0x5e, 0x1))
                    (data as NSData).getBytes(&h2, range: NSMakeRange(0x5f, 0x1))
                    let h = (h1 << 8) + h2
                    
                    return CGSize(width: CGFloat(w), height: CGFloat(h));
                }
            } else {
                return CGSize.zero;
            }
        }
    }
}
