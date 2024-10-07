import SwiftUI

struct AppClientCardDetailsRecent: View {
    var cardLawyer: String
    var citaId: String
    
    var cardDate: String
    var cardTime: String

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Abogado: \(cardLawyer)")
                        .font(.headline)
                    Text("No. cita: \(citaId)")
                        .font(.subheadline)
                    Text("\(cardDate), \(cardTime)")
                        .font(.caption)
                }
                
                Spacer()

                Button(action: {
                    
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.bottom, 10)
        }
    }
}

struct SeeAppClientView: View {
    var clientName: String
    var clientCase: String
    var image: String
    var cardDate: String
    var cardTime: String
    var lawyerName: String
    var citaId: String
    var motive: String
    var place: String

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Text(clientName)
                        .font(.largeTitle)
                }
                .padding()

                Text(clientCase)
                    .font(.title2)
                    .padding(.bottom)

                AppClientCardDetailsRecent(
                    cardLawyer: lawyerName,
                    citaId: citaId,
                    cardDate: cardDate,
                    cardTime: cardTime
                )

                Text("Citas anteriores")
                    .font(.title2)
                    .padding(.top)

               
                AppClientCardDetails(
                    motive: motive,
                    place: place,
                    cardDate: cardDate,
                    cardTime: cardTime
                )
                
                
                AppClientCardDetails(
                    motive: "Previous Motive",
                    place: "Previous Place",
                    cardDate: "Jan 5, 2024",
                    cardTime: "09:00 - 10:00"
                )
            }
            .padding()
            .navigationTitle("Citas anteriores del cliente")
        }
    }
}

struct AppClientCardDetails: View {
    var motive: String
    var place: String
    var cardDate: String
    var cardTime: String

    var body: some View {
        VStack {
            Text(motive)
                .font(.headline)
            Text(place)
                .font(.subheadline)
            Text("\(cardDate), \(cardTime)")
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.bottom, 10)
    }
}

#Preview {
    SeeAppClientView(clientName: "John Doe", clientCase: "Case #123", image: "exampleImage", cardDate: "Oct 3, 2024", cardTime: "10:00 - 11:00", lawyerName: "Jane Smith", citaId: "12345", motive: "Consultation", place: "Office")
}
