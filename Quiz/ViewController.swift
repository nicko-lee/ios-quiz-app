//
//  ViewController.swift
//  Quiz
//
//  Created by Nicko Lee on 3/19/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuizModel()
    var questions = [Question]()
    var questionIndex = 0 // keeps track of what question the user is currently viewing and answering
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Conform to the table view protocols
        tableView.dataSource = self
        tableView.delegate = self
        
        // Kick off the process to retrive the questions. Notice that nothing gets returned from calling this. We will need to go back to QuizModel to create a custom protocol so we can contact the VC from the QuizModel and notify VC that the questions are ready
        // How does the QuizModel contact the VC when the questions are ready? When the VC creates an instance of the QM, we will have the VC set itself to the delegate property of the QM class. So that now the QM object has a reference to the VC
        model.delegate = self // self refers to the VC of course
        model.getQuestions()
    }

    // MARK: QuizProtocol method
    
    func questionsRetrieved(questions: [Question]) {
        
        // Set our question prop with questions from quiz model
        self.questions = questions
        
        // Tell the table view to reload the data
        tableView.reloadData() // just like what I used in Match App to reload my cards in the collection view. This triggers the table view to ask the VC for data again (i.e. those 2 protocol method calls. Ask for how many rows there are and for each row it is trying to display what cell should it use?)
    }
    
    // MARK: TableView Protocol methods
    
    // TableView asks VC how many rows of data must we display?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Guard statement cos the table view needs an integer or it will crash. Here we are handling that
        guard questions.count > 0 && questions[questionIndex].answers != nil else {
            return 0
        }
        return questions[questionIndex].answers!.count
    }
    
    // This is the table view asking the VC for a particular row number, what is the table cell I need to use? And what sort of data should I display for that row?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Get a reference to the label in that cell
        let label = cell.viewWithTag(1) as! UILabel
        
        // TODO: Set the text for the label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // User has selected an answer
    }

}

