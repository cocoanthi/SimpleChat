//
//  ContentView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import SwiftUI

struct ContentView: View {
    
    @State var name = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange
                
                VStack {
                    Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                        .padding(.top, 12)
                    
                    TextField("Name ", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    if name != "" {
                        NavigationLink(destination: MessageView(name: name)) {
                            HStack {
                                Text("Join")
                                Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            }
                            
                        }
                        .frame(width: 100, height: 54)
                        .background(Color.orange)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 27))
                        .padding(.bottom, 15)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .animation(.default, value: name != "")
    }
}

