//
//  ViewController.swift
//  game2048
//
//  Created by Nguyen Toan on 1/6/17.
//  Copyright © 2017 Nguyen Toan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var b = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    
    @IBOutlet weak var score: UILabel!
    var lose = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
    }
    func randomNum(_ type: Int)
    {
        if(!lose)
        {
            switch(type)
            {
                case 0 : left()
                case 1 : right()
                case 2 : up()
                case 3 : down()
                default : break
            }
       }
        
    if (!checkRandom())
        {
            var rnlableX  = arc4random_uniform(4)
            var rnlableY = arc4random_uniform(4)
            let rdNum = arc4random_uniform(2) == 0 ? 2 : 4;
            
            while (b[Int(rnlableX)][Int(rnlableY)] != 0)
            {
                rnlableX = arc4random_uniform(4)
                rnlableY = arc4random_uniform(4)
            }
            b[Int(rnlableX)][Int(rnlableY)] = rdNum
            let numlabel = 100 + (Int(rnlableX) * 4) + Int(rnlableY)
            ConvertNumLabel(numlabel, value: String(rdNum))
            transfer()
        }
        else if (checkLose())
        {
            lose = true
            let alert = UIAlertController(title: "Game Over", message: "You Lose", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    //check space point
    func checkRandom() -> Bool
    {
        for row in 0..<4
        {
            for col in 0..<4
            {
                if (b[row][col] == 0)
                {
                   return false
                }
            }
        }
    return true
    }
    
    func checkLose() -> Bool
    {
        for row in 0..<4
        {
            for col in 0..<4
            {
                if ((b[row][col] != b[row + 1][col]) || (b[row][col] != b[row][col + 1]) || (b[row][col] != b[row - 1][col]) || (b[row][col] != b[row][col - 1]))
                {
                   return true
                }
            }
        }
        return false
    }
    func changeBackColor(_ numlabel: Int, color: UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                randomNum(0)
            case UISwipeGestureRecognizerDirection.right:
                randomNum(1)
            case UISwipeGestureRecognizerDirection.up:
                randomNum(2)
            case UISwipeGestureRecognizerDirection.down:
                randomNum(3)
            default:
                break
            }
        }
    }
    func transfer()
    {
        for i in 0 ..< 4
        {
            for j in 0 ..< 4
            {
                let numlabel = 100 + (i * 4) + j;
                ConvertNumLabel(numlabel, value: String(b[i][j]));
                switch(b[i][j])
                {
                case 2,4:changeBackColor(numlabel, color: UIColor.cyan)
                case 8,16:changeBackColor(numlabel, color: UIColor.green)
                case 16,32:changeBackColor(numlabel, color: UIColor.orange)
                case 64:changeBackColor(numlabel, color: UIColor.red)
                case 128,256,512:changeBackColor(numlabel, color: UIColor.yellow)
                case 1024,2048:changeBackColor(numlabel, color: UIColor.purple)
                default: changeBackColor(numlabel, color: UIColor.brown)
                }
            }
        }
    }
    func ConvertNumLabel(_ numlabel: Int, value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    func up()
    {
        
        for col in 0 ..< 4
        {
            var check = false
            for row in 1 ..< 4
            {
                var tx = row
                if (b[row][col] == 0)
                {
                    continue;
                }
                for rowc in ((-1 + 1)...row - 1).reversed()
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[row][col] == b[tx][col])
                {
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func down()
    {
        for col in 0 ..< 4
        {
            var check = false
            for row in 0 ..< 4
            {
                var tx = row
                
                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in row + 1 ..< 4
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break;
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                    
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func left()
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in 1 ..< 4
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in ((-1 + 1)...col - 1).reversed()
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty]=b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func right()
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in ((-1 + 1)...3).reversed()
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in col + 1 ..< 4
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func GetScore(_ value: Int)
    {
        score.text = String(Int(score.text!)! + value)
    }
    
}

