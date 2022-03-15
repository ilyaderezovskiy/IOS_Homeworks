//
//  CharityOrganizationViewModel.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 13.03.2022.
//

import SwiftUI

class CharityOrganizationViewModel {

    var organizations: [CharityOrganization] = [
        CharityOrganization(name: "Дом с маяком", annotation: "Хоспис для детей с тяжелыми и ограничивающими жизнь заболеваниями", url: "https://mayak.help/", img: "House"),
        
        CharityOrganization(name: "Помощь", annotation: "Сбора денег на оплату продуктов и услуг для пожилых людей", url: "https://pomosch.app/", img: "Help")
    ]
}
