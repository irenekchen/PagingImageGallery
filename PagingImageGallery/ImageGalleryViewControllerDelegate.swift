//
//  ImageGalleryViewControllerDelegate.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

//used by main view to put in files to throw into the imagegalleryviewcontroller

protocol ImageGalleryViewControllerDelegate {
    var dziFiles: [Dzifile] { get }
    var captions: [String?] { get }
}
