//
//  GameViewController.swift
//  Emojis
//
//  Created by Suelen Tanaka on 2018-11-08.
//  Copyright © 2018 Suelen Tanaka. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITextFieldDelegate {

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
    private var savedIndex = UserDefaults.standard.integer(forKey: "indexKey")
    private var score = 0
    private var highScore = UserDefaults.standard.integer(forKey: "moviesKey")
    private var hint = 0
    private var savedHint = UserDefaults.standard.integer(forKey: "hintsKey")
    private var currentQuestion: Question!
    private var timer = Timer()
    
    var quiz:String = ""
    
    @IBAction func questionACT(_ sender: Any) {
        loadNextQuestion()
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
            questionArray = try quizLoader.loadEmojis(forQuiz: "Movies")
            loadNextQuestion()
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
    
    func loadNextQuestion() {
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
        UserDefaults.standard.set(score, forKey: "moviesKey")
        highScore = UserDefaults.standard.integer(forKey: "moviesKey")
        
        UserDefaults.standard.set(questionIndex, forKey: "indexKey")
        savedIndex = UserDefaults.standard.integer(forKey: "indexKey")
    }
    
    func saveHints() {
        UserDefaults.standard.set(hint, forKey: "hintsKey")
        savedHint = UserDefaults.standard.integer(forKey: "hintsKey")
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


//    func updateProgressView() {
//        progressView.progress -= 0.01/30
//        if progressView.progress <= 0 {
//            outOfTime()
//        } else if progressView.progress <= 0.2 {
//            progressView.progressTintColor = flatRed
//        } else if progressView.progress <= 0.5 {
//            progressView.progressTintColor = flatOrange
//        }
//    }

//    func outOfTime() {
//        timer.invalidate()
//        showAlert(forReason: 0)
//    }

    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.answerView.frame.origin.y -= keyboardSize.height
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.answerView.frame.origin.y += keyboardSize.height
//        }
//    }
    
//
//    func showAlert(forReason reason: Int) {
//        switch reason {
//        case 0:
//            quizAlertView = QuizAlertView(withTitle: "You lost", andMessage: "You ran out of time", colors: [backgroundColor,foregroundColor])
//        case 1:
//            quizAlertView = QuizAlertView(withTitle: "You lost", andMessage: "You entered the wrong answer", colors: [backgroundColor,foregroundColor])
//        case 2:
//            quizAlertView = QuizAlertView(withTitle: "You won", andMessage: "You have answered all questions", colors: [backgroundColor,foregroundColor])
//        default:
//            break
//        }
//
//        if let qav = quizAlertView {
//            quizAlertView?.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
//            createQuizAlertView(withAlert: qav)
//        }
//    }
//
//    func createQuizAlertView(withAlert alert: QuizAlertView) {
//        alert.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(alert)
//
//        alert.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        alert.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        alert.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        alert.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    func closeAlert() {
//        if score > highscore {
//            highscore = score
//            UserDefaults.standard.set(highscore, forKey: emojiHighscoreIdentifier)
//        }
//        UserDefaults.standard.set(score, forKey: emojiRecentscoreIdentifier)
//        _ = navigationController?.popViewController(animated: true)
//    }
//
//    override func didMove(toParentViewController parent: UIViewController?) {
//        super.didMove(toParentViewController: parent)
//        if parent == nil {
//            timer.invalidate()
//        }
//    }
    
    
    
    
    
    
    
    
    
    
//}
