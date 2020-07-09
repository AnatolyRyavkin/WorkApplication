//
//  WordCodableJSON.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 09.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

struct WordCodableJSON: Codable {
    let def: [DictionaryEntryCodable]?
}
struct DictionaryEntryCodable: Codable {
    let text: String?
    let pos: String?
    let ts: String?
    let tr: [TranslationCodable]?
    let gen: String?
    let num: String?
}
struct TranslationCodable: Codable {
    let text: String?
    let pos: String?
    let gen: String?
    let syn: [SynonymCodable]?
    let mean: [MeanCodable]?
    let ex: [ExampleCodable]?
    let num: String?
}
struct SynonymCodable: Codable {
    let text: String?
    let pos: String?
    let gen: String?
    let num: String?
}
struct MeanCodable: Codable {
    let text: String?
    let pos: String?
    let gen: String?
    let num: String?
}
struct ExampleCodable: Codable {
    let text: String?
    let tr: [TranslationCodable]?
}
