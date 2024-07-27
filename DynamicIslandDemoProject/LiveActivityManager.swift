//
//  LiveActivityManager.swift
//  DynamicIslandDemoProject
//
//  Created by Javid Shaikh on 13/11/23.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    
    @discardableResult
    static func startActivity(arrivalTime: String, phoneNumber: String, restaurantName: String, customerAddress: String, remainingDistance: String) throws -> String {
       
        var activity: Activity<FoodDeliveryAttributes>?
        let initialContent = ActivityContent(state: FoodDeliveryAttributes.ContentState(arrivalTime: arrivalTime, phoneNumber: phoneNumber, restaurantName: restaurantName, customerAddress: customerAddress, remainingDistance: remainingDistance), staleDate: nil)
        
        do {
            activity = try Activity.request(attributes: FoodDeliveryAttributes(), content: initialContent, pushType: nil)
            
            guard let id = activity?.id else { throw LiveActivityErrorType.failedToGetID }
            return id
        } catch {
            throw error
        }
    }
        
    static func listAllActivities() -> [[String:String]] {
        let sortedActivities = Activity<FoodDeliveryAttributes>.activities.sorted{ $0.id > $1.id }
        
        return sortedActivities.map {
            [
                "id": $0.id,
                "arrivalTime": $0.content.state.arrivalTime,
                "phoneNumber": $0.content.state.phoneNumber,
                "restaurantName": $0.content.state.restaurantName,
                "customerAddress": $0.content.state.customerAddress,
                "remainingDistance": $0.content.state.remainingDistance
            ]
        }
    }
    
    static func endAllActivities() async {
        for activity in Activity<FoodDeliveryAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
    
    static func endActivity(_ id: String) async {
        await Activity<FoodDeliveryAttributes>.activities.first(where: {
            $0.id == id
        })?.end(nil, dismissalPolicy: .immediate)
    }
    
    static func updateActivity(id: String, arrivalTime: String, phoneNumber: String, restaurantName: String, customerAddress: String, remainingDistance: String) async {
        
        let updatedContent = ActivityContent(state: FoodDeliveryAttributes.ContentState(arrivalTime: arrivalTime, phoneNumber: phoneNumber, restaurantName: restaurantName, customerAddress: customerAddress, remainingDistance: remainingDistance), staleDate: nil)
        
        let activity = Activity<FoodDeliveryAttributes>.activities.first(where: { $0.id == id })
        
        await activity?.update(updatedContent)
    }
}

enum LiveActivityErrorType: Error {
    case failedToGetID
}
