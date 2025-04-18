import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the view controllers for the tabs
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        // Get the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Create the Tasks tab
        // Try to get the TaskListViewController from the storyboard
        let taskListVC = TaskListViewController()
        let taskListNavController = UINavigationController(rootViewController: taskListVC)
        taskListVC.title = "Tasks"
        taskListNavController.tabBarItem = UITabBarItem(
            title: "Tasks",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        // Create the Calendar tab
        let calendarVC = CalendarViewController()
        let calendarNavController = UINavigationController(rootViewController: calendarVC)
        calendarVC.title = "Calendar"
        calendarNavController.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            tag: 1
        )
        
        // Set the view controllers for the tab bar
        self.viewControllers = [taskListNavController, calendarNavController]
    }
} 