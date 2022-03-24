//
//  StrengthExerciseDetailsViewController.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-22.
//

import UIKit
import CoreData

class StrengthExerciseDetailsViewController: UIViewController {

    var exerciseSets: [StrengthExerciseSet] = []
    var selectedExercise : Exercise? {
        didSet {
            
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var setDetailsTableView: UITableView!
    @IBOutlet weak var exerciseCommentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data sources
        setDetailsTableView.dataSource = self
        
        //Delegates
//        self.setDetailsTableView.delegate = self
        self.exerciseCommentTextField.delegate = self
        
        //View Appearance
        self.title = selectedExercise!.name!
        setDetailsTableView.register(UINib(nibName: "ExerciseSetCell", bundle: nil), forCellReuseIdentifier: "setDetailsCell")
        loadExerciseSets()
        self.hideKeyboardTapOutside()
        
//        Adding 3 default sets to exercise - not saved until user presses save button
        if(self.exerciseSets.count == 0) {
            for i in 1...3 {
                let set = StrengthExerciseSet(context: self.context)
                set.setNum = Int16(i)
                set.reps = 8
                set.weight = 0.0
                set.parentExercise = self.selectedExercise

                exerciseSets.append(set)
            }
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.saveExerciseSets()
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIButton) {
        let set = StrengthExerciseSet(context: self.context)
        set.setNum = Int16(exerciseSets.count + 1)
        set.reps = 8
        set.weight = 0.0
        set.parentExercise = self.selectedExercise
        
        exerciseSets.append(set)
        setDetailsTableView.reloadData()
    }
    
    //MARK: - Data Manipulation Methods
    func saveExerciseSets() {
        do {
            try context.save()
            self.performSegue(withIdentifier: "unwindToExercise", sender: self)
        } catch {
            print("Error saving sets to exercise: \(error)")
        }
    }
    
    func loadExerciseSets(with request: NSFetchRequest<StrengthExerciseSet> = StrengthExerciseSet.fetchRequest(), predicate: NSPredicate? = nil) {
        let exercisePredicate = NSPredicate(format: "parentExercise.name MATCHES %@", selectedExercise!.name!)
        request.predicate = exercisePredicate
        request.sortDescriptors = [NSSortDescriptor(key: "setNum", ascending: true)]
        
        do {
            exerciseSets = try context.fetch(request)
            
        } catch {
            print("Error fetching routine exercises: \(error)")
        }
        
        setDetailsTableView.reloadData()
    }
}

//MARK: - setDetailsTableView Datasource Methods
extension StrengthExerciseDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setDetailsTableView.dequeueReusableCell(withIdentifier: "setDetailsCell", for: indexPath) as! ExerciseSetCell
        cell.setField.text = String(exerciseSets[indexPath.row].setNum)
        cell.repDurationField.text = String(exerciseSets[indexPath.row].reps)
        cell.weightField.text = String(exerciseSets[indexPath.row].weight)
        
        return cell
    }
}

//extension StrengthExerciseDetailsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        //To be used to update cells maybe?
//    }
//}

//MARK: - Keyboard dismissing methods
extension StrengthExerciseDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboardTapOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
