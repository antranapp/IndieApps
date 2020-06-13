//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct SnackbarModifier: ViewModifier {
    
    struct SnackbarData: Equatable {
        var title: String?
        var detail: String
        var type: SnackbarType
        
        static func makeInfo(title: String? = nil, detail: String) -> Self {
            return SnackbarData(
                title: title,
                detail: detail,
                type: .info
            )
        }
        
        static func makeWarning(title: String? = nil, detail: String) -> Self {
            return SnackbarData(
                title: title,
                detail: detail,
                type: .warning
            )
        }
        
        static func makeSuccess(title: String? = nil, detail: String) -> Self {
            return SnackbarData(
                title: title,
                detail: detail,
                type: .success
            )
        }
        
        static func makeError(title: String? = nil, detail: String) -> Self {
            return SnackbarData(
                title: title,
                detail: detail,
                type: .error
            )
        }

        static func makeError(error: Error) -> Self {
            return makeError(title: "Error!", detail: error.localizedDescription)
        }
    }
    
    enum SnackbarType: Equatable {
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
    
    @Binding var data: SnackbarData?
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                content
                self.data.map { data in
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                data.title.map {
                                    Text($0)
                                        .bold()
                                }
                                Text(data.detail)
                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                            }
                            Spacer()
                        }
                        .foregroundColor(Color.white)
                        .padding(12)
                        .background(data.type.tintColor)
                        .cornerRadius(8)
                    }
                    .padding()
                    .frame(width: geometry.size.width - 16)
                    .shadow(radius: 3)
                    .offset(x: 0, y: -20)
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    .animation(Animation.spring())
                    .onTapGesture {
                        withAnimation {
                            self.data = nil
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.data = nil
                            }
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func snackbar(data: Binding<SnackbarModifier.SnackbarData?>) -> some View {
        self.modifier(SnackbarModifier(data: data))
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
