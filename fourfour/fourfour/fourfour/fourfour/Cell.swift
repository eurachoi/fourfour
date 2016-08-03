//
//  Cell.swift
//  fourfour
//
//  Created by Eura Choi on 7/1/16.
//  Copyright © 2016 Eura Choi. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell{
    @IBOutlet weak var circleImage: UIImageView!
    
    var cellState: CellState = .Blank
    
    func fillCell(cell: Cell, cellIsBlack: Bool){
        if(cellIsBlack){
            circleImage.image=UIImage(named: "black")
        }
        else{
            circleImage.image=UIImage(named: "white")
        }
    }
}