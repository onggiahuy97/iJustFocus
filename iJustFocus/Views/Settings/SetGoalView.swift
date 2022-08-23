//
//  SetGoalView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/22/22.
//

import SwiftUI

struct SetGoalView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    let step = 1
    let range = 1...120
    let rangeInDouble = 1.0...120.0
    
    var attributedString: AttributedString {
        var str = AttributedString("Current Goal: \(appViewModel.goalInMinutes) (minutes of focus a day)")
        let range = str.range(of: "\(appViewModel.goalInMinutes)")!
        str[range].foregroundColor = appViewModel.color
        str[range].font = .headline
        return str
    }
    
    var body: some View {
        Form {
            Section {
                Stepper(value: $appViewModel.goalInMinutes, in: range, step: step) {
                    Text(attributedString)
                        .padding()
                        .monospacedDigit()
                }
                
                let bindingValue = Binding<Double> {
                    Double(self.appViewModel.goalInMinutes)
                } set: {
                    self.appViewModel.goalInMinutes = Int($0)
                }
                
                Slider(value: bindingValue, in: rangeInDouble, step: Double(step))
                    .padding()
                
            }
            .navigationTitle("Goal")
        }
    }
}
