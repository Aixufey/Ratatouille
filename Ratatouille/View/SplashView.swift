//
//  SplashView.swift
//  Ratatouille
//
//  Created by Jack Xia on 04/12/2023.
//

import SwiftUI


struct SplashView: View {
    @State private var degree: CGFloat = 0
    @State private var start: CGFloat = -500
    @State private var moustacheScale: CGFloat = 0.1
    @State private var moustacheOpacity: CGFloat = 0
    var body: some View {
        ZStack {
            Image(ImageAsset.ChefHat.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(-20))
                .frame(width: 120, height: 120)
                .offset(x: -5, y: start)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            start = -100
                        }
                    }
                }
            Image(ImageAsset.Remy.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .rotation3DEffect(
                    .degrees(degree),
                    axis: (x: 0, y: 0, z: 1)
                )
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        degree = 360
                    }
                }
            Image(ImageAsset.Moustache.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .offset(x: 65, y: -55)
                .opacity(moustacheOpacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(Animation.spring().speed(2)) {
                            moustacheOpacity = 1
                        }
                    }
                }
            
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
