//
//  AI.swift
//  fourfour
//
//  Created by Eura Choi on 8/2/16.
//  Copyright © 2016 Eura Choi. All rights reserved.
//

import Foundation



class AI{
    var workingBoard: [Cell] = []
    
    var possibleMoves = [Int: Int]()
    
    var winningMoves = [Int]()
    var blockingMoves = [Int]()
    var blockingUnbarredStraightsMoves = [Int]()
    var buildingUnbarredStraightsMoves = [Int]()
    var buildingDiagonalsMoves = [Int]()
    var buildingLesserDiagonalsMoves = [Int]()
    var startingUnbarredStraightsMoves = [Int]()
    var buildingBarredStraightsMoves = [Int]()
    var startingNewStraights = [Int]()
    
    
    
    var possibleMovesTuples = [(Int, Int)]()
    
    var count = 0    
    
    func beginAIMove(givenBoard: [Cell]) -> Int{
        workingBoard = givenBoard
        
        possibleMoves.removeAll()
        
        winningMoves.removeAll()
        blockingMoves.removeAll()
        blockingUnbarredStraightsMoves.removeAll()
        buildingUnbarredStraightsMoves.removeAll()
        buildingDiagonalsMoves.removeAll()
        buildingLesserDiagonalsMoves.removeAll()
        startingUnbarredStraightsMoves.removeAll()
        buildingBarredStraightsMoves.removeAll()
        startingNewStraights.removeAll()
        
        generatePossibleMoves()
        fillWinningMoves()
        fillBlockingMoves()
        fillUnbarredAndBarredStraightsMoves()
        fillBuildingDiagonalsMoves()
        
//        print("possible moves: \(possibleMoves)")
//        print("winning moves: \(winningMoves)")
//        print("blocking moves: \(blockingMoves)")
//        print("blocking unbarred straights moves: \(blockingUnbarredStraightsMoves)")
//        print("building unbarred straights moves: \(buildingUnbarredStraightsMoves)")
//        print("building diagonals moves: \(buildingDiagonalsMoves)")
//        print("building lesser diagonals moves: \(buildingLesserDiagonalsMoves)")
//        print("starting unbarred straights moves: \(startingUnbarredStraightsMoves)")
//        print("building barred straights moves: \(buildingBarredStraightsMoves)")
//        print("starting new straights moves: \(startingNewStraights)")
        
        calculatePointValues()
        //print(possibleMoves)
        possibleMovesTuples = possibleMoves.reverse()
        quickSort(0, end: possibleMovesTuples.count)
        return possibleMovesTuples.last!.0
    }
    
    func generatePossibleMoves(){
        for indexPath in 0...99{
            let cell=workingBoard[indexPath]
            if(cell.cellState != .Blank){
                continue
            }
            let workingBoardIndex = indexPath
            var surroundingCells: [Cell] = [cell, cell, cell, cell]
            
            let leftCellIndex = workingBoardIndex-1
            let rightCellIndex = workingBoardIndex+1
            let topCellIndex = workingBoardIndex-10
            let bottomCellIndex = workingBoardIndex+10
            
            if(leftCellIndex>=0&&leftCellIndex%10 != 9){
                surroundingCells[0] = workingBoard[leftCellIndex]
            }
            if(rightCellIndex<=99&&rightCellIndex%10 != 0){
                surroundingCells[1] = workingBoard[rightCellIndex]
            }
            if(topCellIndex>=0){
                surroundingCells[2] = workingBoard[topCellIndex]
            }
            if(bottomCellIndex<=99){
                surroundingCells[3] = workingBoard[bottomCellIndex]
            }
            
            var availabilityArray = [Bool]()
            var availabilityArrayCount = -1
            for surroundingCell in surroundingCells {
                availabilityArrayCount += 1
                if(surroundingCell==workingBoard[workingBoardIndex]){
                    availabilityArray.append(false)
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
                        let nextCellIndex = indexPathCopy+traverseFactor
                        if(nextCellIndex<0||nextCellIndex>99){
                            returnBoolValue = true
                            break
                        }
                        if(nextCellIndex%10 == 9||nextCellIndex%10 == 0){
                            returnBoolValue = true
                            
                        }
                        indexPathCopy = nextCellIndex
                        let nextCell = workingBoard[nextCellIndex]
                        if(nextCell.cellState != .Blank){
                            
                            returnBoolValue = false
                            breakWhileLoop = true
                        }
                        if(returnBoolValue == true){
                            break
                        }
                    }
                    availabilityArray.append(returnBoolValue)
                    continue
                }
                availabilityArray.append(false)
            }
            if(availabilityArray.contains(true)){
                possibleMoves[indexPath] = 0
            }
        }
    }
    
    
    func fillWinningMoves(){
        for (cellIndex, _) in possibleMoves{
            for directionNumber in 0...7{
                recognitionRecursion(cellIndex, direction: directionNumber, searchingColor: .White)
                if(count == 3){
                    //
                    //WIN
                    winningMoves.append(cellIndex)
                }
                count = 0
            }
        }
    }
    func fillBlockingMoves(){
        for (cellIndex, _) in possibleMoves{
            for directionNumber in 0...7{
                recognitionRecursion(cellIndex, direction: directionNumber, searchingColor: .Black)
                if(count == 3){
                    //
                    //BLOCK WINS
                    blockingMoves.append(cellIndex)
                }
                count = 0
            }
        }
    }
    func fillUnbarredAndBarredStraightsMoves(){
        let straightDirections = [1, 3, 4, 6]
        for (cellIndex, _) in possibleMoves{
            for directionNumber in straightDirections{
                recognitionRecursion(cellIndex, direction: directionNumber, searchingColor: .Black)
                var endSpaceIsBlank = findEdgeCasesForEndSpaces(cellIndex, directionNumber: directionNumber, traverseFactorMultiplier: 3)
                if(count == 2 && endSpaceIsBlank){
                    //
                    //BLOCK UNBARRED STRAIGHTS
                    blockingUnbarredStraightsMoves.append(cellIndex)
                }
                count = 0
                recognitionRecursion(cellIndex, direction: directionNumber, searchingColor: .White)
                endSpaceIsBlank = findEdgeCasesForEndSpaces(cellIndex, directionNumber: directionNumber, traverseFactorMultiplier: 3)
                if(count == 2 && endSpaceIsBlank){
                    //
                    //BUILDING UNBARRED STRAIGHTS
                    buildingUnbarredStraightsMoves.append(cellIndex)
                }
                if(count == 2 && endSpaceIsBlank == false){
                    //
                    //BUILDING BARRED STRAIGHTS
                    buildingBarredStraightsMoves.append(cellIndex)
                }
                endSpaceIsBlank = findEdgeCasesForEndSpaces(cellIndex, directionNumber: directionNumber, traverseFactorMultiplier: 2)
                if(count == 1 && endSpaceIsBlank){
                    //
                    //STARTING UNBARRED STRAIGHTS
                    startingUnbarredStraightsMoves.append(cellIndex)
                }
                if(count == 1 && endSpaceIsBlank == false){
                    //
                    //STARTING BARRED STRAIGHTS
                    startingNewStraights.append(cellIndex)
                }
                count = 0
            }
        }
    }
    func fillBuildingDiagonalsMoves(){
        let diagonalDirections = [0, 2, 5, 7]
        for (cellIndex, _) in possibleMoves{
            for directionNumber in diagonalDirections{
                recognitionRecursion(cellIndex, direction: directionNumber, searchingColor: .White)
                if(count == 2){
                    //
                    //BUILDING DIAGONALS
                    buildingDiagonalsMoves.append(cellIndex)
                }
                if(count == 1){
                    //
                    //BUILDING LESSER DIAGONALS
                    buildingLesserDiagonalsMoves.append(cellIndex)
                }
                count = 0
            }
        }
    }
    
    func findEdgeCasesForEndSpaces(cellIndex: Int, directionNumber: Int, traverseFactorMultiplier: Int) -> Bool{
        let endSpace = cellIndex + (findTraverseFactor(directionNumber)*traverseFactorMultiplier)
        if(endSpace<0||endSpace>99){
            return false
        }
        if((endSpace%10 == 9&&directionNumber == 3)||(endSpace%10 == 0&&directionNumber == 4)||(endSpace<9&&directionNumber == 6)||(endSpace>89&&directionNumber == 1)){
            return false
        }
        if(workingBoard[endSpace].cellState != CellState.Blank){
            return false
        }
        return true
    }
    
    
    func recognitionRecursion(index: Int, direction: Int, searchingColor: CellState){
        let traverseInteger = findTraverseFactor(direction)
        let nextIndex = index + traverseInteger
        
        if(nextIndex<0||nextIndex>99){
            return
        }
        if(workingBoard[nextIndex].cellState != searchingColor){
            return
        }
        count += 1
        if(workingBoard[nextIndex].cellState == searchingColor){
            if(((nextIndex%10 == 9&&direction == 4)||(nextIndex%10 == 0&&direction == 3)||(nextIndex<9&&direction == 1)||(nextIndex>89&&direction == 6))&&count<3){
                return
            }
            recognitionRecursion(nextIndex, direction: direction, searchingColor: searchingColor)
        }
    }
    func findTraverseFactor(direction: Int) -> Int{
        // 0 1 2
        // 3 . 4
        // 5 6 7
        var traverseInteger = 0
        switch direction {
        case 0:
            traverseInteger = -11
        case 1:
            traverseInteger = -10
        case 2:
            traverseInteger = -9
        case 3:
            traverseInteger = -1
        case 4:
            traverseInteger = 1
        case 5:
            traverseInteger = 9
        case 6:
            traverseInteger = 10
        case 7:
            traverseInteger = 11
        default:
            traverseInteger = 0
        }
        return traverseInteger
    }
    
    func calculatePointValues(){
        for moveIndex in winningMoves{
            possibleMoves[moveIndex]! += 1000000
        }
        for moveIndex in blockingMoves{
            possibleMoves[moveIndex]! += 500
        }
        for moveIndex in blockingUnbarredStraightsMoves{
            possibleMoves[moveIndex]! += 400
        }
        for moveIndex in buildingUnbarredStraightsMoves{
            possibleMoves[moveIndex]! += 100
        }
        for moveIndex in buildingDiagonalsMoves{
            possibleMoves[moveIndex]! += 40
        }
        for moveIndex in buildingLesserDiagonalsMoves{
            possibleMoves[moveIndex]! += 20
        }
        for moveIndex in startingUnbarredStraightsMoves{
            possibleMoves[moveIndex]! += 30
        }
        for moveIndex in buildingBarredStraightsMoves{
            possibleMoves[moveIndex]! += 10
        }
        for moveIndex in startingNewStraights{
            possibleMoves[moveIndex]! += 1
        }
    }
    
    func quickSort(start:Int, end:Int) {
        if (end - start < 2){
            return
        }
        let p = possibleMovesTuples[start + (end - start)/2].1
        var l = start
        var r = end - 1
        while (l <= r){
            if (possibleMovesTuples[l].1 < p){
                l += 1
                continue
            }
            if (possibleMovesTuples[r].1 > p){
                r -= 1
                continue
            }
            let t = possibleMovesTuples[l]
            possibleMovesTuples[l] = possibleMovesTuples[r]
            possibleMovesTuples[r] = t
            l += 1
            r -= 1
        }
        quickSort(start, end: r + 1)
        quickSort(r + 1, end: end)
    }
}