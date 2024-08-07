import SwiftUI
import PDFKit

struct AppHelpView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            saveFile()
        }) {
            Text("Save File")
        }
    }
    
    func saveFile() {
        let url = Bundle.main.url(forResource: "test", withExtension: "pdf")!
        var document = PDFDocument(url: url)
        guard let documentData = document!.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: [documentData], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}

struct AppHelpView_Previews: PreviewProvider {
    static var previews: some View {
        AppHelpView()
    }
}
