//
//  ImageViewController.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

//returns view controllers (zoomable images) to the paging gallery view controller

import UIKit
import MBProgressHUD
import SDWebImage

@objc public protocol ImageViewControllerDelegate {
    @objc optional func imageLoaded()
}

class ImageViewController : UIViewController {
    
    public var dziFile: Dzifile?

    public var tilingView: TilingView?
    @objc public var imageView: UIImageView!
    @objc public var scrollView: UIScrollView!
    public var loadInProgress = false

    public var imageIndex:Int?
    
    var tilingViewLeftConstraint = NSLayoutConstraint()
    var tilingViewRightConstraint = NSLayoutConstraint()
    var tilingViewTopConstraint = NSLayoutConstraint()
    var tilingViewBottomConstraint = NSLayoutConstraint()
    
    var imageViewLeftConstraint = NSLayoutConstraint()
    var imageViewRightConstraint = NSLayoutConstraint()
    var imageViewTopConstraint = NSLayoutConstraint()
    var imageViewBottomConstraint = NSLayoutConstraint()
    
    public var delegate: ImageViewControllerDelegate?
    @objc public var progressHUD: MBProgressHUD!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = UIColor.black
        let imageSize = CGSize(width: (self.dziFile?.width)!, height: (self.dziFile?.height)!)
        self.tilingView = TilingView(dziFile: self.dziFile!, imageSize: imageSize)
        
        imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: imageSize))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: imageSize))
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.insertSubview(self.tilingView!, at: 0)
        scrollView.insertSubview(imageView, at: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = false
        view.insertSubview(scrollView, at: 0)
        self.scrollView.maximumZoomScale = 4
        
        tilingViewTopConstraint = (tilingView?.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0))!
        tilingViewBottomConstraint = (tilingView?.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0))!
        tilingViewLeftConstraint = (tilingView?.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 0))!
        tilingViewRightConstraint = (tilingView?.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 0))!
        
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        imageViewLeftConstraint = imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0)
        imageViewRightConstraint = imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0)
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            imageViewTopConstraint, imageViewLeftConstraint, imageViewRightConstraint, imageViewBottomConstraint, tilingViewTopConstraint, tilingViewLeftConstraint, tilingViewRightConstraint, tilingViewBottomConstraint
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMinZoomScale()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScale()
    }
    
    fileprivate func updateMinZoomScale() {
        let boundsSize = view.bounds.size
        let imageSize = imageView.bounds.size

        let widthScale = boundsSize.width / imageSize.width
        let heightScale = boundsSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        updateConstraints()
    }
    
    fileprivate func updateConstraints() {
        let imageSize = imageView.bounds.size
        let boundsSize = view.bounds.size
        let yOffset = max(0, (boundsSize.height - imageSize.height*scrollView.zoomScale) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (boundsSize.width - imageSize.width*scrollView.zoomScale) / 2)
        imageViewLeftConstraint.constant = xOffset
        imageViewRightConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

extension ImageViewController : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
}
