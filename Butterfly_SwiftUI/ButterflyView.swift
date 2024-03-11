//
//  ButterflyView.swift
//  Butterfly_SwiftUI
//
//  Created by pr on 07/03/2024.
//

import Foundation
import SwiftUI
import RealityKit

struct ButterflyView: View {
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    var body: some View{
       
        ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
            .onTapGesture(coordinateSpace: .global) { location in
                arViewModel.raycastFunc(location: location)
            }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif



