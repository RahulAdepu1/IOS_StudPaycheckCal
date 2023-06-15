//
//  EffectiveTaxCalculator.swift
//  studPaycheckCal
//
//  Created by Rahul Adepu on 4/27/23.
//

import SwiftUI

class EffectiveTaxCalculator: ObservableObject {
    
    @Published var effectiveFedTax: Double = 0.0
    @Published var effectiveStateTax: Double = 0.0
    @Published var effectiveTotalTax: Double = 0.0
    
    @Published var currentTotalGross = ""
    @Published var currentNetPay = ""
    @Published var currentTotalTax = ""
    @Published var currentState = ""
    @Published var payGroup = ""
    @Published var payDayPeriod = ""
    @Published var payYear = Year.yearList[0].year
    
    func CalculateEffectiveTax() {
        
        
//        /*
//         Things we have
//          - Total Salary
//          - Total Tax
//          - Total Net Pay
//
//         Things we need
//          - pay Year
//          - pay Day Period (Monthly, Bi-Monthly)
//          - a
//
//         Step 2 - Add and Compare
//         Total Net Pay + Total Tax = Total Groos
//
//         Step 3 - If-loop
//         If not same then ask user to confirm the numbers
//         Else perform the calculations for taxes
//
//         Step 4 - Effective Total Tax
//         To Calculate Total Effective Tax
//         Total Tax/Total Gross
//
//         Step 5 - Effective State Tax
//         we need country and w4 status to know if the user is qualified for IL standard deduction
//         Total Gross - (IL standard/12) * 0.0495
//
//         Step 6 - Effective Federal Tax
//         Annualize the salary
//
//         */
//
//        // STEP 2
//        if currentTotalGross.stringToDouble == (currentNetPay.stringToDouble + currentTotalTax.stringToDouble) {
//            print("Perfectly Equal")
//        }else {
//            print("send an alert")
//        }
//
//        // STEP 4
//        effectiveTotalTax = currentTotalTax.stringToDouble/currentTotalGross.stringToDouble
//
//        print("******************************")
//        // STEP 5
//        let stateTaxCalculator = StateTaxCalculator()
//        print("Current nationality is -------> \(nationality)")
//        print("Current w4Filled is -------> \(w4Filled)")
//        print("Current currentState is -------> \(currentState)")
//
//        let standardStateDeduction = stateTaxCalculator.calStateStandardDeduction(nationality: nationality, w4Filled: w4Filled, year: payYear.stringToDouble)
//        print("Current standardStateDeduction is -------> \(standardStateDeduction)")
//        let stateTaxRate = stateTaxCalculator.calStateTaxRate(state: currentState, year: payYear.stringToDouble)
//        print("Current stateTaxRate is -------> \(stateTaxRate)")
//
//        print("***** Effective State Tax Formula *****")
//        print("(\(currentTotalGross.stringToDouble)-(\(standardStateDeduction/12)) * (\(stateTaxRate/100))")
//        effectiveStateTax = (currentTotalGross.stringToDouble - (standardStateDeduction/12)) * (stateTaxRate/100)
//        print("Current effectiveStateTax is -------> \(effectiveStateTax)")
//
//        print("******************************")
//        //STEP 6
//        print("***** Effective Fed Tax Formula *****")
//        print("(\(currentTotalTax.stringToDouble)-(\(effectiveStateTax)/\(currentTotalGross.stringToDouble))")
//        effectiveFedTax = ((currentTotalTax.stringToDouble - effectiveStateTax)/currentTotalGross.stringToDouble)*100
//        print("Current effectiveFedTax is -------> \(effectiveFedTax)")
//
//        // Function to remove commas and periods from a string
//        func removeSpecialCharacters(from string: String) -> String {
//            return string.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
//        }
    }
}
