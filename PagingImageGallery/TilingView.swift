//
//  TilingView.swift
//  PagingImageGallery
//
//  Created by Chen, Irene (398N-Affiliate) on 7/31/18.
//  Copyright © 2018 Chen, Irene (398N-Affiliate). All rights reserved.
//

import UIKit

public class TilingView: UIView {
    
    var dziFile: Dzifile
    var tilingView: TilingView?
    let tileBoundsVisible = true
    
    override public class var layerClass: AnyClass {
        return CATiledLayer.self
    }
    
    var tiledLayer: CATiledLayer {
        return self.layer as! CATiledLayer
    }
    
    override public var contentScaleFactor: CGFloat {
        didSet {
            super.contentScaleFactor = 1
        }
    }
    
    init(dziFile: Dzifile, imageSize: CGSize){//}, delegate:ImageDelegate?) {
        self.dziFile = dziFile

        super.init(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: imageSize.width, height: imageSize.height))
        tiledLayer.levelsOfDetail = 4
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Tile Drawing
    override public func draw(_ rect: CGRect) {
        print("DRAW RECT: \(rect.width) + \(rect.height)")
        let context = UIGraphicsGetCurrentContext()!
        // get the scale from the context by getting the current transform matrix, then asking for
        // its "a" component, which is one of the two scale components. We need to also ask for the "d" component as it might not be precisely the same as the "a" component, even at the "same" scale.
        let scaleX: CGFloat = context.ctm.a
        let scaleY: CGFloat = context.ctm.d
        
        var tileSize = CGSize(width: self.dziFile.tileSize, height: self.dziFile.tileSize)
        
        // Even at scales lower than 100%, we are drawing into a rect in the coordinate system of the full
        // image. One tile at 50% covers the width (in original image coordinates) of two tiles at 100%.
        // So at 50% we need to stretch our tiles to double the width and height; at 25% we need to stretch
        // them to quadruple the width and height; and so on.
        // (Note that this means that we are drawing very blurry images as the scale gets low. At 12.5%,
        // our lowest scale, we are stretching about 6 small tiles to fill the entire original image area.
        // But this is okay, because the big blurry image we're drawing here will be scaled way down before
        // it is displayed.)
        
        tileSize.width /= scaleX
        tileSize.height /= -scaleY
        
        // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
        let firstCol: Int = Int(floor(rect.minX/tileSize.width))
        let lastCol: Int = Int(floor((rect.maxX-1)/tileSize.width))
        let firstRow: Int = Int(floor(rect.minY/tileSize.height))
        let lastRow: Int = Int(floor((rect.maxY-1)/tileSize.height))
        
        for row in firstRow...lastRow {
            for col in firstCol...lastCol {
                guard let tile = tileFor(scale: scaleX, row: row, col: col) else {
                    return
                }
                
                var tileRect = CGRect(x: (tileSize.width)*CGFloat(col), y: (tileSize.height)*CGFloat(row), width: tileSize.width, height: tileSize.height)
                
                // if the tile would stick outside of our bounds, we need to truncate it so as
                // to avoid stretching out the partial tiles at the right and bottom edges
                tileRect = self.bounds.intersection(tileRect)
                tile.draw(in: tileRect)
                
                if tileBoundsVisible {
                    drawTileBounds(in: context, withScale: scaleX, inVisibleBounds: tileRect)
                }
            }
        }
    }
    
    //MARK: - Tile Fetching
    
    func tileFor(scale: CGFloat, row: Int, col: Int) -> UIImage? {
        let scale = scale < 1.0 ? Int(1/CGFloat(Int(1/scale))*1000) : Int(scale*1000)
        let calibratedScale:CGFloat = CGFloat(scale) / 1000
        
        let tileURL = NSURL(fileURLWithPath: self.dziFile.tileSourceUrl).appendingPathComponent("\(folderLevelForScale(scale: calibratedScale))")?.appendingPathComponent("\(col)_\(row).\(self.dziFile.format)")
       
        let imageData = NSData(contentsOf: tileURL as! URL)
        var image = UIImage(data: imageData as! Data)
        
        return image
    }
    
    //MARK: - Math Stuff
    
    func maximumTileLevel() -> Double {
        return Double(ceil(log2(Double(max(self.dziFile.width, self.dziFile.height)))))
    }
    
    func folderLevelForScale(scale: CGFloat) -> Int {
        return Int(ceil(maximumTileLevel() + Double(log2(Double(scale)))))
        
    }
    
    //MARK: - Debugging Tools
    
    // Used for debugging
    func drawTileBounds(in context: CGContext, withScale scale: CGFloat, inVisibleBounds rect: CGRect) {
         UIColor.white.set()
         context.setLineWidth(6.0/scale)
         context.stroke(rect)
    }
    
}
