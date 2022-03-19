//
//  ExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-19.
//

import UIKit
import CoreData

class ExerciseViewController: UITableViewController {
    
    var routineExercises : [Exercise] = []
    var selectedRoutine : Routine? {
        didSet {
            loadExercises()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercises()
    }

    // MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineExercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        let exercise = routineExercises[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    //MARK: - Delegate Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToExerciseDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExerciseDetailsViewController
        destinationVC.selectedRoutine = selectedRoutine
    }
    
    @IBAction func unwindToExercise(segue: UIStoryboardSegue) {
        loadExercises()
    }

    //MARK: - Data Manipulation Methods
    func loadExercises(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest(), predicate: NSPredicate? = nil) {
        let routinePredicate = NSPredicate(format: "parentRoutine.name MATCHES %@", selectedRoutine!.name!)
        request.predicate = routinePredicate
        
        do {
            routineExercises = try context.fetch(request)
        } catch {
            print("Error fetching routine exercises: \(error)")
        }
        
        tableView.reloadData()
    }

}
