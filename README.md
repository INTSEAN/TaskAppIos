# Project 7 - *TaskMaster*

Submitted by: **Sean Donovan**

**TaskMaster** is a task management app that allows users to create, manage, and track tasks with due dates. Users can view tasks in both a list view and a calendar view for better organization and planning.

Time spent: **1** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] App displays a list of tasks
- [x] Users can add tasks to the list
- [x] Session persists when application is closed and relaunched (tasks dont get deleted when closing app) 
- [x] Note: You have to quit the app, not minimize it, in order to see the persistence.
- [x] Tasks can be deleted
- [x] Users have a calendar view via navigation controller that displays tasks	


The following **additional** features are implemented:

- [x] Tasks can be toggled completed
- [x] User can edit tasks by tapping on the task in the feed view
- [x] Completed tasks are sorted to the bottom of the list
- [x] Calendar shows visual indicators for dates with tasks
- [x] Calendar indicates whether all tasks on a date are completed or not
- [x] Users can add optional notes to each task
- [x] Task persistence uses UserDefaults with JSON encoding/decoding

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-04-17%20at%2021.41.46.mp4)

Note: If the video above doesn't play directly in GitHub, you can download it to view locally.

## Notes

Challenges encountered while building the app:

- Implementing the tab bar navigation between the Tasks list and Calendar view required careful handling of view controller hierarchies
- Creating a working programmatic UI required ensuring that both storyboard and programmatic approaches worked together seamlessly
- Handling data persistence with UserDefaults required proper implementation of the Codable protocol
- Calendar view needed special handling for date components and task filtering
- Setting up proper cell reuse and task state management between different views

## License

    Copyright 2023 Sean Ovan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. 