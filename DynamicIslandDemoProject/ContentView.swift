//
//  ContentView.swift
//  DynamicIslandDemoProject
//
//  Created by Javid Shaikh on 13/11/23.
//

//PART 1

// In this video we will explore how to implement a dynamic island tracking system.
// In coming next video we'll implement live activity on lock screen.

// let's add the widget on island

//PART 2

// We'll continue from last video in which we implemented the dynamic island feature.
// Today we'll explore the live activity on lock screen


import SwiftUI
import ActivityKit

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                do {
                    deleteAllActivities()
                    
                    let id = try LiveActivityManager.startActivity(arrivalTime: "15 Mins", phoneNumber: "12345678", restaurantName: "McDonald's", customerAddress: "221b Baker Street", remainingDistance: "50")
                    
                    UserDefaultsManager.saveNewActivity(id: id, arrivalTime: "15 Mins", phoneNumber: "12345678", restaurantName: "McDonald's", customerAddress: "221b Baker Street", remainingDistance: "50")
                } catch {
                    print(error.localizedDescription)
                }
                
            }, label: {
                Text("Place Order")
            })
        }
        .padding()
    }
    
    private func deleteAllActivities() {
        for item in UserDefaultsManager.fetchActivities() {
            if let activity = Activity<FoodDeliveryAttributes>.activities.first(where: { $0.content.state.phoneNumber == item.phoneNumber }) {
                Task {
                    await LiveActivityManager.endActivity(activity.id)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
