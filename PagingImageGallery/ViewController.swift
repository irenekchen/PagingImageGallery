//
//  ViewController.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

import UIKit

class ViewController: ImageGalleryViewController {

    override func viewDidLoad() {
        self.delegate = ExampleDelegate()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

