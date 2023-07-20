import SwiftUI

extension View {
    public func editable(onTouch: @escaping () -> Void) -> some View {
        modifier(EditableModifier(onTouch: onTouch))
    }
}

struct EditableModifier: ViewModifier {
    let onTouch: () -> Void
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading){
            content
            Image(systemName: "minus.circle.fill")
                .font(.title)
                .foregroundColor(.gray)
                .background(
                    Color.black
                        .clipShape(Circle())
                        .frame(width: 15, height: 15)
                )
                .offset(x: -10, y: -10)
                .onTapGesture {
                    onTouch()
                }
        }
    }
}
