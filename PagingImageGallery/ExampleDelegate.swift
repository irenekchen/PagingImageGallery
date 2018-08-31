//
//  ExampleDelegate.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

import Foundation

public class ExampleDelegate : ImageGalleryViewControllerDelegate {
    
    
    public var dziFiles: [Dzifile] = [
        Dzifile(tileSize: 254, overlap: 1, format: "jpg", tileSourceUrl: "http://localhost:8888/image_files/Curiosity/Curiosity_files", width: 12909, height: 7719),
        Dzifile(tileSize: 254, overlap: 1, format: "jpg", tileSourceUrl: "http://localhost:8888/image_files/M51/M51_files", width: 11477, height: 7965),
        Dzifile(tileSize: 254, overlap: 1, format: "jpg", tileSourceUrl: "http://localhost:8888/image_files/PillarsOfCreation/PillarsOfCreation_files", width: 6780, height: 7071)]
    
    
    public var captions:[String?] = [
        "Hi, I'm Curiosity, and I like taking selfies",
        "Space is awesomeeeeeeee!!!",
        "This is the Pillars of Creation."
    ]
}

