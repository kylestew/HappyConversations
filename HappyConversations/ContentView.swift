//
//  ContentView.swift
//  HappyConversations
//
//  Created by Kyle Stewart on 11/16/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Text("This project contains the MessageService library.\nSee README for details!")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
