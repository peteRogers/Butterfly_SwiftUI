

import Foundation
import RealityKit


class ARViewModel: ObservableObject {
    //creates a model and supplies its arView
    @Published private var model : ARModel = ARModel()
    
    var arView : ARView {
        model.arView
    }
    
    func raycastFunc(location: CGPoint) {
      //  model.raycastFunc(location: location)
    }
}
