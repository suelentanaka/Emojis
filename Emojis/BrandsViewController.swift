//
//  BrandsViewController.swift
//  Emojis
//
//  Created by Suelen Tanaka on 2018-12-14.
//  Copyright © 2018 Suelen Tanaka. All rights reserved.
//

import UIKit

class BrandsViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var hintBTN: UIButton!
    @IBOutlet weak var hintLBL: UILabel!
    @IBOutlet weak var congratsLBL: UILabel!
    @IBOutlet weak var questionLBL: UILabel!
    @IBOutlet weak var givenHintLBL: UILabel!
    @IBOutlet weak var answerTFD: UITextField!
    @IBOutlet weak var hintPlusView: UIView!
    @IBOutlet weak var continueBTN: UIButton!
    private let quizLoader = EmojisLoader()
    private var questionArray = [Question]()
    private var questionIndex = 0
    private var savedIndex = UserDefaults.standard.integer(forKey: "indexBrKey")
    private var score = 0
    private var highScore = UserDefaults.standard.integer(forKey: "scoreBrKey")
    private var hint = 0
    private var savedHint = UserDefaults.standard.integer(forKey: "hintsBrKey")
    private var currentQuestion: Question!
    private var timer = Timer()
    
    var quiz:String = ""
    
    @IBAction func questionACT(_ sender: Any) {
        loadNextBrandQuestion()
        answerTFD.becomeFirstResponder()
    }
    @IBAction func hintACT(_ sender: Any) {
        hintPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLBL.layer.cornerRadius = 10
        scoreLBL.layer.masksToBounds = true
        hintLBL.layer.cornerRadius = 10
        hintLBL.layer.masksToBounds = true
        questionLBL.layer.cornerRadius = 20
        questionLBL.layer.masksToBounds = true
        answerTFD.layer.cornerRadius = 5
        answerTFD.layer.masksToBounds = true
        continueBTN.layer.cornerRadius = 5
        continueBTN.layer.masksToBounds = true
        scoreLBL.text = String(highScore)
        hintLBL.text = String(savedHint)
        loadQuestions()
    }
    
    func loadQuestions() {
        do {
            questionArray = try quizLoader.loadEmojis(forQuiz: "Brands")
            loadNextBrandQuestion()
        } catch {
            switch error {
            case LoaderError.dictionaryFailed:
                print("Could not load dictionary")
            case LoaderError.pathFailed:
                print("Could not find valid file at path")
            default:
                print("Unknown error")
            }
        }
    }
    
    func loadNextBrandQuestion() {
        UIView.transition(with: questionLBL, duration: 1, options: .transitionFlipFromTop, animations: {}, completion: nil)
        continueBTN.isHidden = true
        congratsLBL.isHidden = true
        hintPlusView.isHidden = true
        hintBTN.isEnabled = true
        answerTFD.becomeFirstResponder()
        currentQuestion = questionArray[savedIndex]
        setTitlesForButtons()
    }
    
    func setTitlesForButtons() {
        answerTFD.delegate = self
        questionLBL.text = currentQuestion.question
        answerTFD.text = nil
        answerTFD.isEnabled = true
    }
    
    func hintPressed() {
        let answer = currentQuestion.correctAnswer
        let index = answer.index(answer.endIndex, offsetBy: -2)
        let substring = answer.suffix(from: index)
        if(hint > 0) {
            hint -= 1
            hintLBL.text = String(hint)
            saveHints()
            givenHintLBL.text = "The last 2 letters are:  \"" + substring + "\""
            givenHintLBL.isHidden = false
            hintBTN.isEnabled = false
        } else {
            zeroHintAlert()
        }
    }
    
    func checkAnswer(withString string: String) {
        timer.invalidate()
        answerTFD.isEnabled = false
        if string == currentQuestion.correctAnswer {
            score += 1
            hint += 1
            questionIndex += 1
            hintBTN.isEnabled = false
            congratsLBL.isHidden = false
            givenHintLBL.isHidden = true
            hintPlusView.isHidden = false
            continueBTN.isEnabled = true
            continueBTN.isHidden = false
            answerTFD.text = currentQuestion.correctAnswer
            saveScore()
            saveHints()
            UIView.transition(with: hintLBL, duration: 1, options: .transitionFlipFromRight, animations: {
                self.hintLBL.text = String(self.savedHint)
            }, completion: nil)
            UIView.transition(with: scoreLBL, duration: 1, options: .transitionFlipFromRight, animations: {
                self.scoreLBL.text = String(self.highScore)
            }, completion: nil)
            UIView.transition(with: congratsLBL, duration: 1, options: .transitionCrossDissolve, animations: {}, completion: nil)
            UIView.transition(with: hintPlusView, duration: 1, options: .transitionFlipFromBottom, animations: {}, completion: nil)
        } else {
            showWrongAlert()
            answerTFD.isEnabled = true
        }
    }
    
    func saveScore() {
        UserDefaults.standard.set(score, forKey: "scoreBrKey")
        highScore = UserDefaults.standard.integer(forKey: "scoreBrKey")
        
        UserDefaults.standard.set(questionIndex, forKey: "indexBrKey")
        savedIndex = UserDefaults.standard.integer(forKey: "indexBrKey")
    }
    
    func saveHints() {
        UserDefaults.standard.set(hint, forKey: "hintsBrKey")
        savedHint = UserDefaults.standard.integer(forKey: "hintsBrKey")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let string = textField.text?.uppercased() {
            checkAnswer(withString: string)
        }
        return true
    }
    
    func showWrongAlert() {
        let wrongAlert = UIAlertController(title: "Nope, try again!", message: "", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Try again", style: .default)
        wrongAlert.addAction(tryAgain)
        present(wrongAlert, animated: true, completion: nil)
    }
    
    func zeroHintAlert() {
        let noHintsAlert = UIAlertController(title: "Sorry, you're out of hints!", message: "", preferredStyle: .alert)
        let goBack = UIAlertAction(title: "Go back", style: .default)
        noHintsAlert.addAction(goBack)
        present(noHintsAlert, animated: true, completion: nil)
    }
    
}
