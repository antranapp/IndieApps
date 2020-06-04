//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct SnackbarModifier: ViewModifier {
    
    struct SnackbarData {
        var title: String
        var detail: String
        var type: SnackbarType
        
        mutating func makeInfo(title: String, detail: String) {
            self.title = title
            self.detail = detail
            self.type = .info
        }
        
        mutating func makeWarning(title: String, detail: String) {
            self.title = title
            self.detail = detail
            self.type = .warning
        }
        
        mutating func makeSuccess(title: String, detail: String) {
            self.title = title
            self.detail = detail
            self.type = .success
        }
        
        mutating func makeError(title: String, detail: String) {
            self.title = title
            self.detail = detail
            self.type = .error
        }
    }
    
    enum SnackbarType {
        case info
        case warning
        case success
        case error
        
        var tintColor: Color {
            switch self {
                case .info:
                    return Color(red: 67/255, green: 154/255, blue: 215/255)
                case .success:
                    return Color.green
                case .warning:
                    return Color.yellow
                case .error:
                    return Color.red
            }
        }
    }
    
    @Binding var data: SnackbarData
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data.type.tintColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .shadow(radius: 3)
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
            }
        }
    }
}

extension View {
    func snackbar(data: Binding<SnackbarModifier.SnackbarData>, show: Binding<Bool>) -> some View {
        self.modifier(SnackbarModifier(data: data, show: show))
    }
}

#if DEBUG
struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
        }
    }
}
#endif
