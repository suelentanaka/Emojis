//
//  EmojisLoader.swift
//  Emojis
//
//  Created by Suelen Tanaka on 2018-10-25.
//  Copyright © 2018 Suelen Tanaka. All rights reserved.
//

import Foundation

struct Question {
    let question: String
    let correctAnswer: String
}

enum LoaderError: Error {
    case dictionaryFailed, pathFailed
}

class EmojisLoader {
    
    public func loadEmojis(forQuiz quizName: String) throws -> [Question] {
        var questions = [Question]()
        if let path = Bundle.main.path(forResource: quizName, ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let tempArray: Array = dict["Questions"]! as! [Dictionary<String,AnyObject>]
                for dictionary in tempArray {
                    let questionToAdd = Question(question: dictionary["Question"] as! String, correctAnswer: dictionary["CorrectAnswer"] as! String)
                    questions.append(questionToAdd)
                }
                return questions
            } else {
                throw LoaderError.dictionaryFailed
            }
        } else {
            throw LoaderError.pathFailed
        }
    }
}
