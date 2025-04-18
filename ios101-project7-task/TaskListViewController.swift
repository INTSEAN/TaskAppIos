//
//  TaskListViewController.swift
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // An "Empty State" label to show when there aren't any tasks.
    @IBOutlet weak var emptyStateLabel: UILabel!

    // The main tasks array initialized with a default value of an empty array.
    var tasks = [Task]()

    // Programmatically created UI elements
    private var tableViewProgrammatic: UITableView?
    private var emptyStateLabelProgrammatic: UILabel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupProgrammaticUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupProgrammaticUI() {
        // Create table view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 0)
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // Create empty state label
        let emptyLabel = UILabel()
        emptyLabel.text = "Tap the \"+\" button to add tasks"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = UIColor.tertiaryLabel
        emptyLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        // Layout constraints for table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Layout constraints for empty state label
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
        
        // Store references
        self.tableViewProgrammatic = tableView
        self.emptyStateLabelProgrammatic = emptyLabel
        
        // Add navigation bar button for adding tasks
        navigationItem.title = "Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapNewTaskButton)
        )
    }

    // Then update viewDidLoad to handle both cases
    override func viewDidLoad() {
        super.viewDidLoad()

        // If loaded from storyboard
        if let tableView = tableView {
            // Hide top cell separator
            tableView.tableHeaderView = UIView()

            // Set table view data source and delegate
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // Refresh the tasks list each time the view appears in case any tasks were updated on the other tab.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshTasks()
    }

    // When the "+" button is tapped, perform the segue with id, "ComposeSegue".
    @IBAction func didTapNewTaskButton(_ sender: Any) {
        // Create and configure a TaskComposeViewController
        let taskComposeVC = TaskComposeViewController()
        
        // Set up the onComposeTask closure
        taskComposeVC.onComposeTask = { [weak self] task in
            task.save()
            self?.refreshTasks()
        }
        
        // Wrap it in a navigation controller
        let navController = UINavigationController(rootViewController: taskComposeVC)
        
        // Present it modally
        self.present(navController, animated: true)
    }

    // Prepare for navigation to the Task Compose View Controller.
    // 1. Check the segue identifier to confirm the segue that is being performed is indeed the "ComposeSegue".
    //    - The segue ID, "ComposeSegue", was set in the storyboard.
    // 2. Get the task Compose View Controller so we can configure it ahead of navigation.
    //    i. Since the segue is actually hooked up to the navigation controller that manages the TaskComposeViewController, we need to access the navigation controller first...
    //    ii. ...then get the actual ComposeViewController via the navigation controller's `topViewController` property.
    // 3. If a task was sent along as the segue's sender (for the edit task case), set that task as the `taskToEdit`.
    // 4. Add the code to be run when a task is composed (i.e. created or edited, which happens when the user taps the "Done" button on the task compose view controller and the onComposeTask closure is called)
    //    i. Save the new or edited task.
    //    ii. Refresh the tasks list.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1.
        if segue.identifier == "ComposeSegue" {
            // 2.
            // i.
            if let composeNavController = segue.destination as? UINavigationController,
                // ii.
               let composeViewController = composeNavController.topViewController as? TaskComposeViewController {

                // 3.
                composeViewController.taskToEdit = sender as? Task

                // 4.
                // i.
                // ii.
                composeViewController.onComposeTask = { [weak self] task in
                    task.save()
                    self?.refreshTasks()
                }
            }
        }
    }

    // MARK: - Helper Functions
    
    // Refresh all tasks
    // 1. Get the current saved tasks
    // 2. Sort the tasks list for the following conditions:
    //    i. For completed tasks, sort ascending based on the completed date.
    //    ii. For incomplete tasks, sort ascending based on the date they were created.
    //    iii. Sort incomplete tasks before completed tasks.
    // 3. Update the main tasks array with the refreshed and sorted tasks.
    // 4. Hide the "empty state label" if there are tasks present.
    // 5. Reload the table view data to reflect any updates to the tasks array.
    //    - reloadSections(IndexSet(integer: 0), with: .automatic) is similar to `reloadData()` with the added ability to update the table view changes with animation.
    private func refreshTasks() {
        // 1.
        var tasks = Task.getTasks()
        // 2.
        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                // i.
                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {
                // ii.
                return lhs.createdDate < rhs.createdDate
            } else {
                // iii.
                return !lhs.isComplete && rhs.isComplete
            }
        }
        // 3.
        self.tasks = tasks
        // 4.
        if let emptyStateLabel = emptyStateLabel {
            emptyStateLabel.isHidden = !tasks.isEmpty
        } else if let emptyStateLabelProgrammatic = emptyStateLabelProgrammatic {
            emptyStateLabelProgrammatic.isHidden = !tasks.isEmpty
        }
        
        // 5.
        if let tableView = tableView {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else if let tableViewProgrammatic = tableViewProgrammatic {
            tableViewProgrammatic.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - Table View Data Source Methods

// An extension to group all table view data source related methods
extension TaskListViewController: UITableViewDataSource {

    // The number of rows to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    // Create and configure a cell for each row of the table view (i.e. each task in the tasks array)
    // 1. Dequeue a Task cell.
    // 2. Get the task for the associated row.
    // 3. Configure the cell with the task and add the code to be run when the complete button is tapped...
    //    i. Save the task passed back in the closure.
    //    ii. Refresh the tasks list to reflect the updates with the saved task.
    // 4. Return the configured cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.
        let cell: TaskCell
        
        if tableView === self.tableView {
            // Storyboard cell
            cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        } else {
            // Programmatic cell
            cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        }
        
        // 2.
        let task = tasks[indexPath.row]
        // 3.
        cell.configure(with: task, onCompleteButtonTapped: { [weak self] task in
            // i.
            task.save()
            // ii.
            self?.refreshTasks()
        })
        // 4.
        return cell
    }

    // Enable "Swipe to Delete" functionality. The existence of this data source method enables the default "Swipe to Delete".
    // 1. Handle the "delete" case:
    // 2. Remove the associated task from the tasks array.
    // 3. Save the updated tasks array.
    // 4. Tell the table view to delete the associated row.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1.
        if editingStyle == .delete {
            // 2.
            tasks.remove(at: indexPath.row)
            // 3.
            Task.save(tasks)
            // 4.
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Table View Delegate Methods

// An extension to group all table view delegate related methods
extension TaskListViewController: UITableViewDelegate {

    // The table view delegate method called when a row is selected.
    // In this case, the user has tapped an existing task row and we want to segue them to the Compose View Controller to edit the associated task.
    // 1. Deselect the row so the row doesn't stay in the slected state. (This is just a design preference in this case).
    // 2. Get the task associated with the selected row.
    // 3. Create and present the Compose View Controller to edit the task.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.
        tableView.deselectRow(at: indexPath, animated: false)
        // 2.
        let selectedTask = tasks[indexPath.row]
        // 3.
        let taskComposeVC = TaskComposeViewController()
        taskComposeVC.taskToEdit = selectedTask
        
        // Set up the onComposeTask closure
        taskComposeVC.onComposeTask = { [weak self] task in
            task.save()
            self?.refreshTasks()
        }
        
        // Wrap it in a navigation controller
        let navController = UINavigationController(rootViewController: taskComposeVC)
        
        // Present it modally
        self.present(navController, animated: true)
    }
}
