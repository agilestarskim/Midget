import SwiftUI
//import WidgetController

struct SampleView: View {
    
    @State private var widgetState = WidgetState([("viewA", true),("viewB", true),("viewC", true),("viewD", true),("viewE", true),("viewF", false),("viewG", true),("viewH", false)])
        
    var body: some View {
        WidgetController($widgetState) {
            Widget("viewA") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget("viewB") {
                RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
            }
            Widget("viewC") {
                RoundedRectangle(cornerRadius: 15).fill(.yellow).frame(height: 100)
            }
            Widget("viewD") {
                RoundedRectangle(cornerRadius: 15).fill(.green).frame(height: 100)
            }
            Widget("viewE") {
                RoundedRectangle(cornerRadius: 15).fill(.cyan).frame(height: 100)
            }
            Widget("viewF") {
                RoundedRectangle(cornerRadius: 15).fill(.blue).frame(height: 100)
            }
            Widget("viewG") {
                RoundedRectangle(cornerRadius: 15).fill(.purple).frame(height: 100)
            }
            Widget("viewH") {
                RoundedRectangle(cornerRadius: 15).fill(.indigo).frame(height: 100)
            }
        }   
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
