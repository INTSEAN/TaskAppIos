//
//  TaskCell.swift
//

import UIKit

// A cell to display a task
class TaskCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    // Programmatically created UI elements
    private var titleLabelProgrammatic: UILabel?
    private var noteLabelProgrammatic: UILabel?
    private var completeButtonProgrammatic: UIButton?

    // The closure called, passing in the associated task, when the "Complete" button is tapped.
    private var onCompleteButtonTapped: ((Task) -> Void)?

    // The task associated with the cell
    private var task: Task?

    // Override init for programmatic cell creation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProgrammaticUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupProgrammaticUI() {
        // Create a stack view for the cell content
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        // Create button stack
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.alignment = .top

        // Create the complete button
        let button = UIButton(type: .system)
        button.tintColor = UIColor.tertiaryLabel
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)

        // Create text stack view for title and note
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4

        // Create title label
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 0

        // Create note label
        let noteLabel = UILabel()
        noteLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        noteLabel.textColor = UIColor.secondaryLabel
        noteLabel.numberOfLines = 0

        // Add subviews to their respective stack views
        buttonStack.addArrangedSubview(button)
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(noteLabel)

        stackView.addArrangedSubview(buttonStack)
        stackView.addArrangedSubview(textStack)

        // Set up constraints for the main stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        // Store references to the UI elements
        self.completeButtonProgrammatic = button
        self.titleLabelProgrammatic = titleLabel
        self.noteLabelProgrammatic = noteLabel
    }

    // Configure the cell with a task
    func configure(with task: Task, onCompleteButtonTapped: @escaping (Task) -> Void) {
        self.task = task
        self.onCompleteButtonTapped = onCompleteButtonTapped

        if titleLabel != nil {
            // Storyboard UI
            titleLabel.text = task.title
            noteLabel.text = task.note
            completeButton.isSelected = task.isComplete
        } else if let titleLabelProg = titleLabelProgrammatic,
                  let noteLabelProg = noteLabelProgrammatic,
                  let completeButtonProg = completeButtonProgrammatic {
            // Programmatic UI
            titleLabelProg.text = task.title
            noteLabelProg.text = task.note
            completeButtonProg.isSelected = task.isComplete
        }
    }

    // The function called when the "Complete" button is tapped.
    // 1. Toggle the isComplete boolean state of the task
    // 2. Update the cell's UI with the current task state
    // 3. Call the `onCompleteButtonTapped` closure, passing in the current task so other view controllers can react to the change in task completed status.
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        guard var task = task else { return }

        task.isComplete.toggle()

        if sender == completeButton {
            completeButton.isSelected = task.isComplete
        } else if let completeButtonProg = completeButtonProgrammatic {
            completeButtonProg.isSelected = task.isComplete
        }

        onCompleteButtonTapped?(task)
    }

    // Initial configuration of the task cell
    // 1. Set the main task property
    // 2. Set the onCompleteButtonTapped closure
    // 3. Update the UI for the given task
    func configure(with task: Task, onCompleteButtonTapped: ((Task) -> Void)?) {
        // 1.
        self.task = task
        // 2.
        self.onCompleteButtonTapped = onCompleteButtonTapped
        // 3.
        update(with: task)
    }

    // Update the UI for the given task
    // The complete button's image has already been configured in the storyboard for default and selected states.
    // 1. Set the title and note labels
    // 2. Hide the note label if task.note property is empty. (This just helps the title label align with the completed button when there's no note)
    // 3. Set the text color based on the task completed state
    // 4. Set the "Completed" button's selected state based on the task's completed state.
    // 5. Set the button's tint color based on the task's completed state. (blue if complete, system gray if not)
    private func update(with task: Task) {
        // 1.
        titleLabel.text = task.title
        noteLabel.text = task.note
        // 2.
        noteLabel.isHidden = task.note == "" || task.note == nil
        // 3.
        titleLabel.textColor = task.isComplete ? .secondaryLabel : .label
        // 4.
        completeButton.isSelected = task.isComplete
        // 5.
        completeButton.tintColor = task.isComplete ? .systemBlue : .tertiaryLabel
    }

    // This overrides the table view cell's default selected and highlighted behavior to do nothing, otherwise, the row would darken when tapped
    // This is just a design / UI polish for this particular use case. Since we also have the "Completed" button in the row, it looks kinda weird if the whole cell darkens during selection.
    override func setSelected(_ selected: Bool, animated: Bool) { }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) { }
}
