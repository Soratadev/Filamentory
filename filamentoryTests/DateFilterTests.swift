//
//  DateFilterTests.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 01/08/2026.
//
import Testing
import Foundation
@testable import filamentory

struct DateFilterTests {

    @Test func allMatchesAnyDate() {
        #expect(DateFilter.all.matches(.distantPast))
    }

    @Test func lastWeekMatchesRecentDate() {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        #expect(DateFilter.lastWeek.matches(twoDaysAgo))
    }

    @Test func lastWeekDoesNotMatchOldDate() {
        let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: .now)!
        #expect(!DateFilter.lastWeek.matches(twoMonthsAgo))
    }
}
