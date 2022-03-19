//
//  ViewController.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-18.
//

import UIKit
import CoreData

class WorkoutViewController: UITableViewController {

    var workoutRoutines : [Routine] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRoutines()
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutRoutines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath)
        let routine = workoutRoutines[indexPath.row]
        
        cell.textLabel?.text = routine.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToExercise", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExerciseViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedRoutine = workoutRoutines[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Workout Routines
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Routine", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a New Routine"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Create New Routine", style: .default) { (action) in
            let newRoutine = Routine(context: self.context)
            //TBD - add code to ensure user enters text, no empty string
            newRoutine.name = textField.text!
            
            self.workoutRoutines.append(newRoutine)
            self.saveRoutine()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveRoutine() {
        do {
            try context.save()
        } catch {
            print("Error saving routine: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadRoutines(with request: NSFetchRequest<Routine> = Routine.fetchRequest()) {
        do {
            workoutRoutines = try context.fetch(request)
        } catch {
            print("Error loading routines: \(error)")
        }
        
        tableView.reloadData()
    }
}

