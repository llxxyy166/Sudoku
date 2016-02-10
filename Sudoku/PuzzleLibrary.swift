//
//  PuzzleLibrary.swift
//  Sudoku
//
//  Created by xinye lei on 16/2/9.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import Foundation

class PuzzleLibrary {
    let puzzle: [[Character]]
    init() {
        var puzzle = [[Character]](count: 9, repeatedValue: [Character](count: 9, repeatedValue: "."));
        puzzle[0][1] = "7"
        puzzle[0][2] = "5"
        puzzle[0][6] = "4"
        puzzle[0][7] = "1"
        puzzle[0][8] = "3"
        puzzle[1][4] = "7"
        puzzle[1][5] = "1"
        puzzle[2][1] = "1"
        puzzle[2][2] = "6"
        puzzle[2][6] = "7"
        puzzle[3][0] = "9"
        puzzle[3][2] = "1"
        puzzle[3][5] = "8"
        puzzle[3][7] = "7"
        puzzle[4][2] = "4"
        puzzle[4][3] = "5"
        puzzle[4][5] = "7"
        puzzle[4][6] = "1"
        puzzle[4][8] = "2"
        puzzle[5][2] = "7"
        puzzle[5][3] = "1"
        puzzle[6][0] = "7"
        puzzle[6][1] = "8"
        puzzle[6][8] = "1"
        puzzle[7][0] = "1"
        puzzle[7][3] = "7"
        puzzle[8][3] = "3"
        puzzle[8][4] = "1"
        puzzle[8][6] = "6"
        puzzle[8][8] = "7"
        self.puzzle = puzzle
    }
}

class PuzzleSolver {
    func convertToSquare(coordinate:(row: Int, column: Int)) -> Int {
        let c = coordinate.column / 3;
        let r = coordinate.row / 3;
        return 3 * r + c;
    }
    
    class configuration {
        var currentIndex: Int;
        var row = [[Int]]();
        var column = [[Int]]();
        var square = [[Int]]();
        
        init() {
            currentIndex = 0;
            for (var i = 0; i < 9; i++) {
                for (var j = 0; j < 9; j++) {
                    let singleRow = [Int](count: 9, repeatedValue: 0);
                    let singleColumn = [Int](count: 9, repeatedValue: 0);
                    let singleSquare = [Int](count: 9, repeatedValue: 0);
                    row.append(singleRow);
                    column.append(singleColumn);
                    square.append(singleSquare);
                }
            }
        }
    }
    
    func track(inout board: [[Character]], inout _ config: configuration) -> Bool {
        let index = config.currentIndex;
        if (index == 81) {
            return true;
        }
        let row = index / 9;
        let column = index % 9;
        let squareIndex = convertToSquare((row, column));
        if (board[row][column] != ".") {
            config.currentIndex++;
            if (track(&board, &config)) {
                return true;
            }
            config.currentIndex--;
            return false;
        }
        for (var i = 1; i < 10; i++) {
            if(config.row[row][i - 1] != 0 || config.column[column][i - 1] != 0 || config.square[squareIndex][i - 1] != 0) {
                continue;
            }
            let cNum = String(i);
            board[row][column] = cNum[cNum.startIndex];
            config.currentIndex++;
            config.row[row][i - 1] = 1;
            config.column[column][i - 1] = 1;
            config.square[squareIndex][i - 1] = 1;
            if (track(&board, &config)) {
                return true;
            }
            config.currentIndex--;
            config.row[row][i - 1] = 0;
            config.column[column][i - 1] = 0;
            config.square[squareIndex][i - 1] = 0;
            board[row][column] = ".";
        }
        return false;
    }
    
    func solveSudoku(inout board: [[Character]]) {
        var config = configuration();
        for (var i = 0; i < 9; i++) {
            for (var j = 0; j < 9; j++) {
                if(board[i][j] != ".") {
                    let s = String(board[i][j]);
                    let num = Int(s);
                    let squareIndex = convertToSquare((i, j));
                    config.row[i][num! - 1] = 1;
                    config.column[j][num! - 1] = 1;
                    config.square[squareIndex][num! - 1] = 1;
                }
            }
        }
        track(&board, &config);
    }
}