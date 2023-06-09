//
//  SelfCheckView2.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/7/23.
//

import SwiftUI

struct SelfCheckView2: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @State private var showPayPeriodPicker:Bool = false
    @State private var showPayRateAmountPicker:Bool = false
    @State private var showHoursPicker:Bool = false
    @State private var showSalaryTypePicker:Bool = false
    
    // Alert
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Make a choice for all the options \nto move to next page")
                .multilineTextAlignment(.center)
                .padding(10)
            VStack {
                HStack {
                    VStack {
                        Text("Pay Period")
                            .modifier(CustomTextDesign4())
                        Button {
                            showPayPeriodPicker = true
                        } label: {
                            Text(studentPaycheckCalVM.selectedPayPeriod)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .modifier(CustomBlockDesign())
                    
                    
                    VStack {
                        Text("Pay Rate Amount")
                            .modifier(CustomTextDesign4())
                        PayRateAmountTextField()
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                HStack{
                    VStack {
                        Text("Hours")
                            .modifier(CustomTextDesign4())
                        Button {
                            showHoursPicker = true
                        } label: {
                            Text("\(studentPaycheckCalVM.selectedHours)h \(studentPaycheckCalVM.selectedMinutes)m")
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    VStack {
                        Text("Salary Type")
                            .modifier(CustomTextDesign4())
                        Button {
                            showSalaryTypePicker = true
                        } label: {
                            Text(studentPaycheckCalVM.selectedSalaryType)
                                .modifier(CustomChoiceButtonDesign())
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            
            Spacer()
            NavigationLink {
                SelfCheckViewResult()
            } label: {
                Text("Next")
                    .modifier(CustomActionButtonDesign())
            }
            .disabled(!studentPaycheckCalVM.canNavToSelfCheckResult)
            .opacity(studentPaycheckCalVM.canNavToSelfCheckResult ? 1.0 : 0.5)
            Spacer()
            
        }
        .sheet(isPresented: $showPayPeriodPicker) {
            PayPeriodSelectPicker(showPayPeriodPicker: $showPayPeriodPicker)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showHoursPicker) {
            HoursSelectPicker(showHoursPicker: $showHoursPicker)
                .presentationDetents([.height(200)])
        }
        
        .sheet(isPresented: $showSalaryTypePicker) {
            SalarySelectPicker(showSalaryTypePicker: $showSalaryTypePicker)
                .presentationDetents([.height(200)])
        }    
    }
}

// Show Alert like in OnboardingView()'
//MARK: - Picker Views
struct PayPeriodSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @Binding var showPayPeriodPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showPayPeriodPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $studentPaycheckCalVM.selectedPayPeriod) {
                ForEach(PayPeriod.payPeriodList){ payPeriod in
                    Text(payPeriod.payPeriod).tag(payPeriod.payPeriod)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct PayRateAmountTextField: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM

    var body: some View {
        let filteredValue = Binding<String>(
            get: { self.studentPaycheckCalVM.selectedPayRateAmount },
            set: {
                let filtered = $0.filter { "0123456789.".contains($0) }
                if filtered == "." || filtered.components(separatedBy: ".").count <= 2 {
                    self.studentPaycheckCalVM.selectedPayRateAmount = filtered
                }
            }
        )
        
        TextField("$0.00", text: filteredValue)
            .keyboardType(.decimalPad)
            .foregroundColor(.black)
            .font(.subheadline)
            .frame(width: 120, height: 50)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .multilineTextAlignment(.center)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    Spacer()
                }
            }
    }
}

struct HoursSelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    let hoursList = Array(stride(from: 0, through: 60, by: 1))
    let minutesList = Array(0 ..< 60)
    @Binding var showHoursPicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showHoursPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            HStack(spacing: 0) {
                Picker("", selection: $studentPaycheckCalVM.selectedHours) {
                    ForEach(hoursList, id:\.self){ hour in
                        Text("\(hour)").tag("\(hour)")
                    }
                }
                .frame(width: 75)
                .clipped()
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                Text("h")
                
                // For minutes
                Picker("", selection: $studentPaycheckCalVM.selectedMinutes) {
                    ForEach(minutesList, id:\.self){ minutes in
                        Text("\(minutes)").tag("\(minutes)")
                    }
                }
                .frame(width: 75)
                .clipped()
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                Text("m")
            }
        }
    }
}

struct SalarySelectPicker: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    @Binding var showSalaryTypePicker: Bool
    
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Spacer()
                Button {
                    showSalaryTypePicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.3))
            
            Picker("", selection: $studentPaycheckCalVM.selectedSalaryType) {
                ForEach(SalaryType.salaryTypeList){ salaryType in
                    Text(salaryType.salaryType).tag(salaryType.salaryType)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

//MARK: - Preview
struct SelfCheckView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SelfCheckView2()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
    }
}
