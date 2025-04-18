//
//  TaskComposeViewController.swift
//

import UIKit

class TaskComposeViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    // The onComposeTask closure is called when a task is created or edited.
    var onComposeTask: ((Task) -> Void)?

    // The task to edit if this view controller is being used to edit an existing task.
    var taskToEdit: Task?

    // Programmatically created UI elements
    private var titleFieldProgrammatic: UITextField!
    private var noteFieldProgrammatic: UITextField!
    private var datePickerProgrammatic: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // If we're creating the view programmatically (not from storyboard)
        if titleField == nil {
            setupProgrammaticUI()
        }

        // Set up the view title, task edit values and navigation bar buttons
        configureWithTask()
    }

    private func setupProgrammaticUI() {
        // Set up title field
        titleFieldProgrammatic = UITextField()
        titleFieldProgrammatic.placeholder = "Title"
        titleFieldProgrammatic.borderStyle = .roundedRect
        titleFieldProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFieldProgrammatic)

        // Set up note field
        noteFieldProgrammatic = UITextField()
        noteFieldProgrammatic.placeholder = "Description"
        noteFieldProgrammatic.borderStyle = .roundedRect
        noteFieldProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteFieldProgrammatic)

        // Due date label
        let dateLabel = UILabel()
        dateLabel.text = "Due Date:"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)

        // Set up date picker
        datePickerProgrammatic = UIDatePicker()
        datePickerProgrammatic.datePickerMode = .date
        datePickerProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.4, *) {
            datePickerProgrammatic.preferredDatePickerStyle = .wheels
        }
        view.addSubview(datePickerProgrammatic)

        // Set up constraints
        NSLayoutConstraint.activate([
            // Title field constraints
            titleFieldProgrammatic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleFieldProgrammatic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleFieldProgrammatic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Note field constraints
            noteFieldProgrammatic.topAnchor.constraint(equalTo: titleFieldProgrammatic.bottomAnchor, constant: 8),
            noteFieldProgrammatic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteFieldProgrammatic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Date label constraints
            dateLabel.topAnchor.constraint(equalTo: noteFieldProgrammatic.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            // Date picker constraints
            datePickerProgrammatic.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            datePickerProgrammatic.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            datePickerProgrammatic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Set up the navigation bar buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }

    private func configureWithTask() {
        // Set the title based on whether we're creating a new task or editing an existing task
        title = taskToEdit != nil ? "Edit Task" : "New Task"

        // If we're editing a task, set the title, note and due date values
        if let task = taskToEdit {
            // Use the proper UI elements based on where they came from
            if titleField != nil {
                // From storyboard
                titleField.text = task.title
                noteField.text = task.note
                datePicker.date = task.dueDate
            } else {
                // Programmatically created
                titleFieldProgrammatic.text = task.title
                noteFieldProgrammatic.text = task.note
                datePickerProgrammatic.date = task.dueDate
            }
        }
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        // Dismiss the view controller without creating or editing a task
        dismiss(animated: true)
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        // Check which UI elements to use
        let titleText: String
        let noteText: String
        let date: Date

        if titleField != nil {
            // Using storyboard elements
            titleText = titleField.text ?? ""
            noteText = noteField.text ?? ""
            date = datePicker.date
        } else {
            // Using programmatic elements
            titleText = titleFieldProgrammatic.text ?? ""
            noteText = noteFieldProgrammatic.text ?? ""
            date = datePickerProgrammatic.date
        }

        // Return early if title is empty
        guard !titleText.isEmpty else {
            return
        }

        // Get the current task or create a new one
        var task = taskToEdit ?? Task(title: titleText)

        // Set the title, note and due date values
        task.title = titleText
        task.note = noteText.isEmpty ? nil : noteText
        task.dueDate = date

        // Call the onComposeTask closure to create or edit the task
        onComposeTask?(task)

        // Dismiss the view controller
        dismiss(animated: true)
    }
}
