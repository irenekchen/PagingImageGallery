//
//  Dzifile.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

import Foundation
import UIKit

public class Dzifile {
    
    let tileSize: Int
    let overlap: Int
    let format: String
    let tileSourceUrl: String
    let width: CGFloat
    let height: CGFloat
    
    init(tileSize: Int, overlap: Int, format: String, tileSourceUrl: String, width: CGFloat, height: CGFloat) {
        self.tileSize = tileSize
        self.overlap = overlap
        self.format = format
        self.tileSourceUrl = tileSourceUrl
        self.width = width
        self.height = height
    }
}



