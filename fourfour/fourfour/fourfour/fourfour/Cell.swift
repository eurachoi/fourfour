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
    
    var cellState: State = .Blank
    enum State{
        case Blank, Solid, Black, White
    }
    
    func fillCell(cell: Cell, cellIsBlack: Bool){
        if(cellIsBlack){
            circleImage.image=UIImage(named: "black")
            cell.cellState = .Black
        }
        else{
            circleImage.image=UIImage(named: "white")
            cell.cellState = .White
        }
    }
}