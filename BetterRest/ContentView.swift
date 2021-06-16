//
//  ContentView.swift
//  BetterRest
//
//  Created by Luke Inger on 16/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var formatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var sleepTime = Date()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    

    var body: some View {
        NavigationView {
            Form {
                Section{
                    Text("When do you want to wake up?")
                    .font(.headline)
                
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section{
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in:4...12, step:0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }

                
                Section{
                    Text("Daily Coffee Intake")
                        .font(.headline)
                    Picker("", selection: $coffeeAmount){
                        ForEach(1..<13, content: { index in
                            if index == 1{
                                Text("1 cup")
                            } else {
                                Text("\(index) cups")
                            }
                        })
                    }
                }
                
                Section{
                    Text("Recommended Bedtime: \(formatter.string(from: sleepTime))")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing:
                    Button(action:calculateBedTime) {
                        Text("Calculate")
                    }
            )
        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
    }
    
    func calculateBedTime(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
    
        do {
            
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            sleepTime = wakeUp - prediction.actualSleep

            //alertMessage = formatter.string(from: sleepTime)
            //alertTitle = "Your ideal bedtime is…"
            
        } catch  {
            // somthing happend here, it went wrong!!
            //alertTitle = "Error"
            //alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        //showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
