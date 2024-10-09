import SwiftUI

struct FAQView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("PREGUNTAS FRECUENTES")
                    .font(.custom("Poppins-Bold", size: 45))
                    .fontWeight(.bold)
                    .foregroundColor(Color("btBlue"))
                    .padding(.top, 20)
                    .padding(.trailing,50)
                
                Spacer()
                    .frame(height:20)

                Text("Aquí encontrarás las preguntas más comunes.")
                    .font(.custom("Poppins-Regular", size: 17))
                    .foregroundColor(Color("btBlue"))
                    .padding(.bottom, 10)
                    .padding(.trailing)

                Spacer()
                    .frame(height:25)
                ScrollView {
                    VStack {
                        ForEach(sampleQuestions) { question in
                            ExpandableCardView(question: question)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .navigationTitle("")
            .navigationBarItems(leading: HStack {
                NavigationLink(destination: Text("Home View")) {
                    Image(systemName: "house")
                        .resizable()
                        .padding(.leading, 20)
                        .frame(width: 55, height: 35)
                }
            }, trailing: HStack {
                NavigationLink(destination: Text("Profile View")) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .padding(.trailing, 20)
                        .frame(width: 55, height: 35)
                        
                }
            })
        }
    }
}

struct ExpandableCardView: View {
    var question: Question
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(question.text)
                    .padding(.vertical, 10)
                    .foregroundColor(isExpanded ? Color.white : Color.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(isExpanded ? .white : .blue)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
            .frame(width: 340)
            .background(isExpanded ? Color.blue : Color.white)
            .cornerRadius(10)
            
            if isExpanded {
                Text(question.details)
                    
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(isExpanded ? Color.blue : Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
        .shadow(radius: 2)
       // .animation(.easeInOut)
    }
}


struct Question: Identifiable {
    let id = UUID()
    let text: String
    let details: String
}

let sampleQuestions = [
    Question(text: "P: ¿Qué costo tiene su servicio?", details: "R: ..."),
    Question(text: "P:¿Qué costo tiene su servicio?", details: "R..."),
    Question(text: "P: ¿Qué costo tiene su servicio?", details: "R: ...")
]

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
