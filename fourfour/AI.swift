//
//  AI.swift
//  fourfour
//
//  Created by Eura Choi on 8/2/16.
//  Copyright © 2016 Eura Choi. All rights reserved.
//

import Foundation

//GENERATE LIST OF POSSIBLE MOVES
//SEPARATE LIST INTO SUBLISTS, LIST OF MOVES THAT WILL: WIN, BLOCK WINS, ADD TO UNBARRED STRAIGHTS, ADD TO DIAGONALS, ADD TO BARRED STRAIGHTS, START NEW STRAIGHTS
//FIRST PRIORITY IS TO WIN
//SECOND PRIORITY IS TO BLOCK, BLOCK WITH MOVES THAT ARE ALSO IN THE LOWER PRIORITY LISTS, BUT DO NOT SEARCH IN THE LOWEST PRIORITY LIST
//CONTINUE DOWN THE LIST



class AI{
    var workingBoard: [Cell] = []
    func beginAIMove(givenBoard: [Cell]){
        workingBoard = givenBoard
    }
    
    
    func winRecognition(){
//        var winningColor: CellState = .Blank
//        for cellIndex in 0...99{
//            if(workingBoard[cellIndex].cellState == .Blank||workingBoard[cellIndex].cellState == .Solid){
//                continue
//            }
//            else{
//                for directionNumber in 0...7{
//                    winningColor = workingBoard[cellIndex].cellState
//                    winRecognitionRecursion(cellIndex, direction: directionNumber, checkingCellState: workingBoard[cellIndex].cellState, count: 1)
//                }
//            }
//            if(gameHasBeenWon == true){
//                if(winningColor == .Black){
//                    
//                }
//                if(winningColor == .White){
//                    
//                }
//                boardView.userInteractionEnabled = false
//                break
//            }
//        }
    }
}