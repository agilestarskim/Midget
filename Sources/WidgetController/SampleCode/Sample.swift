import SwiftUI
//import WidgetController

struct SampleView: View {
    
    @State private var widgetStateList = WidgetState([("viewA", true),("viewB", true),("viewC", true),("viewD", true),("viewE", true),("viewF", true),("viewG", true),("viewH", true)])
        
    var body: some View {
        WidgetController(widgetState: $widgetStateList) {
            Widget(identifier: "viewA") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewB") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewC") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewD") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewE") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewF") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewG") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewH") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
        }   
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
