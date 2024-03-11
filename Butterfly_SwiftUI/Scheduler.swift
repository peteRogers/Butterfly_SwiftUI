//
//  Scheduler.swift
//  Butterfly_SwiftUI
//
//  Created by Peter Rogers on 08/03/2024.
//

import Foundation

class Scheduler {
	private var task: DispatchWorkItem?
	
	// Function to schedule a new task
	func scheduleTask(after delay: TimeInterval, task: @escaping () -> Void) {
		// Cancel the previous task if it exists
		self.task?.cancel()
		
		let workItem = DispatchWorkItem(block: task)
		self.task = workItem
		
		// Schedule the task on the main queue
		DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
	}
	
	// Function to cancel the scheduled task
	func cancelTask() {
		task?.cancel()
		task = nil
	}
}
