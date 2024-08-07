import SwiftUI
import PDFKit
import UIKit

struct AppHelpView: View {
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        VStack{
            Text("App Info")
                .font(.largeTitle)
                .padding()
                
            CollapsibleView(
                label: { Text("Collapsible") },
                content: {
                    HStack {
                        Text("ContentContentContentContentContentContentContentContentContent")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            )
            Button("Share app") {
                self.isSharePresented = true
            }
            .sheet(isPresented: $isSharePresented, onDismiss: {
                print("Dismiss")
            }, content: {
                let url = Bundle.main.url(forResource: "test", withExtension: "pdf")!
                var document = PDFDocument(url: url)
                let documentData = document!.dataRepresentation()
                ActivityViewController(activityItems: ["Name To Present to User", documentData], applicationActivities: nil)
            })
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}

struct CollapsibleView<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        self.label()
                            .padding(.leading)
                            .font(.title2)
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                            .padding(.trailing)
                    }
                    .padding(.bottom, 1)
                    .background(Color.white.opacity(0.01))
                }
            )
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .frame(height: 0)
                .padding(.leading)
                .padding(.trailing)
            
            VStack {
                self.content()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .offset(y: -15)
        }
    }
}

struct AppHelpView_Previews: PreviewProvider {
    static var previews: some View {
        AppHelpView()
    }
}
