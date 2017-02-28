//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Skeleton copyright © 2016 Shawn D'Souza. All rights reserved.
//  Completed by Bryan Tong
//

import UIKit

class HangmanViewController: UIViewController {
    
    /* The overarching game instance. */
    let gameInstance = Hangman()
    /* Where the letter that is guessed is stored. */
    @IBOutlet weak var inputField: UITextField!
    /* The main UI Image of hangman hanging. */
    @IBOutlet weak var hangmanGraphics: UIImageView!
    /* The current score of the game. */
    @IBOutlet weak var gameScore: UILabel!
    /* Displaying the incorrect guesses so far. */
    @IBOutlet weak var incorrectGuesses: UILabel!
    /* Shows the _ or the letters the player guesses. */
    @IBOutlet weak var displayText: UILabel!
    /* Displays the string version of the phrase. */
    var displayString: String?
    /* Displays the current hangman file. */
    var hangmanFile = 1
    /* EXTRA CREDIT: Score of the game for funsies. */
    var score = 0
    /* EXTRA CREDIT: Multiplier of the score for funsies. */
    var scoreMultiplyer = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* My stuff - starts an instance of hangman. */
        gameInstance.newGame()
        /* Set up a new view instance. */
        hangmanGraphics.image = UIImage(named: "hangman1.gif")
        score = 0
        gameScore.text = NSString(format: "Score: %i", score) as String
        displayString = gameInstance.displayTheString()
        displayText.text = displayString
        incorrectGuesses.text = gameInstance.wrongLettersDisplay
        hangmanFile = 1
    }
    
    /* Prevents someone from guessing too many letters and clears it. */
    @IBAction func inputAction(_ sender: Any) {
        if (inputField.text!.characters.count >= 2) {
            inputField.text = ""
        }
        clearInput()
    }
    
    func clearInput() {
        inputField.text = ""
    }

    /* Makes a guess based off the letter in inputField.text. */
    @IBAction func makeGuess(_ sender: Any) {
        let letterGuessed = inputField.text
        /* If letter isn't valid, raise alerts. */
        if (letterGuessed?.characters.count != 1) {
            let alertGuess = UIAlertController(
                title: "One letter only!",
                message: "You can't guess more than one letter at a time.",
                preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertGuess.addAction(OKAction)
            self.present(alertGuess, animated: true, completion: nil)
        }
        if (gameInstance.alreadyGuessed.contains(letterGuessed!.uppercased())) {
            let alertAlready = UIAlertController(
                title: "Duplicate guess!",
                message: "You've already guessed this letter before!",
                preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Oops", style: .default, handler: nil)
            alertAlready.addAction(OKAction)
            self.present(alertAlready, animated: true, completion: nil)
        /* Letter is valid, carry on. */
        } else {
            /* Add the good letter. */
            if (gameInstance.neededLetters.contains(letterGuessed!.uppercased())) {
                scoreMultiplyer = scoreMultiplyer * 2
                for i in 0...gameInstance.gamePhraseLen {
                    if (letterGuessed?.uppercased() == gameInstance.gamePhrase?.substring(atIndex: i)) {
                        gameInstance.gamePhraseArrayCheck[i] = true
                        score = score + (100 * scoreMultiplyer)
                        gameScore.text = NSString(format: "Score: %i", score) as String
                        gameInstance.alreadyGuessed.insert(letterGuessed!.uppercased())
                    }
                }
                displayText.text = gameInstance.displayTheString()
                if (gameInstance.gameWon()) {
                    let alertWinner = UIAlertController(
                        title: "You won!",
                        message: "Congratulations - you know Berkeley inside and out!",
                        preferredStyle: .alert)
                    let newGameAction = UIAlertAction(title: "New Game", style: .default) {
                        action in self.resetAll()
                    }
                    alertWinner.addAction(newGameAction)
                    self.present(alertWinner, animated: true, completion: nil)
                }
                clearInput()
            /* Handle the bad letter. */
            } else {
                scoreMultiplyer = 1
                gameInstance.alreadyGuessed.insert(letterGuessed!.uppercased())
                gameInstance.wrongLetters.insert(letterGuessed!)
                gameInstance.updateWrongLetters(letter: letterGuessed!)
                incorrectGuesses.text = gameInstance.wrongLettersDisplay
                hangmanFile += 1
                updateHangImage()
                displayText.text = gameInstance.displayTheString()
                if (hangmanFile >= 7) {
                    let alertLoser = UIAlertController(
                        title: "You lost!",
                        message: "Sorry - brush up on Berkeley and try again!",
                        preferredStyle: .alert)
                    let newGameAction = UIAlertAction(title: "New Game", style: .default) {
                        action in self.resetAll()
                    }
                    alertLoser.addAction(newGameAction)
                    self.present(alertLoser, animated: true, completion: nil)
                }
                clearInput()
            }
        }
    }
    
    func updateHangImage() {
        if (hangmanFile == 1) {
            hangmanGraphics.image = UIImage(named: "hangman1.gif")
        }
        if (hangmanFile == 2) {
            hangmanGraphics.image = UIImage(named: "hangman2.gif")
        }
        if (hangmanFile == 3) {
            hangmanGraphics.image = UIImage(named: "hangman3.gif")
        }
        if (hangmanFile == 4) {
            hangmanGraphics.image = UIImage(named: "hangman4.gif")
        }
        if (hangmanFile == 5) {
            hangmanGraphics.image = UIImage(named: "hangman5.gif")
        }
        if (hangmanFile == 6) {
            hangmanGraphics.image = UIImage(named: "hangman6.gif")
        }
        if (hangmanFile >= 7) {
            hangmanGraphics.image = UIImage(named: "hangman7.gif")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetViewInstance(_ sender: Any) {
        let alertRusure = UIAlertController(
            title: "Start over?",
            message: "Are you sure you want to start a new game?",
            preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: .default) {
            action in self.resetAll()
        }
        let OKAction = UIAlertAction(title: "Resume", style: .default, handler: nil)
        alertRusure.addAction(OKAction)
        alertRusure.addAction(newGameAction)
        self.present(alertRusure, animated: true, completion: nil)
    }
    
    func resetAll() {
        gameInstance.newGame()
        hangmanGraphics.image = UIImage(named: "hangman1.gif")
        score = 0
        gameScore.text = NSString(format: "Score: %i", score) as String
        displayString = gameInstance.displayTheString()
        displayText.text = displayString
        incorrectGuesses.text = gameInstance.wrongLettersDisplay
        hangmanFile = 1
        clearInput()
    }

}
