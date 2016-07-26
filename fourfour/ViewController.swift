//
//  ViewController.swift
//  fourfour
//
//  Created by Eura Choi on 6/30/16.
//  Copyright © 2016 Eura Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var bottomOutletForGradient: UIButton!
    var workingBoard = [Cell]()
    
    @IBOutlet var overallView: UIView!
    @IBOutlet weak var boardView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBAction func newGame(sender: AnyObject) {
        isBlackPlayersTurn = true
        infoLabel.text="player one's turn"
        for count in 0...99{
            let reloadCellIndex = NSIndexPath(forItem: count, inSection: 0)
            if(reloadCellIndex.row==44||reloadCellIndex.row==45||reloadCellIndex.row==54||reloadCellIndex.row==55)
            {
                continue
            }
            let cell = boardView.cellForItemAtIndexPath(reloadCellIndex) as! Cell
            if(cell.cellState != .Blank){
                cell.cellState = .Blank
                workingBoard[count].cellState = .Blank
                cell.circleImage.image = UIImage(named: "transparent")
            }
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
       // var temporary = CGRect()
        
        gradient.frame = overallView.bounds
        
        let printhtis = bottomOutletForGradient.frame.maxY / overallView.bounds.height
        gradient.endPoint.y = printhtis
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor(red:0.65, green:0.99, blue:0.64, alpha:1.0).CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

    var isBlackPlayersTurn=true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        if(indexPath.row==44||indexPath.row==45||indexPath.row==54||indexPath.row==55)
        {
            let cell=collectionView.dequeueReusableCellWithReuseIdentifier("BlankCell", forIndexPath: indexPath) as! Cell
            cell.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
            cell.cellState = .Solid
            let celll = Cell()
            celll.cellState = .Solid
            workingBoard.append(celll)
            return cell
        }
        let celllll = Cell()
        workingBoard.append(celllll)
        return collectionView.dequeueReusableCellWithReuseIdentifier("BlankCell", forIndexPath: indexPath) as! Cell
    }
    
    
    func winRecognition() -> Int{
        
        print("hi")
        
        return 0
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell=collectionView.cellForItemAtIndexPath(indexPath) as! Cell
        let workingBoardIndex = indexPath.row
        
        var surroundingCells: [Cell] = [collectionView.cellForItemAtIndexPath(indexPath) as! Cell, collectionView.cellForItemAtIndexPath(indexPath) as! Cell, collectionView.cellForItemAtIndexPath(indexPath) as! Cell, collectionView.cellForItemAtIndexPath(indexPath) as! Cell]
        
        let leftCellIndex = indexPath.row-1
        let rightCellIndex = indexPath.row+1
        let topCellIndex = indexPath.row-10
        let bottomCellIndex = indexPath.row+10
        
        if(leftCellIndex>=0&&leftCellIndex%10 != 9){
            surroundingCells[0] = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: leftCellIndex, inSection: 0)) as! Cell
        }
        if(rightCellIndex<=99&&rightCellIndex%10 != 0){
            surroundingCells[1] = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: rightCellIndex, inSection: 0)) as! Cell
        }
        if(topCellIndex>=0){
            surroundingCells[2] = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: topCellIndex, inSection: 0)) as! Cell
        }
        if(bottomCellIndex<=99){
            surroundingCells[3] = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: bottomCellIndex, inSection: 0)) as! Cell
        }
        
        
        var canBeSelected = true
        var availabilityArray = [Bool]()
        var availabilityArrayCount = -1
        for surroundingCell in surroundingCells {
            availabilityArrayCount += 1
            if(surroundingCell==self){
                continue
            }
            if(surroundingCell.cellState != .Blank){
                var traverseFactor = 0
                switch availabilityArrayCount {
                case 0:
                    traverseFactor = 1
                case 1:
                    traverseFactor = -1
                case 2:
                    traverseFactor = 10
                case 3:
                    traverseFactor = -10
                default: break
                }
                var breakWhileLoop = false
                var returnBoolValue = false
                var indexPathCopy = indexPath
                while(breakWhileLoop == false){
                    let nextCellIndex = indexPathCopy.row+traverseFactor
                    if(nextCellIndex<0||nextCellIndex>99){
                        returnBoolValue = true
                        break
                    }
                    if(nextCellIndex%10 == 9||nextCellIndex%10 == 0){
                        returnBoolValue = true
                        
                    }
                    let indexOfNextCell = NSIndexPath(forRow: nextCellIndex, inSection: 0)
                    indexPathCopy = indexOfNextCell
                    let nextCell = collectionView.cellForItemAtIndexPath(indexOfNextCell) as! Cell
                    if(nextCell.cellState != .Blank){
                        
                        returnBoolValue = false
                        breakWhileLoop = true
                    }
                    if(returnBoolValue == true){
                        break
                    }
                }
                availabilityArray.append(returnBoolValue)
            }
            if(surroundingCell.cellState == .Blank){
                availabilityArray.append(false)
            }
        }
        if(!(availabilityArray.contains(true))){
            canBeSelected = false
        }
        let size:CGRect=UIScreen.mainScreen().bounds
        let desiredCellWidth=(size.width-29)/10
        
        
        if(canBeSelected){
            if(cell.cellState != .Blank){
                return
            }
            let animatedView = UIImageView()
            animatedView.frame = CGRectMake(0, 0, desiredCellWidth - 4, desiredCellWidth - 4)
            animatedView.contentMode = .ScaleAspectFit
            
            var count = 0;
            var indexesOfAvailable = [Int]()
            
            
            for available in availabilityArray{
                if(available){
                    indexesOfAvailable.append(count)
                }
                count += 1
            }
            
            let chosenIndexOfIndexesOfAvailable = Int(arc4random_uniform(UInt32(indexesOfAvailable.count)))
            switch indexesOfAvailable[chosenIndexOfIndexesOfAvailable] {
            case 0:
                animatedView.frame.origin.x = size.width + desiredCellWidth - 2
                animatedView.frame.origin.y = cell.frame.origin.y + 2
            case 1:
                animatedView.frame.origin.x = 0 - desiredCellWidth + 2
                animatedView.frame.origin.y = cell.frame.origin.y + 2
            case 2:
                animatedView.frame.origin.x = cell.frame.origin.x + 2
                animatedView.frame.origin.y = size.height
            case 3:
                animatedView.frame.origin.x = cell.frame.origin.x + 2
                animatedView.frame.origin.y = 0 - desiredCellWidth + 2
            default:
                break
            }
            
            
            if(isBlackPlayersTurn){
                animatedView.image = UIImage(named: "black")
                workingBoard[workingBoardIndex].cellState = .Black
                isBlackPlayersTurn=false
                infoLabel.text="player two's turn"
            }
            else{
                animatedView.image = UIImage(named: "white")
                workingBoard[workingBoardIndex].cellState = .White
                isBlackPlayersTurn=true
                infoLabel.text="player one's turn"
            }
            
            self.boardView.addSubview(animatedView)
            
            UIView.animateWithDuration(0.4, animations: {
                let destinationXCoordinate = cell.frame.origin.x + 2
                let destinationYCoordinate = cell.frame.origin.y + 2
                animatedView.frame.origin.x = destinationXCoordinate
                animatedView.frame.origin.y = destinationYCoordinate
                }, completion: { finished in
                    if(self.isBlackPlayersTurn == false){
                        cell.fillCell(cell, cellIsBlack: true)
                    }
                    if(self.isBlackPlayersTurn == true){
                        cell.fillCell(cell, cellIsBlack: false)
                    }
                    animatedView.removeFromSuperview()
            })
            
            
            winRecognition()
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size:CGRect=UIScreen.mainScreen().bounds
        let desiredCellWidth=(size.width-29)/10
        return CGSize(width: desiredCellWidth, height: desiredCellWidth)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
}
