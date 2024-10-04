import SwiftUI

struct CasesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                summaryCards
                statisticsSection
                caseTypeChart
                clientRetentionChart
            }
            .padding()
        }
        .background(Color("btBackground"))
        .navigationTitle("Casos")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var summaryCards: some View {
        HStack(spacing: 15) {
            cardView(title: "Asesorías", count: "235", color: .orange)
            cardView(title: "Expedientes", count: "200", color: .green)
        }
    }
    
    func cardView(title: String, count: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(count)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Estadísticas")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color("btBlue"))
            
            Text("Resumen de actividad reciente")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            chartPlaceholder
        }
    }
    
    var chartPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("btBlue"))
            
            Text("Gráfico de estadísticas")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(height: 200)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var caseTypeChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Por tipo de caso")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color("btBlue"))
            
            chartPlaceholder
        }
    }
    
    var clientRetentionChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Clientes que se quedaron")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color("btBlue"))
            
            chartPlaceholder
        }
    }
}

#Preview {
    CasesView()
}
