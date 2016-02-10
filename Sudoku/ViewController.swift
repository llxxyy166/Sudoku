//
//  ViewController.swift
//  Sudoku
//
//  Created by xinye lei on 16/2/9.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import UIKit

enum currentSelectingState {
    case nothingSelected
    case numberInBoardSelected
    case blankInBoardSelected
}

class ViewController: UIViewController {
    
    @IBOutlet weak var gameBoardView: GameBoardView!
    
    @IBOutlet weak var timer: UILabel!
    
    
    let puzzle: [[Character]] = PuzzleLibrary().puzzle
    var numbers: [(button:UIButton, isOriginPuzzle:Bool)] = []
    var currentState: currentSelectingState = currentSelectingState.nothingSelected
    var currentSelectedNumberButton: UIButton? = nil
    
    var singleRow = [[Int]](count: 9, repeatedValue: [Int](count: 9, repeatedValue: 0))
    var singleColumn = [[Int]](count: 9, repeatedValue: [Int](count: 9, repeatedValue: 0))
    var singleSquare = [[Int]](count: 9, repeatedValue: [Int](count: 9, repeatedValue: 0))
    
    var singleRowCopy: [[Int]] = []
    var singleColumnCopy: [[Int]] = []
    var singleSquareCopy: [[Int]] = []
    
    var time = 0
    @IBAction func showAnswer(sender: UIButton) {
        var solvingPuzzle = self.puzzle
        PuzzleSolver().solveSudoku(&solvingPuzzle)
        for (var i = 0; i < 81; i++) {
            let row = calcCoordinateFromIndex(i).row
            let column = calcCoordinateFromIndex(i).column
            let button = self.numbers[i].button
            let flag = self.numbers[i].isOriginPuzzle
            button.setTitle(String(solvingPuzzle[row][column]), forState: UIControlState.Normal)
            if (flag) {
                button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            }
            else {
                button.setTitleColor(sender.tintColor, forState: UIControlState.Normal)
            }
            button.enabled = false
            button.backgroundColor = UIColor.clearColor()
        }
    }
    

    @IBAction func clear(sender: UIButton) {
        for (var i = 0; i < 81; i++) {
            let button = self.numbers[i].button
            let flag = self.numbers[i].isOriginPuzzle
            if(!flag) {
                button.setTitle(nil, forState: UIControlState.Normal)
            }
            button.backgroundColor = UIColor.clearColor()
            button.enabled = true
        }
        self.currentState = currentSelectingState.nothingSelected
        self.currentSelectedNumberButton = nil
        self.singleSquare = self.singleSquareCopy
        self.singleRow = self.singleRowCopy
        self.singleColumn = self.singleColumnCopy
        self.time = 0
        self.updateTimer()
        
    }
    
    @IBAction func fillingNumber(sender: UIButton) {
        if (self.currentState == currentSelectingState.blankInBoardSelected) {
            self.currentSelectedNumberButton?.hidden = false;
            let num = sender.titleLabel?.text;
            self.currentSelectedNumberButton?.setTitle(num, forState: UIControlState.Normal)
            self.currentSelectedNumberButton?.setTitleColor(sender.tintColor, forState: UIControlState.Normal)
            self.currentSelectedNumberButton?.backgroundColor = UIColor.clearColor()
            self.currentState = currentSelectingState.nothingSelected
            let index = calcIndexFromRect(self.currentSelectedNumberButton!.frame)
            let coord = calcCoordinateFromIndex(index)
            let squareIndex = PuzzleSolver().convertToSquare(coord)
            let number = Int(num!)! - 1
            self.singleRow[coord.row][number]++;
            self.singleColumn[coord.column][number]++;
            self.singleSquare[squareIndex][number]++;
            self.check()
            self.currentSelectedNumberButton = nil
        }
    }
    
    func check() {
        for (var i = 0; i < 81; i++) {
            let button = self.numbers[i].button
            if (button.backgroundColor == UIColor.redColor()) {
                let row = calcCoordinateFromIndex(i).row
                let column = calcCoordinateFromIndex(i).column
                let squareIndex = PuzzleSolver().convertToSquare((row, column))
                let title = button.titleForState(UIControlState.Normal)
                if (title != nil) {
                    let num = Int(title!)!
                    if (self.singleSquare[squareIndex][num - 1] <= 1 && self.singleRow[row][num - 1] <= 1 && self.singleColumn[column][num - 1] <= 1) {
                        button.backgroundColor = UIColor.clearColor()
                    }
                }
                else {
                    button.backgroundColor = UIColor.clearColor()
                }
            }
        }
        for(var i = 0; i < 9; i++) {
            for (var j = 0; j < 9; j++) {
                if (self.singleRow[i][j] > 1) {
                    for (var k = 0; k < 9; k++) {
                        let index = i * 9 + k
                        let button = self.numbers[index].button
                        let title = button.titleForState(UIControlState.Normal)
                        if (title != nil) {
                            let number = Int(title!)! - 1
                            if (number == j) {
                                button.backgroundColor = UIColor.redColor()
                            }
                        }
                    }
                }
                if (self.singleColumn[i][j] > 1) {
                    for (var k = 0; k < 9; k++) {
                        let index = k * 9 + i;
                        let button = self.numbers[index].button
                        let title = button.titleForState(UIControlState.Normal)
                        if (title != nil) {
                            let number = Int(title!)! - 1
                            if (number == j) {
                                button.backgroundColor = UIColor.redColor()
                            }
                        }
                    }
                    
                }
                if (self.singleSquare[i][j] > 1) {
                    let startRow = i / 3 * 3
                    let startColumn = i % 3 * 3
                    for (var k = startRow; k < startRow + 3; k++) {
                        for l in startColumn...startColumn + 2 {
                            let index = k * 9 + l
                            let button = self.numbers[index].button
                            let title = button.titleForState(UIControlState.Normal)
                            if (title != nil) {
                                let number = Int(title!)! - 1
                                if (number == j) {
                                    button.backgroundColor = UIColor.redColor()
                                }
                            }

                        }
                    }
                }
            }
        }
    }
    
    
    func numbersAction(sender: UIButton) {
        let index = calcIndexFromRect(sender.frame)
        let title = sender.titleForState(UIControlState.Normal)
        if (!self.numbers[index].isOriginPuzzle) {
            if (title != nil) {
                self.currentState = currentSelectingState.nothingSelected
                let row = index / 9
                let column = index % 9
                let squareIndex = PuzzleSolver().convertToSquare((row, column))
                let num = Int(title!)! - 1
                self.singleRow[row][num]--
                self.singleColumn[column][num]--
                self.singleSquare[squareIndex][num]--
                sender.setTitle(nil, forState: UIControlState.Normal)
                self.check()
            }
            else {
                if (self.currentState == currentSelectingState.nothingSelected) {
                    self.currentState = currentSelectingState.blankInBoardSelected
                    self.currentSelectedNumberButton = sender
                    sender.backgroundColor = UIColor.blueColor()
                }
                else {
                    self.currentState = currentSelectingState.nothingSelected
                    self.currentSelectedNumberButton = nil
                    sender.backgroundColor = UIColor.clearColor()
                }
            }
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (var i = 0; i < 81; i++) {
            let frame = calcRectFromeIndex(i)
            let row = calcCoordinateFromIndex(i).row
            let column = calcCoordinateFromIndex(i).column
            let button = UIButton(frame: frame)
            button.addTarget(self, action: Selector("numbersAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            let title: String?
            let flag: Bool
            if (puzzle[row][column] == ".") {
                title = nil
                flag = false
            }
            else {
                title = String(puzzle[row][column])
                flag = true
                let num = Int(title!)! - 1
                let squareIndex = PuzzleSolver().convertToSquare((row, column))
                self.singleRow[row][num] = 1;
                self.singleColumn[column][num] = 1;
                self.singleSquare[squareIndex][num] = 1;
            }
            self.singleRowCopy = self.singleRow
            self.singleColumnCopy = self.singleColumn
            self.singleSquareCopy = self.singleSquare
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.highlighted = true
            self.numbers.append((button, flag))
            self.view.addSubview(button)
        }
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateTimer() {
        self.time++
        let hour = self.time / 3600
        let min = (self.time - hour * 3600) / 60
        let sec = self.time - hour * 3600 - min * 60
        self.timer.text = String(format: "%d:%d:%d", hour, min, sec)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calcRectFromeIndex(index: Int) -> CGRect {
        let row = index / 9
        let column = index - row * 9
        var frame = self.gameBoardView.frame
        frame.size.width /= 9;
        frame.size.height /= 9;
        frame.origin.x += frame.width * CGFloat(column)
        frame.origin.y += frame.height * CGFloat(row)
        return frame
    }
    
    func calcCoordinateFromIndex(index: Int) -> (row: Int, column: Int) {
        let row = index / 9
        let column = index - row * 9
        return (row, column)
    }
    
    func calcIndexFromRect(rect: CGRect) -> Int {
        let boardOrigin = self.gameBoardView.frame.origin
        let width = self.gameBoardView.frame.size.width / 9
        let height = self.gameBoardView.frame.size.height / 9
        let column = round((rect.origin.x - boardOrigin.x) / width)
        let row = round((rect.origin.y - boardOrigin.y) / height)
        return Int(row * 9 + column)
    }


}

