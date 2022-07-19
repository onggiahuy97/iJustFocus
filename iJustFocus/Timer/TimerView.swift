//
//  TimerView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var model: TimerViewModel
    
    let gradiantBackground = LinearGradient(colors: [.blue.opacity(0.75), .blue], startPoint: .top, endPoint: .bottom)
    
    var isIphone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var textSize: CGFloat {
        isIphone ? 80 : 120
    }
    
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
                .font(.system(size: textSize, weight: .bold, design: .rounded))
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
        .background(gradiantBackground)
    }
    
    func CircleButton(_ text: String, _ foregroundColor: Color = .white ,action: @escaping (() -> Void)) -> some View{
        return Button(text, action: action)
            .bold()
            .padding(20)
            .foregroundColor(foregroundColor)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
    }
}

struct SegmentedControllerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemBlue
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
