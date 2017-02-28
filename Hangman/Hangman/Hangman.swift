//
//  Hangman.swift
//  Hangman
//
//  Created by Bryan Tong on 2/26/17.
//  Copyright © 2017 Bryan Tong. All rights reserved.
//

import Foundation

class Hangman {
    
    /* Current phrase the game is on. */
    var gamePhrase: String?
    /* Length of the phrase. */
    var gamePhraseLen: Int
    /* Array of the current phrase. */
    var gamePhraseArray = [Character]()
    /* Boolean if a word has been discovered or not. */
    var gamePhraseArrayCheck = [Bool]()
    
    /* Amount of lives remaining. */
    var livesRemaining: Int
    
    /* The letters incorrectly guessed by the player. */
    var wrongLetters = Set<String>()
    /* The answer, i.e. letters needed to win? */
    var neededLetters = Set<String>()
    /* Displays incorrectly guessed letters, w/o duplicates. */
    var wrongLettersDisplay: String?
    /* Storage for telling you if you've already guessed that letter. */
    var alreadyGuessed = Set<String>()
    
    /* Initializer here replaces the VC one for MVC principle. */
    init() {
        /* Grab a phrase and initialize everything to empty. */
        let allPhrases = HangmanPhrases()
        let phrase: String = allPhrases.getRandomPhrase()
        gamePhraseArray = [Character]()
        gamePhraseArrayCheck = [Bool]()
        wrongLetters = Set<String>()
        neededLetters = Set<String>()
        wrongLettersDisplay = "Incorrect Guesses:"
        gamePhrase = phrase
        gamePhraseLen = gamePhrase!.characters.count - 1 // handles EOF
        livesRemaining = 6
        alreadyGuessed = Set<String>()
    
        /* Store values into all the vars again. */
        gamePhraseArray = [Character](gamePhrase!.characters)
        for i in 0...gamePhraseLen { // FIXME this might be problem
            if (gamePhrase?.substring(atIndex: i) == " ") {
                gamePhraseArrayCheck.append(true)
            } else {
                gamePhraseArrayCheck.append(false)
                neededLetters.insert((gamePhrase?.substring(atIndex: i))!)
            }
        }        
    }
    
    /* Updates the display of the phrase. 
     * Might be slightly wonky. */
    func displayTheString() -> String {
        var tempText = ""
        for i in 0...gamePhraseLen {
            if (gamePhrase?.substring(atIndex: i) == " ") {
                tempText = tempText + " "
            } else {
                if (gamePhraseArrayCheck[i] == false) {
                    tempText = tempText + "_" + " "
                } else { // else show the actual letter
                    tempText = tempText + (gamePhrase?.substring(atIndex: i))! + " " // should gamePhrase? be !......?
                    
                }
            }
        }
        return tempText
    }

    /* Updates the display of wrong letters guessed. */
    func updateWrongLetters(letter: String) {
        wrongLettersDisplay = wrongLettersDisplay! + " " + letter
    }
    
    /* Returns true if the game is won. */
    func gameWon() -> Bool{
        for letter in gamePhraseArrayCheck {
            if (letter == false) {
                return false
            }
        }
        return true
    }
    
    func newGame() {
        /* Grab a phrase and initialize everything to empty. */
        let allPhrases = HangmanPhrases()
        let phrase: String = allPhrases.getRandomPhrase()
        wrongLetters = Set<String>()
        neededLetters = Set<String>()
        gamePhraseArray = [Character]()
        gamePhraseArrayCheck = [Bool]()
        wrongLettersDisplay = "Incorrect Guesses:"
        gamePhrase = phrase
        gamePhraseLen = gamePhrase!.characters.count - 1 // handles EOF
        livesRemaining = 6
        alreadyGuessed = Set<String>()

        /* Store values into all the vars again. */
        gamePhraseArray = [Character](gamePhrase!.characters)
        for i in 0...gamePhraseLen {
            if (String(gamePhraseArray[i]) == " ") {
                gamePhraseArrayCheck.append(true)
            } else {
                gamePhraseArrayCheck.append(false)
            }
            neededLetters.insert((gamePhrase?.substring(atIndex: i))!)
        }        
    }
    
}
