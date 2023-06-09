//
//  IncomeCalculatorView.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/24/23.
//

import SwiftUI

struct IncomeCalculatorView: View {
    @EnvironmentObject var studentPaycheckCalVM: StudentPaycheckCalculatorVM
    
    @State var annualSalary: String = ""
    @State var selectedAnnualSalary: Double = 0.0
    @State var selectedMaritalStatus: String = "Choose One"
    @State var selectedState: String = "Choose One"
    
    @State var marginalFedTaxRate: Double = 0.0
    @State var effectiveFedTaxRate: Double = 0.0
    @State var fedTaxAmount: Double = 0.0
    @State var marginalStateTaxRate: Double = 0.0
    @State var effectiveStateTaxRate: Double = 0.0
    @State var stateTaxAmount: Double = 0.0
    @State var effectiveTotalTaxRate: Double = 0.0
    @State var totalTaxAmount: Double = 0.0
    @State var incomeAfterTax: Double = 0.0
    @State var currentDate = Date()
    
    // Standard Deduction Bool
    @State var standardDeductionFederal: Bool = false
    @State var standardDeductionState: Bool = false
    
    @State private var showStatePicker: Bool = false
    @State private var showMaritalStatusPicker: Bool = false
    
    // App Storage
    @AppStorage("country") var selectedCountry: String?
    @AppStorage("w4Filled") var selectedW4Filled: String?
    
    var body: some View {
        
        VStack {
            Text("Income Estimator")
                .padding(.bottom, 50)
                .font(.largeTitle)
                .fontWeight(.bold)
            // User Entry Data
            Text("Estimate How much you will pay in taxes \nand earn income after taxes on your prefered Annual salary as an international student on F1 Visa")
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            HStack{
                // State
                VStack{
                    Text("State")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Button {
                        showStatePicker = true
                    } label: {
                        Text(selectedState)
                            .foregroundColor(.black)
                            .modifier(CustomTextDesign2())
                    }
                }
                
                // Annual Salary
                VStack{
                    Text("Annual Salary")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    TextField("$0.00", text: $annualSalary)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button {
                                    // Performing All Calculations
                                    selectedAnnualSalary = (Double(annualSalary) ?? 0.0)
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } label: {
                                    Text("Done")
                                        .foregroundColor(Color(.systemBlue
                                                              ))
                                }
                                
//                                Button {
//                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                } label: {
//                                    Image(systemName: "keyboard.chevron.compact.down")
//                                }
                            }
                        }
                        .foregroundColor(.black)
                        .modifier(CustomTextDesign2())
                }
                
                // Marital Status
                VStack{
                    Text("Marital Status")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Button {
                        showMaritalStatusPicker = true
                    } label: {
                        Text(selectedMaritalStatus)
                            .foregroundColor(.black)
                            .modifier(CustomTextDesign2())
                    }
                }
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            
            // View of each row
            VStack(spacing: 10){
                // Data Table
                // Column Title Row Data
                ColumnTitle()
                
                // Federal Tax Row Data
                FederalTax(marginalFedTaxRate: calFedTax()[1].doubleToString2,
                           effectiveFedTaxRate: calFedTax()[2].doubleToString2,
                           fedTaxAmount: calFedTax()[0].doubleToCurrency)
                
                // State Tax Row Data
                StateTax(marginalStateTaxRate: calStateTax()[1].doubleToString2,
                         effectiveStateTaxRate: calStateTax()[2].doubleToString2,
                         stateTaxAmount: calStateTax()[0].doubleToCurrency)
                
                // Total Tax Row Data
                TotalTax(effectiveTotalTaxRate: calTotalTax()[1].doubleToString2,
                         totalTaxAmount: calTotalTax()[0].doubleToCurrency)
            }
            .modifier(CustomBlockDesign())
            .padding(.horizontal)
            
            
            // Income After Tax Row Data
            IncomeAfterTax(incomeAfterTax: calIncomeAfterTax().doubleToCurrency)
                .modifier(CustomBlockDesign())
                .padding(.horizontal)
            
            //Monthly Income After Tax Row Data
            MonthlyIncomeAfterTax(monthlyIncomeAfterTax: calMonthlyIncomeAfterTax().doubleToCurrency)
                .modifier(CustomBlockDesign())
                .padding(.horizontal)
            
        }
        
        // Picker View for Marital Status
        .sheet(isPresented: $showMaritalStatusPicker) {
            maritalStatusSheetView()
        }
        
        .sheet(isPresented: $showStatePicker) {
            stateSheetView()
        }
    }
    
    // Sheet Views
    func maritalStatusSheetView() -> some View {
        VStack(spacing: 0) {
            HStack{
                Spacer()
                Button {
                    showMaritalStatusPicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .frame(width: UIScreen.main.bounds.width - 32)
            .background(.gray.opacity(0.3))
            
            Picker(selection: $selectedMaritalStatus, content: {
                ForEach(MaritalStatus.maritalStatusList) { item in
                    Text(item.maritalStatus).tag(item.maritalStatus)
                }
            }, label: {
                Text(selectedMaritalStatus)
            })
            .pickerStyle(WheelPickerStyle())
            .presentationDetents([.height(200)])
        }
    }
    
    func stateSheetView() -> some View {
        VStack(spacing: 0) {
            HStack{
                Spacer()
                Button {
                    showStatePicker = false
                } label: {
                    Text("Done")
                        .foregroundColor(.black)
                }
                
            }
            .padding(5)
            .frame(width: UIScreen.main.bounds.width - 32)
            .background(.gray.opacity(0.3))
            
            Picker(selection: $selectedState, content: {
                ForEach(StateNames.statesList) { state in
                    Text(state.stateName).tag(state.stateName)
                }
            }, label: {
                Text(selectedMaritalStatus)
            })
            .pickerStyle(WheelPickerStyle())
            .presentationDetents([.height(200)])
        }
    }
    
    // LOGIC
    // Federal Taxes
    func calFedTax() -> [Double] {
        let year = Calendar.current.component(.year, from: Date())
        var annualizedFederalTaxAmount = 0.0
        var marginalFederalTaxRate = 0.0
        var effectiveFederalTaxRate = 0.0
        
        let federalTaxCalculator = FederalTaxCalculator()
        
        if (selectedAnnualSalary != 0.0 && selectedState != "Choose One" && selectedMaritalStatus != "Choose One" ){
            let federalTaxOutput = federalTaxCalculator.calculateFederalTax(totalSalary: selectedAnnualSalary, year: year, selectedMaritalStatus: selectedMaritalStatus )
            annualizedFederalTaxAmount = federalTaxOutput[0]
            marginalFederalTaxRate = federalTaxOutput[1]
            effectiveFederalTaxRate = federalTaxOutput[2]
        }
        
        //[annualizedFederalTax, marginalTaxRate, effectiveTaxRate]
        return [annualizedFederalTaxAmount, marginalFederalTaxRate, effectiveFederalTaxRate]
    }
    
    // State Taxes
    func calStateTax() -> [Double] {
        let year = Calendar.current.component(.year, from: Date())
        var annualizedStateTax = 0.0
        var marginalStateTaxRate = 0.0
        var effectiveStateTaxRate = 0.0
        
        let stateTaxCalculator = StateTaxCalculator()
        
        
        if (selectedAnnualSalary != 0.0 && selectedState != "Choose One" && selectedMaritalStatus != "Choose One" ){
            let stateTaxOutput = stateTaxCalculator.calculateStateTax(totalSalary: selectedAnnualSalary, year: year, state: selectedState)
            
            annualizedStateTax = stateTaxOutput[0]
            marginalStateTaxRate = stateTaxOutput[1]
            effectiveStateTaxRate = stateTaxOutput[2]
        }
        
        return [annualizedStateTax, marginalStateTaxRate, effectiveStateTaxRate ]
    }
    
    // Total Taxes
    func calTotalTax() -> [Double] {
        var effectiveTotalTaxRate = 0.0
        var totalTax = 0.0
        
        if (selectedAnnualSalary != 0.0 && selectedState != "Choose One" && selectedMaritalStatus != "Choose One" ){
            totalTax = calFedTax()[0] + calStateTax()[0]
            effectiveTotalTaxRate = (totalTax/selectedAnnualSalary) * 100
        }
        
        return [totalTax, effectiveTotalTaxRate]
    }
    
    // Annual Income After Taxes
    func calIncomeAfterTax() -> Double{
        var incomeAfterTax = 0.0
        if (selectedAnnualSalary != 0.0 && selectedState != "Choose One" && selectedMaritalStatus != "Choose One" ){
            incomeAfterTax = selectedAnnualSalary - (calFedTax()[0] + calStateTax()[0])
        }
        
        return incomeAfterTax
    }
    
    // Annual Income After Taxes
    func calMonthlyIncomeAfterTax() -> Double{
        var monthlyIncomeAfterTax = 0.0
        if (selectedAnnualSalary != 0.0 && selectedState != "Choose One" && selectedMaritalStatus != "Choose One" ){
            monthlyIncomeAfterTax = calIncomeAfterTax()/12
        }
        
        return monthlyIncomeAfterTax
    }
}

// PREVIEW
struct IncomeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            IncomeCalculatorView()
        }
        .environmentObject(StudentPaycheckCalculatorVM())
        .environmentObject(StudentPaycheckCoreDataVM())
        .environmentObject(EffectiveTaxCalculator())
    }
}

// Table Column View Row
struct ColumnTitle:View {
    var body: some View{
        HStack{
            Text("Tax \nType")
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            Text("Marginal Tax Rate")
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            Text("Effective Tax Rate")
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
            Text("Tax \nAmount")
                .fontWeight(.bold)
                .modifier(CustomTextDesign2())
        }
    }
}

// View for Federal Tax Row
struct FederalTax: View {
    var marginalFedTaxRate: String
    var effectiveFedTaxRate: String
    var fedTaxAmount: String
    
    var body: some View{
        HStack{
            Text("Federal")
                .modifier(CustomTextDesign3())
            Text(marginalFedTaxRate+"%")
                .modifier(CustomTextDesign3())
            Text(effectiveFedTaxRate+"%")
                .modifier(CustomTextDesign3())
            Text(fedTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

// View for State Tax Row
struct StateTax: View {
    var marginalStateTaxRate: String
    var effectiveStateTaxRate: String
    var stateTaxAmount: String
    
    var body: some View{
        HStack{
            Text("State")
                .modifier(CustomTextDesign3())
            Text(marginalStateTaxRate+"%")
                .modifier(CustomTextDesign3())
            Text(effectiveStateTaxRate+"%")
                .modifier(CustomTextDesign3())
            Text(stateTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

// View for Total tax Row
struct TotalTax: View {
    var effectiveTotalTaxRate: String
    var totalTaxAmount: String
    
    var body: some View{
        HStack{
            Text("Total")
                .modifier(CustomTextDesign3())
            Text("")
                .modifier(CustomTextDesign3())
            Text(effectiveTotalTaxRate+"%")
                .modifier(CustomTextDesign3())
            Text(totalTaxAmount)
                .modifier(CustomTextDesign3())
        }
    }
}

// View for Annual Income after tax Row
struct IncomeAfterTax: View {
    var incomeAfterTax: String
    
    var body: some View{
        VStack{
            Text("Annual Income After Tax")
                .font(.title2)
                .fontWeight(.bold)
                .modifier(CustomTextDesign3())
            
            Text(incomeAfterTax)
                .font(.title3)
                .modifier(CustomTextDesign3())
        }
    }
}

// View for Monthly Income after tax Row
struct MonthlyIncomeAfterTax: View {
    var monthlyIncomeAfterTax: String
    
    var body: some View{
        VStack{
            Text("Monthly Income After Tax")
                .font(.title2)
                .fontWeight(.bold)
                .modifier(CustomTextDesign3())
            
            Text(monthlyIncomeAfterTax)
                .font(.title3)
                .modifier(CustomTextDesign3())
        }
    }
}
