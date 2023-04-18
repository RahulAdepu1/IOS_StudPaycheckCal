//
//  MainViewModel.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/8/23.
//

import Foundation

class StudentPaycheckCalculatorVM: ObservableObject{
    @Published var selectedCountry = "Choose One"
    @Published var selectedState = "Choose One"
    @Published var selectedW4 = "Choose One"
    @Published var selectedMaritalStatus = "Choose One"
    @Published var selectedPayPeriod = "Choose One"
    @Published var selectedPayRateAmount = "Choose One"
    @Published var selectedHours = "Choose One"
    @Published var selectedSalaryType = "Choose One"
    
    @Published var navToSelfCheck2 = false
    @Published var navToSelfCheckResult = false
    
    var canNavToSelfCheck2: Bool {
        return selectedCountry != "Choose One"
        && selectedState != "Choose One"
        && selectedW4 != "Choose One"
        && selectedMaritalStatus != "Choose One"
    }
    
    var canNavToSelfCheckResult: Bool {
        return selectedPayPeriod != "Choose One"
        && selectedPayRateAmount != "Choose One"
        && selectedHours != "Choose One"
        && selectedSalaryType != "Choose One"
    }
    
    //Four things to find
    // 1. Salary Before Tax
    func SalaryBeforeTax() -> Double {
        let annualizedSalaryCalulator = AnnualizedSalaryCalculator()
        let doubleSelectedHours = Double(selectedHours) ?? 0.00
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        return annualizedSalaryCalulator.salaryBeforeTax(salaryType: selectedSalaryType, hours: doubleSelectedHours, payRateAmount: doubleSelectedPayRateAmount)
    }
    
    // 2. Federal Tax
    func FederalTax() -> Double {
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let federalTaxCalculator = FederalTaxCalculator()
        
        let doubleSelectedHours = Double(selectedHours) ?? 0.00
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        let annualizedSalary = annualizedSalaryCalculator.calAnnualizedSalary(payPeriod: selectedPayPeriod, salaryType: selectedSalaryType, hours: doubleSelectedHours, payRateAmount: doubleSelectedPayRateAmount)
        let fedStandardDeduction = federalTaxCalculator.calFedStandardDeduction(nationality: selectedCountry, w4Filled: selectedW4)
        let federalTaxableIncome = federalTaxCalculator.calFederalTaxableIncome(annualizedSalary: annualizedSalary, fedStandardDeduction: fedStandardDeduction)
        let taxBracketAmountList = annualizedSalaryCalculator.calTaxBracket(maritalStatus: selectedState)
        let annualizedFederalTax = federalTaxCalculator.calAnnualizedFederalTax(federalTaxableIncome: federalTaxableIncome, taxBracketAmountList: taxBracketAmountList)
        let federalTax = federalTaxCalculator.federalTax(annualizedFederalTax: annualizedFederalTax, salaryType: selectedSalaryType)
        
        return 0.00
    }
    
    // 3. State Tax
    func StateTax() -> Double {
        let annualizedSalaryCalculator = AnnualizedSalaryCalculator()
        let stateTaxCalculator = StateTaxCalculator()
        
        let doubleSelectedHours = Double(selectedHours) ?? 0.00
        let doubleSelectedPayRateAmount = Double(selectedPayRateAmount) ?? 0.00
        
        let annualizedSalary = annualizedSalaryCalculator.calAnnualizedSalary(payPeriod: selectedPayPeriod, salaryType: selectedSalaryType, hours: doubleSelectedHours, payRateAmount: doubleSelectedPayRateAmount)
        let stateStandardDeduction = stateTaxCalculator.calStateStandardDeduction(nationality: selectedCountry, w4Filled: selectedW4)
        let stateTaxableIncome = stateTaxCalculator.calStateTaxableIncome(annualizedSalary: annualizedSalary, stateStandardDeduction: stateStandardDeduction)
        let annualizedStateTax = stateTaxCalculator.calAnnualizedStateTax(state: selectedState, stateTaxableIncome: stateTaxableIncome)
        let stateTax = stateTaxCalculator.stateTax(annualizedFederalTax: annualizedStateTax, salaryType: selectedSalaryType)
        
        return 0.00
    }
    
    // 4. Salary After Tax
    func SalaryAfterTax() -> Double {
        let salaryAfterTax = SalaryBeforeTax() - FederalTax() - StateTax() 
        return 0.00
    }
    
}
