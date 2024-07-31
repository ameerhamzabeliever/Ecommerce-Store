//
//  EventLocalManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

final class EventLocalManager{
    
    private init() {}
    
    static let shared = EventLocalManager()
    
    func getLocalEvents() -> [EventData]{
        let userDefault = UserDefaults.standard
        if let data = userDefault.value(forKey: "saveLocalEvent") as? Data{
            if let events = try? JSONDecoder().decode([EventData].self, from: data){
                return events
            }
        }
        return []
    }
    
    func saveLocalEvent(event: EventData){
        let userDefault = UserDefaults.standard
        var events = self.getLocalEvents()
        if !events.isEmpty{
            if events.contains(where: {$0.eventID == event.eventID}){
                if let index = events.firstIndex(where: {$0.eventID == event.eventID}){
                    if !event.timeData.isEmpty{
                        if let time = event.timeData.first{
                            events[index].timeData.append(time)
                        }
                    }else{
                        events.append(event)
                    }
                }else{
                    events.append(event)
                }
            }else{
                events.append(event)
            }
        }else{
            events.append(event)
        }
        Constants.printLogs("Data: \(self.getLocalEvents())")
        if let encoded = try? JSONEncoder().encode(events){
            userDefault.setValue(encoded, forKey: "saveLocalEvent")
        }
    }
    
    func deleteLocalEvent(event: EventData){
        let userDefault = UserDefaults.standard
        var events = self.getLocalEvents()
        if !events.isEmpty{
            if events.contains(where: {$0.eventID == event.eventID}){
                if let eventIndex = events.firstIndex(where: {$0.eventID == event.eventID}){
                    if !events[eventIndex].timeData.isEmpty, let time = event.timeData.first{
                        if let timeIndex = events[eventIndex].timeData.firstIndex(where: {$0.id == time.id}){
                            events[eventIndex].timeData.remove(at: timeIndex)
                            if let encoded = try? JSONEncoder().encode(events){
                                userDefault.setValue(encoded, forKey: "saveLocalEvent")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteAllLocalEvent(){
        let userDefault = UserDefaults.standard
        var events = self.getLocalEvents()
        events.removeAll()
        if let encoded = try? JSONEncoder().encode(events){
            userDefault.setValue(encoded, forKey: "saveLocalEvent")
        }
    }
    
}


