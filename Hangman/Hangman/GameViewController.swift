//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    var displayArray: Array<Character> = []
    var incorrectArray: Array<Character> = []
    var phrase = ""
    var text = ""
    var incorrectCount = 0
    var correctCount = 0
    var gameOver = false
    
    @IBOutlet weak var InputLabel: UILabel!

    @IBOutlet weak var IncorrectLabel: UILabel!
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBAction func GuessButton(_ sender: AnyObject) {
        let guess = TextField.text
        guessCheck(guess: guess!)
        IncorrectLabel.text = String(incorrectArray)
        InputLabel.text = String(displayArray)
        TextField.text = ""
        
    }
    
    @IBAction func RestartButton(_ sender: AnyObject) {
        incorrectArray = []
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        displayArray = Array(repeating: " ", count: (phrase.characters.count))
        text = ""
        incorrectCount = 0
        gameOver = false
        correctCount = 0
        for (index, element) in (phrase.characters.enumerated()) {
            if element != " " {
                displayArray[index] = "_"
            }
            else {
                displayArray[index] = " "
                correctCount += 1
            }
        }
        InputLabel.text = String(displayArray)
        IncorrectLabel.text = String(incorrectArray)
        setImage(imageName: "hangman1.gif")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        displayArray = Array(repeating: " ", count: (phrase.characters.count))
        print(phrase)
        TextField.delegate = self
        for (index, element) in (phrase.characters.enumerated()) {
            if element != " " {
                displayArray[index] = "_"
            }
            else {
                displayArray[index] = " "
                correctCount += 1
            }
        }
        print(displayArray)
        InputLabel.text = String(displayArray)
        IncorrectLabel.text = String(incorrectArray)
        setImage(imageName: "hangman1.gif")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func guessCheck(guess: String) {
        if !gameOver {
            print(guess)
            let str = guess.uppercased()
            let char = str[str.startIndex]
            var inArray = false
            for (index, element) in (phrase.characters.enumerated()) {
                if element == char {
                    displayArray[index] = element
                    inArray = true
                    correctCount += 1
                }
            }
            if inArray == false {
                var contains = false
                for chara in incorrectArray {
                    if chara == char {
                        contains = true
                    }
                }
                if (contains) {
                    alertAlreadyInputted()
                }
                else {
                    updateIncorrectArray(incorrect: char)
                    incorrectCount += 1
                    setImage(imageName: "hangman" + String(incorrectCount+1) + ".gif")
                }
            
            }
            checkState()
            print(displayArray)
        }
        
    }
    
    func updateIncorrectArray(incorrect: Character) {
        incorrectArray.append(incorrect)
        incorrectArray.append(" ")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 2
        let currentText = TextField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let currentString: NSString = prospectiveText as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func setImage(imageName: String) {
        displayImage.image = UIImage(named: imageName)
    }
    
    func alertFail() {
        let alertController = UIAlertController(title: "Sorry", message:"You Lost. The phrase was: " + phrase + ". Play Again?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func alertWin() {
        let alertController = UIAlertController(title: "Congratulations", message:"You Won! Play Again?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertAlreadyInputted() {
        let alertController = UIAlertController(title: "Oops", message:"You already tried this letter. Try another one!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkState() {
        if (incorrectCount > 6) {
            gameOver = true
            alertFail()
        }
        else if (correctCount == phrase.characters.count) {
            gameOver = true
            alertWin()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
