//
//  Home.swift
//  IsometricAnimation
//
//  Created by ADIL RAMZAN on 21/08/2025.
//

import SwiftUI

struct Home: View {
    
    @State var animate: Bool = false
    
    @State var a: CGFloat = 0
    @State var b: CGFloat = 0
    
    var body: some View {
        VStack {
            IsometricView(depth: animate ? 35 : 0) {
         
                ImageView()
            } bottom: {
          
                ImageView()
            } side: {
     
                ImageView()
            }
            .frame(width: 180, height: 390)
            
            .modifier(CustomProjection(a: a, b: b))
            //.projectionEffect(.init(.init(a:1, b: animate ? -0.2 : 0, c: animate ? -0.3 : 0, d:1, tx:0, ty:0)))
            .rotation3DEffect(.init(degrees: animate ? 45 : 0), axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.55)
            .offset(x: animate ? 12 : 0)
            
            
            VStack(alignment: .leading, spacing: 25){
                Text("Mesh Animation")
                    .font(.title.bold())
                    
                HStack{
                   Button ("Animate") {
                       withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                           animate = true
                           a = -0.2
                           b = -0.3
                       }
                       
                    }
                   .buttonStyle(.bordered)
                   .tint(.blue)

                    Button ("Reset") {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                            animate = false
                            a = 0
                            b = 0
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        Image("i16")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 180, height: 390)
            .clipped()
    }
}

struct CustomProjection: GeometryEffect {
    var a: CGFloat
    var b: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            return AnimatablePair(a, b)
        }
        set {
            a = newValue.first
            b = newValue.second
        }
    }
    
    func effectValue(size: CGSize)->ProjectionTransform {
        return .init(.init(a: 1, b: a, c: b, d: 1 , tx: 0, ty: 0))
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
                        //bottom
                        
                        DepthView(isBottom: true, size: size)
                        DepthView(size: size)
                            
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
    }
    
    
    @ViewBuilder
    func DepthView(isBottom: Bool = false, size: CGSize) -> some View {
        ZStack {
            if isBottom{
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    .frame(height: depth, alignment: .bottom)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(a: 1, b: 0, c: 1, d: 1 , tx: 0, ty: 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }else{
                side
                    .scaleEffect(y: depth, anchor: .trailing)
                    .frame(width: depth, alignment: .trailing)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(a: 1, b: 1, c: 0, d: 1 , tx: 0, ty: 0)))
                    .offset(x: depth )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
        }
    }
    
}
