//
//  LaunchScreenView.swift
//  RadioMartApp
//
//  Created by XMaster on 03.10.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @State var rotation = 0.0
    @State var delay = 3.0 //5.0
    @State var showLogo = true
    @State var opacityLogo = 1.0
    
    var body: some View {
        if showLogo {
            VStack {
                Spacer()
                AnimationLogoWebView()
                    .frame(minHeight: 600 )
                Spacer()
                HStack{
                    Text(verbatim: "Your world of radio components")
                    Text(Image(systemName: "cpu"))
                        .font(.largeTitle)
                        .rotationEffect(.degrees(rotation))
                        .animation(.easeInOut(duration: 2).delay(1), value: rotation)
                        .onAppear(perform: {
                            rotation = 360.0
                        })
                }
                .foregroundStyle(Color("baseBlue"))
                .fontWeight(.bold)
            }
            .padding()
            .background(Color.init(red: 0.3, green: 0.3, blue: 0.3))
            .zIndex(1.0)
            .opacity(opacityLogo)
            .animation(.linear(duration: 1).delay(delay-1), value: opacityLogo)
            .onAppear(perform: {
                opacityLogo = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    showLogo = false
                }
            })
        } else {
            EmptyView()
        }
        
    }
}

#Preview {
    LaunchScreenView()
}
