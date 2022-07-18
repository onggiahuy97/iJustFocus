//
//  TimerView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var model: TimerViewModel
    
    var body: some View {
        VStack {
            // Segmented Picker
            Picker(selection: $model.timeType) {
                ForEach(TimerViewModel.TimeType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            } label: {
                Text("Time Type")
            }
            .padding()
            .pickerStyle(.segmented)
            .modifier(SegmentedControllerViewModifier())
            
            Spacer()
            
            // Clock
            Text(model.second.toTimeString)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(Font(.init(.message, size: 46)))
            
            Spacer()
            
            // Buttons
            HStack {
                Spacer()
                
                CircleButton("Stop", .red){
                    model.stop()
                }
                                
                CircleButton("Start") {
                    model.start()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    func CircleButton(_ text: String, _ foregroundColor: Color = .white ,action: @escaping (() -> Void)) -> some View{
        return Button(text, action: action)
            .padding(20)
            .foregroundColor(foregroundColor)
            .overlay(
                Circle()
                    .stroke(lineWidth: 1)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
    }
}

struct SegmentedControllerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.secondarySystemGroupedBackground
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
