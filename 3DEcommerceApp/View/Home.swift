//
//  Home.swift
//  3DEcommerceApp
//
//  Created by Pat on 2022/10/04.
//

import SwiftUI
import SceneKit

struct Home: View {
    
    @State var shoes = [
        ShoeModel(fileName: .init(named: "Yellow_Dunk_Nike_Low.scn"), shoeName: "Nike Dunk Low", rating: "4.0", price: "150", shoeDescription: "This offering of the Nike Dunk Low comes dressed in a classic Mint, Tan and Canary colour blocking. It features a White leather base with Black overlays and Swooshes atop a White midsole and Black rubber outsole."),
        ShoeModel(fileName:  .init(named:"Nike_Air_Jordan.scn"), shoeName: "Nike Air Jordan", rating: "4.8", price: "200", shoeDescription: "Air Jordan is a line of basketball shoes and athletic clothing produced by American corporation Nike. The first Air Jordan shoe was produced for Hall of Fame former basketball player Michael Jordan during his time with the Chicago Bulls in late 1984 and released to the public on April 1, 1985."),
        ShoeModel(fileName:  .init(named: "nike_prestp.scn"), shoeName:" Nike X Off-White"
    , rating: "4.3", price: "850", shoeDescription: "Supplied by a premier sneaker marketplace dealing with unworn, already sold out, in demand rarities. Each product is rigorously inspected by experienced experts guaranteeing authenticity. The Air Presto was one of the standout silhouettes from Virgil Abloh's The Ten collaboration with Nike in 2017. ")
    ]
    @State var scene :SCNScene? = .init(named: "Yellow_Dunk_Nike_Low.scn")
    //View Properties
    @State var isVerticalLook: Bool = true
    @State var currentSize:String = "9"
    @Namespace var animation
    @GestureState var offest: CGFloat = 0
    @State var shoeIndex = 1{
        didSet{
            CustomSceneView(scene: $shoes[shoeIndex].fileName)
                .frame(height: 350)
                .padding(.top, -50)
                .padding(.bottom, -15)
                .zIndex(-10)
        }
    }
    var body: some View {
        VStack{
            HeaderView()
            //3D Preview
            CustomSceneView(scene: $shoes[shoeIndex].fileName)
                .frame(height: 350)
                .padding(.top, -50)
                .padding(.bottom, -15)
                .zIndex(-10)
            
            CustomSeeker()
            ShoePropertiesView()
        }
        .padding()
    }
    
    //shoe Properties
    @ViewBuilder
    func ShoePropertiesView()-> some View{
        VStack{
            VStack(alignment: .leading, spacing: 12) {
                Text(shoes[shoeIndex].shoeName)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Men's Classic Shoes")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Label{
                    Text(shoes[shoeIndex].rating)
                } icon: {
                    Image(systemName: "star.fill")
                }
                .foregroundColor(Color("Gold"))
            }
            .padding(.top,30)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //Size picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Size")
                    .font(.title3.bold())
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10) {
                        let sizes = ["7","8","9","10","11","12"]
                        ForEach(sizes,id: \.self){ size in
                            Text(size)
                                .fontWeight(.semibold)
                                .foregroundColor(currentSize == size ? .black: .white)
                                .padding(.horizontal,20)
                                .padding(.vertical,15)
                                .background{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                                            .fill(.white.opacity(0.2))
                                        
                                        if currentSize == size{
                                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                                                .fill(.white)
                                                .matchedGeometryEffect(id: "TAB", in: animation)
                                            
                                        }
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut){
                                        currentSize = size
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.top, 20)
            
            //Check out button
            HStack(alignment: .top) {
                Button {
                    
                } label: {
                    VStack(spacing: 12){
                        Image("bag")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                        
                        Text("$\(shoes[shoeIndex].price)")
                            .fontWeight(.semibold)
                            .padding(.top,15)
                    }
                    .foregroundColor(.black)
                    .padding(18)
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(shoes[shoeIndex].shoeDescription)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    Button{
                        
                    } label: {
                        Text("More details")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.top,10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .padding(.top, 30)
        }
    }
    
    //Custom Slider
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
                .offset(x: offest)
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
                    .offset(y: -12)
                    .offset(x: offest)
                    .onChange(of: offest, perform: { newValue in
                        rotateObject(animate: offest == .zero)
                    })
                    .gesture(
                        DragGesture()
                            .updating($offest, body: { value, out, _ in
                                ///reducing the size of the knob assuming the total size will be 40 so reducing 40/2 -> 20
                                out = value.location.x - 20
                            })
                    )
                }
        }
        .frame(height: 20)
        .animation(.easeInOut(duration: 0.4), value: offest == .zero )
    }
    
    //MARK: - Rotating 3D object programmatically
    func rotateObject(animate: Bool = false){
        ///more like same as 3D rotation in swiftui
        ///Y will be used for horizontal rotation and vica versa for x
        if animate{
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
        }
        
        let newAngle = Float((offest * .pi) / 180)
        if isVerticalLook{
            shoes[shoeIndex].fileName?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.x = newAngle
        }else{
            shoes[shoeIndex].fileName?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.y = newAngle
        }
        if animate{
            SCNTransaction.commit()
        }
    }
    
    //Header view
    @ViewBuilder
    func HeaderView()-> some View{
        HStack{
            Button{
                if shoeIndex >= shoes.count{
                    shoeIndex = shoes.count
                }else{
                    shoeIndex += 1
                }
                                
            }label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16,weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: 42,height: 42)
                    .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 15,style: .continuous))
            }
            Button{
                if shoeIndex < 0 {
                    shoeIndex = 0
                }else{
                  shoeIndex -= 1
                }
            }label: {
                Image(systemName: "arrow.right")
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

struct ShoeModel {
    @State var fileName: SCNScene?
    var shoeName: String
    var rating: String
    var price: String
    var shoeDescription: String
}

