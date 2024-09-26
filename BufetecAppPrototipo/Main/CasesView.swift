import SwiftUI

struct CasesView: View {
    var body: some View {
        NavigationView(){
            ScrollView(){
                VStack(){
                    Text("Casos")
                        .font(.system(size: 30, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 50)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack(){
                            Text("Asesorías")
                                .font(.system(size: 25, weight: .heavy))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, 20)
                            Text("Expedientes")
                                .font(.system(size: 25, weight: .heavy))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.black)
                        }.padding(.top, 25)
                        
                        HStack(){
                            Text("235")
                                .font(.system(size: 30, weight: .heavy))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.orange)
                                .padding(.horizontal, 43)
                            Text("200")
                                .font(.system(size: 30, weight: .heavy))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.green)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 25)
                        .background(Color.white)
                        .cornerRadius(20)
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1))
                    
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal, 25)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Image("btIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .padding(.horizontal, 20)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .padding(.bottom,30)
                    Text("Estadísticas")
                        .font(.system(size: 27, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 50)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 10)
                    
                    Text("Por tipo de caso")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 50)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 10)
                    
                    Text("Clientes que se quedaron")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 50)
                    
                    
                    
                
                }
            }
        }
    }
}

#Preview {
    CasesView()
        .environment(AppearanceManager())
}
