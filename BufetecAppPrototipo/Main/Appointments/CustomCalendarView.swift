//
//  CustomCalendarView.swift
//  BufetecAppPrototipo
//
//  Created by Ramiro Uziel Rodriguez Pineda on 08/10/24.
//

import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    var availability: [Date: [String]]
    @Binding var currentMonthOffset: Int
    var onDateChange: (Date) -> Void
    var onMonthChange: (Date) -> Void
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private let daysOfWeek = ["L", "M", "X", "J", "V", "S", "D"]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                    let newDate = getCurrentMonthDate()
                    selectedDate = newDate
                    onDateChange(selectedDate)
                    onMonthChange(newDate)
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text("\(getMonthAndYear())")
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    currentMonthOffset += 1
                    let newDate = getCurrentMonthDate()
                    selectedDate = newDate
                    onDateChange(selectedDate)
                    onMonthChange(newDate)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            HStack(spacing: 15) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            
            let days = createDaysForMonth(for: selectedDate)
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(days) { day in
                    VStack {
                        Text("\(calendar.component(.day, from: day.date))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isPastDate(day.date) ? Color.gray.opacity(0.5) : (calendar.isDate(selectedDate, inSameDayAs: day.date) ? Color.white : Color.black))
                            .frame(width: 32, height: 32)
                            .background(isPastDate(day.date) ? Color.clear : (calendar.isDate(selectedDate, inSameDayAs: day.date) ? Color("btBlue") : Color.clear))
                            .cornerRadius(16)
                            .onTapGesture {
                                if !isPastDate(day.date) {
                                    selectedDate = day.date
                                    onDateChange(day.date)
                                }
                            }
                        
                        if !isPastDate(day.date) {
                            if let availableTimes = availability[calendar.startOfDay(for: day.date)] {
                                Circle()
                                    .fill(getAvailabilityColor(for: availableTimes))
                                    .frame(width: 8, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getCurrentMonthDate() -> Date {
        let today = Date()
        return calendar.date(byAdding: .month, value: currentMonthOffset, to: today)!
    }
    
    private func createDaysForMonth(for date: Date) -> [CalendarDay] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        let firstDayOfMonth = calendar.component(.weekday, from: startDate)
        let leadingEmptyDays = firstDayOfMonth == 1 ? 6 : firstDayOfMonth - 2
        
        var days: [CalendarDay] = []
        
        // Add leading empty days
        for _ in 0..<leadingEmptyDays {
            days.append(CalendarDay(date: Date.distantPast, id: UUID()))
        }
        
        // Add actual days of the month
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                days.append(CalendarDay(date: date, id: UUID()))
            }
        }
        
        return days
    }
    
    private func getMonthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: getCurrentMonthDate())
    }
    
    private func getAvailabilityColor(for availableTimes: [String]) -> Color {
        switch availableTimes.count {
        case 5...:
            return .green
        case 1...4:
            return .green
        default:
            return .gray
        }
    }
    
    private func isPastDate(_ date: Date) -> Bool {
        return calendar.compare(date, to: Date(), toGranularity: .day) == .orderedAscending
    }
}
