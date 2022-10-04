//
//  Home.swift
//  3DEcommerceApp
//
//  Created by Pat on 2022/10/04.
//

import SwiftUI
import SceneKit

struct Home: View {
    @State var scene :SCNScene? = .init(named: "Nike_Air_Jordan.scn")
    //View Properties
    @State var isVerticalLook: Bool = true
    var body: some View {
        VStack{
            HeaderView()
            //3D Preview
            CustomSceneView(scene: $scene)
                .frame(height: 350)
                .padding(.top, -50)
                .padding(.bottom, -15)
                
            CustomSeeker()
        }
        .padding()
    }
    
    
    
    //Custom Seeker
    @ViewBuilder
    func CustomSeeker()-> some View{
        GeometryReader{_ in
            Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.2),
                    .white.opacity(0.6),
                    .white,
                    .white.opacity(0.6),
                    .white.opacity(0.2),
                    .clear,
                    .clear
                ], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .overlay {
                    //Seeker View
                    HStack(spacing: 3) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.caption)
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical,10)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                    .offset(y: -5)
                }
        }
    }
    
    
    //Header view
    @ViewBuilder
    func HeaderView()-> some View{
        HStack{
            Button{}label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16,weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: 42,height: 42)
                    .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 15,style: .continuous))
            }
            Spacer()
            
            Button{
                withAnimation(.easeInOut) {
                    isVerticalLook.toggle()
                }
            }label: {
                Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                    .font(.system(size: 16,weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: 42,height: 42)
                    .rotationEffect(.init(degrees: isVerticalLook ? 0 : 90))
                    .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 15,style: .continuous))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
