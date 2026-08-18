import SwiftUI

// MARK: - Theme

private enum BikiTheme {
}

struct SettingScreen: View {
    @State private var uuidInput: String = "7E5B6A7A-3B1E-4DB8-97B5-4E6D57D3B1A1"
    @State private var stringInput1: String = "m1"
    @State private var intInput: Int = 2
    @State private var showInvalidUUIDAlert = false
    
    @StateObject var router: Router = .shared
    
    private enum Field: Hashable {
        case uuid, string, integer
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(alignment: .leading, spacing: 20) {
                Header()
                
                VStack(spacing: 16) {
                    labeledField(label: "Truk UUID") {
                        TextField("Masukkan UUID", text: $uuidInput)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .uuid)
                    }
                    
                    Divider()
                    
                    labeledField(label: "Kode IoT Master") {
                        TextField("Masukkan kode", text: $stringInput1)
                            .focused($focusedField, equals: .string)
                    }
                    
                    Divider()
                    
                    labeledField(label: "Jumlah IoT Slave") {
                        TextField("0", value: $intInput, format: .number)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .integer)
                    }
                }
                .padding(16)
                .background(.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .actionFooter {
                PrimaryActionButton(title: "Simpan", isLoading: false) {
                    focusedField = nil
                    if collectValues() {
                        Router.shared.push(.root)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .background(Color.veryLigthGreen.ignoresSafeArea())
            .alert("UUID tidak valid", isPresented: $showInvalidUUIDAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationDestination(for: Route.self) { route in
                RouteDestinationView(route: route)
            }
        }
    }
    
    @ViewBuilder
    private func labeledField<Content: View>(
        label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.greyText)
                .tracking(0.5)
            
            content()
                .font(.system(size: 16))
        }
    }
    
    private func collectValues() -> Bool {
        guard let uuid = UUID(uuidString: uuidInput) else {
            showInvalidUUIDAlert = true
            return false
        }
        
        Secrets.masterCode = stringInput1
        Secrets.myTruckId = uuid
        Secrets.slaveCount = intInput
        
        return true
    }
}

#Preview {
    SettingScreen()
}
