//
//  QuizModel.swift
//  Quiz
//
//  Created by Nicko Lee on 3/19/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import Foundation

// A way for the QuizModel to contact the VC
protocol QuizProtocol {
    func questionsRetrieved(questions: [Question]) // will pass back an array of questions (i.e. instances of the Questions struct)
}

class QuizModel {
    
    // The other thing we need to do to complete this protocol-delegate pattern. We need to declare a delegate prop inside the QuizModel class
    var delegate: QuizProtocol? // optional cos at the start nothing is assigned to it
    
    
    // Note this func doesn't have a return value as we will implement a custom protocol to allow the QuizModel to contact the VC when the questions have finally been returned from over the network
    func getQuestions() {
        
        // TODO: Go retrieve data
        
        
        // When it comes back, call the questionsRetrieved method of the delegate
        delegate?.questionsRetrieved(questions: [Question]())
    }
}
