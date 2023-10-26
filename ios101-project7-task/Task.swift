//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date
    
    var id: String

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.id = UUID().uuidString
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    //let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {


    // Existing tasks key used to access existing tasks from UserDefaults
    static var existingsTasksKey: String {
        return "existingsTasks"
    }
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task], forKey key: String) {

        // TODO: Save the array of tasks
        
        // 1. Create an instance of UserDefaults
        let defaults = UserDefaults.standard
        
        // 2. Encode the array of `Task` objects to `Data`
        let encodedData = try! JSONEncoder().encode(tasks)
        
        // 3. Save the encoded `Data` to User defaults with a key
        defaults.set(encodedData, forKey: key)
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks(forKey key: String) -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        
        // 1. Create an instance of UserDefaults
        let defaults = UserDefaults.standard
        
        // 2. Get any pre-existing task `Data` saved to UserDefaults (if any exist)
        if let data = defaults.data(forKey: existingsTasksKey) {
            // 3. Try to decode the task `Data` to `Task` objects
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            
            // 4. If the data is retrieved from UserDefaults and successfully decoded, return array of Tasks
            return decodedTasks // return saved tasks
        }
        else {
            return [] // 👈 replace with returned saved tasks
        }
    }

    // Add a new task or update an existing task with the current task.
    func save() {

        // TODO: Save the current task
        print(" Task.save() function called")
        
        // 1. Get all existing tasks from UserDefaults
        var existingsTasks = Task.getTasks(forKey: Task.existingsTasksKey)
        
        // 2. Add the task to the Tasks array
        // Check if the current tasks already exists in the `tasks` array
        //let if index = existingsTasks.firstIndex(of: self)
        print("self: \(self)")
        print("\n")
        for task in existingsTasks {
            print(task, "\n\n")
        }
        
        if (existingsTasks.filter{ $0.id == self.id }.count != 0) {
            guard let taskToUpdate = existingsTasks.filter({ $0.id == self.id }).first else { return }
            let index = existingsTasks.firstIndex(of: taskToUpdate)!
            print("tasks[] size: \(existingsTasks.count)")
            existingsTasks.remove(at: index)
            print("tasks[] size: \(existingsTasks.count)")
            existingsTasks.insert(self, at: index)
        }
        else { // if no matching tasks already exists, add to end of the `tasks` array
            existingsTasks.append(self)
        }
        
        // 3. Save the updated Tasks array
        Task.save(existingsTasks, forKey: Task.existingsTasksKey)
    }
}
