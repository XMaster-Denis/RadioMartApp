//
//  IconTextFieldModalView.swift
//  RadioMartApp
//
//  Created by XMaster on 06.01.2024.
//

import SwiftUI

struct IconTextFieldModalView: View {
    
    var title: LocalizedStringKey
    
    @State var inputStr: String
    @Binding var isShow: Bool
    @State var succesButton: LocalizedStringKey = "Ok"
    
    var condition: (String)->()
    
    init(_ title: LocalizedStringKey, isShow: Binding<Bool>, succesButton: LocalizedStringKey = "Ok", inputStr: String, condition: @escaping (String)->()) {
        self.title = title
        self._isShow = isShow
        self.succesButton = succesButton
        self.condition = condition
        self.inputStr = inputStr
    }
    
    
    
    var body: some View {
        ZStack {
            
            VStack{
                ValidationForm { valid in
                    Text(title)
                        .font(.callout)
                    IconTextField("", text: $inputStr) {
                        $0.textFieldStyle(.roundedBorder)
                    } modIcon: {
                        $0
                    } condition: {
                        !inputStr.isEmpty
                    }
                    .padding(.bottom)
                    
                    HStack{
                        
                        Button(action: {
                            withAnimation {
                                isShow.toggle()
                            }
                        }, label: {
                            Text("cancel:string")
                                .frame(maxWidth: 150)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Button(action: {
                            withAnimation {
                                isShow.toggle()
                            }
                            condition(inputStr)
                        }, label: {
                            Text(succesButton)
                                .frame(maxWidth: 150)
                        })
                        .buttonStyle(.borderedProminent)
                        .disabled(!valid)
                        
                    }
                }

            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 10)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.gray.opacity(0.5))
                .ignoresSafeArea()
            
        }

    }
}

