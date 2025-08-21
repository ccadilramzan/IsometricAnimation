//
//  Home.swift
//  IsometricAnimation
//
//  Created by ADIL RAMZAN on 21/08/2025.
//

import SwiftUI

struct Home: View {
    var body: some View {
        IsometricView(depth: 30) {
            Color.red
        } bottom: {
            Color.blue
        } side: {
           Color.green
        }
        .frame(width: 180, height: 330)
    }
}

#Preview {
    Home()
}

struct IsometricView <Content: View, Bottom: View, Side: View>: View {
    var content: Content
    var bottom: Bottom
    var side: Side
    var depth: CGFloat
    
    init(depth: CGFloat, @ViewBuilder content: () -> Content,
         @ViewBuilder bottom: () -> Bottom,
         @ViewBuilder side: () -> Side) {
        
        self.depth = depth
        self.content = content()
        self.bottom = bottom()
        self.side = side()
        
    }
    
    var body: some View {
        Color.clear
        
            .overlay{
                GeometryReader {
                    let size = $0.size
                    
                    ZStack {
                        content
                        bottom
                        //Image(systemName: "CAT")
                            
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
        Text("Isometric View")
    }
    
}
