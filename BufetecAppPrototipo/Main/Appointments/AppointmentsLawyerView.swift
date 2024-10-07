import SwiftUI
import Kingfisher

struct AppointmentsLawyerView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text("CITAS")
                        .font(.system(size: 28, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.accentColor)
                        .padding(.top, 40)
                        .padding(.horizontal, 30)

                    Spacer(minLength: 30)

                    VStack(spacing: 20) {
                        HStack {
                            Text("Cita próxima")
                                .font(.custom("Poppins-SemiBold", size: 17))
                                .foregroundColor(Color("btBlue"))
                            Spacer()
                        }
                        
                        NavigationLink(destination: SeeAppClientView(
                            clientName: "Juan Carlos",
                            clientCase: "#198",
                            image: "placeholderProfileImage",
                            cardDate: "Mar, 7 Feb 2024",
                            cardTime: "10:30 - 11:30",
                            lawyerName: "Jane Smith",
                            citaId: "a1",
                            motive: "Robo",
                            place: "Ave. Eugenio Garza Sada Sur 427, Alta Vista, 64840 Monterrey, N.L."
                        )) {
                            AppClientCardRecent(
                                cardName: "Juan Carlos",
                                cardCaso: "#198",
                                image: Image("placeholderProfileImage"),
                                cardDate: "Mar, 7 Feb 2024",
                                cardTime: "10:30 - 11:30",
                                motive: "Robo",
                                place: "Ave. Eugenio Garza Sada Sur 427, Alta Vista, 64840 Monterrey, N.L."
                            )
                        }

                        HStack {
                            Text("Citas programadas")
                                .font(.custom("Poppins-SemiBold", size: 17))
                                .foregroundColor(Color("btBlue"))
                            Spacer()
                        }

                        NavigationLink(destination: SeeAppClientView(
                            clientName: "Jian Carlo",
                            clientCase: "#209",
                            image: "placeholderProfileImage",
                            cardDate: "Mar, 7 Feb 2024",
                            cardTime: "10:30 - 11:30",
                            lawyerName: "Jane Smith", citaId: "a1",
                            motive: "Divorcio",
                            place: "Ave. Example Location"
                        )) {
                            AppClientCard(
                                cardName: "Jian Carlo",
                                cardCaso: "#209",
                                motive: "Divorcio",
                                cardDate: "Mar, 7 Feb 2024",
                                cardTime: "10:30 - 11:30"
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                }

                Image("btIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 20)
                    .padding(.trailing,10)
                    .foregroundStyle(Color("btBlue"))
            }
            .navigationBarHidden(true)
        }
    }
}

struct AppClientCardRecent: View {
    var cardName: String
    var cardCaso: String
    var image: Image
    var cardDate: String
    var cardTime: String
    var motive: String
    var place: String

    let padding: CGFloat = 10

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 15) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .padding(.leading, 20)

                VStack(alignment: .leading, spacing: 4) {
                   VStack {
                      Text(cardName)
                         .font(.custom("Poppins-Bold", size: 14))
                         .foregroundColor(.white)
                      
                      Text(cardCaso)
                         .font(.custom("Poppins-Regular", size: 12))
                         .foregroundColor(.white)
                   }
                    HStack {
                        Text("Motivo: ")
                            .font(.custom("Poppins-Bold", size: 12))
                            .foregroundColor(.white)
                        Text(motive)
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 2)

                    HStack {
                        Text("Ubicación: ")
                            .font(.custom("Poppins-Bold", size: 12))
                            .foregroundColor(.white)
                        Text(place)
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 20)
            }

            HStack(alignment: .center) {
                HStack(spacing: 5) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("btBlue"))
                        Text(cardDate)
                            .font(.custom("Poppins-Regular", size: 10))
                            .foregroundColor(Color("btBlue"))
                    }

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(Color("btBlue"))
                        Text(cardTime)
                            .font(.custom("Poppins-Regular", size: 10))
                            .foregroundColor(Color("btBlue"))
                    }
                }
                .padding(5)
                .padding(.vertical, 2)
                .background(Color.white)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 17)

                Text("CANCELAR")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Regular", size: 12))
                    .frame(width: 70)
                    .padding(padding)
                    .background(Color("btBlue"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
            .padding(.top, 10)
            .padding(.trailing, 15)
        }
        .padding(.vertical)
        .background(Color("btBlue"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct AppClientCard: View {
    var cardName: String
    var cardCaso: String
    var motive: String
    var cardDate: String
    var cardTime: String

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(cardName)
                    .font(.system(size: 18, weight: .bold))
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(Color("btBlue"))

                Text(cardCaso)
                    .font(.system(size: 13))
                    .foregroundColor(Color("btBlue"))
                    .font(.custom("Poppins-Bold", size: 13))

                HStack {
                    Text("Motivo:")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("btBlue"))
                    Text(motive)
                        .font(.system(size: 13))
                        .foregroundColor(Color("btBlue"))
                }
            }
            .padding(.horizontal, 10)

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                HStack {
                    Image(systemName: "calendar")
                      .foregroundColor(Color("btBlue"))
                    Text(cardDate)
                        .font(.system(size: 13))
                        .foregroundColor(Color("btBlue"))
                }

                HStack {
                    Image(systemName: "clock")
                      .foregroundColor(Color("btBlue"))
                    Text(cardTime)
                        .font(.system(size: 13))
                        .foregroundColor(Color("btBlue"))
                }
            }
            .padding(.vertical)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("btBlue"), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    AppointmentsLawyerView()
        .environment(AppearanceManager())
}
