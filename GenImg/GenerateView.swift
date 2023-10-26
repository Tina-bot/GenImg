import SwiftUI

struct GenerateView: View {
    @StateObject var viewModel = ViewModel()
    @State var text = "A cute sea otter, digital art"
    var body: some View {
        VStack{
            Form{
                AsyncImage(url: viewModel.imageURL){image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder:{
                    VStack{
                        if !viewModel.isLoading{
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                        }
                        else{
                            ProgressView()
                                .padding(.bottom, 12)
                            Text("Loading, please wait")
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                .frame(width: 300, height: 300)
            }
    
            TextField("Describe image to create",
                      text: $text,
                      axis: .vertical)
            .lineLimit(10)
            .lineSpacing(5)
            HStack{
                Spacer()
                Button("Create Image"){
                    Task{
                       await viewModel.generateImage(withText: text)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .disabled(viewModel.isLoading)
                .padding(.vertical)
                Spacer()
            }
          }
        }
    }
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateView()
    }
}
