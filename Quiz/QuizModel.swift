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
        
        // Go retrieve data (could be local path or network call)
        getLocalJsonFile()
        
        // When it comes back, call the questionsRetrieved method of the delegate
        // delegate?.questionsRetrieved(questions: [Question]())
    }
    
    func getLocalJsonFile() {
        // Get a path to the JSON file in our app bundle
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json") // this returns an optional string hence the need for the guard statement
        
        guard path != nil else {
            // Can read the above as "confirm path is not nil or else handle that case if it is nil:
            print("Can't find the JSON file")
            return // jumps out of getLocalJsonFile()
        }
        
        // Create a URL object from that string path
        let url = URL(fileURLWithPath: path!)
        
        // Get the data from that URL & decode the data
        do{
            let data = try Data(contentsOf: url) // This is a data object. It represents the data stream or the byte buffer in memory of that resource or file that we are going to access. This initializer potentially throws an error - so we need some error handling (so whenever a method or an init throws u need to use the try keyword and wrap in a do-catch block)
            
            // Decode that data into instances of Question struct
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Return the question structs to the view controller
            delegate?.questionsRetrieved(questions: array)
        } catch {
            print("Couldn't create data object from file")
        }
    }
    
    func getRemoteJsonFile() {
        
    }
}
