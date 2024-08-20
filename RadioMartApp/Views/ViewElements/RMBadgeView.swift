//
//  RMBadgeView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.07.2024.
//

import SwiftUI

struct RMBadgeView: View {
    @StateObject var item: ItemProject
    var body: some View {
        if item.count > 0 {
            ZStack{
                Circle()
                    .fill(Color.green)
                    .frame(width: 24, height: 24)
                Text("\(item.count)")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .offset(x: 0, y: -25)
            
        }
    }
}

#Preview {
    Button {
        
    } label: {
        ZStack{
            Text("+")
         //   RMBadgeView(value:  1)
            
        }
        
    }

}
