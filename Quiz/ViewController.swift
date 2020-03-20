//
//  ViewController.swift
//  Quiz
//
//  Created by Nicko Lee on 3/19/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol {
    
    var model = QuizModel()
    var question = [Question]()
    var questionIndex = 0 // keeps track of what question the user is currently viewing and answering
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Kick off the process to retrive the questions. Notice that nothing gets returned from calling this. We will need to go back to QuizModel to create a custom protocol so we can contact the VC from the QuizModel and notify VC that the questions are ready
        // How does the QuizModel contact the VC when the questions are ready? When the VC creates an instance of the QM, we will have the VC set itself to the delegate property of the QM class. So that now the QM object has a reference to the VC
        model.delegate = self // self refers to the VC of course
        model.getQuestions()
    }

    // MARK: QuizProtocol method
    
    func questionsRetrieved(questions: [Question]) {
        print("Hey question are returned!")
    }

}

