//
//  GlobalConstants.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import UIKit


public let AlphaBettaAllEng  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "

public let AlphaBettaAllRus  = "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ "

public let AlphaBettaArrayEngUpper: Array<String> = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

public let AlphaBettaArrayEngLower: Array<String> = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","b","w","x","y","z"]

public let AlphaBettaArrayRusUpper: Array<String> = ["А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ы","Ь","Э","Ю","Я"]

public let AlphaBettaArrayRusLower: Array<String> = ["а","б","в","г","д","е","ё","ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ","ъ","ы","ь","э","ю","я"]

public let AlphaBettaStringEng = "abcdefghijklmnopqrstuvwxyz"

public let AlphaBettaStringRus = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"

let codeToCountry = [
"AED" : "United Arab Emirates",
"AFN" : "Afghanistan",
"ALL" : "Albania",
"AMD" : "Armenia",
"ANG" : "Netherlands Antilles",
"AOA" : "Angola",
"ARS" : "Argentina",
"AUD" : "Australia, Australian Antarctic Territory, Christmas Island, Cocos (Keeling) Islands, Heard and McDonald Islands, Kiribati, Nauru, Norfolk Island, Tuvalu",
"AWG" : "Aruba",
"AZN" : "Azerbaijan",
"BAM" : "Bosnia and Herzegovina",
"BBD" : "Barbados",
"BDT" : "Bangladesh",
"BGN" : "Bulgaria",
"BHD" : "Bahrain",
"BIF" : "Burundi",
"BMD" : "Bermuda",
"BND" : "Brunei",
"BOB" : "Bolivia",
"BOV" : "Bolivia",
"BRL" : "Brazil",
"BSD" : "Bahamas",
"BTN" : "Bhutan",
"BWP" : "Botswana",
"BYR" : "Belarus",
"BZD" : "Belize",
"CAD" : "Canada",
"CDF" : "Democratic Republic of Congo",
"CHE" : "Switzerland",
"CHF" : "Switzerland, Liechtenstein",
"CHW" : "Switzerland",
"CLF" : "Chile",
"CLP" : "Chile",
"CNY" : "Mainland China",
"COP" : "Colombia",
"COU" : "Colombia",
"CRC" : "Costa Rica",
"CUP" : "Cuba",
"CVE" : "Cape Verde",
"CYP" : "Cyprus",
"CZK" : "Czech Republic",
"DJF" : "Djibouti",
"DKK" : "Denmark, Faroe Islands, Greenland",
"DOP" : "Dominican Republic",
"DZD" : "Algeria",
"EEK" : "Estonia",
"EGP" : "Egypt",
"ERN" : "Eritrea",
"ETB" : "Ethiopia",
"EUR" : "European Union, see eurozone",
"FJD" : "Fiji",
"FKP" : "Falkland Islands",
"GBP" : "United Kingdom",
"GEL" : "Georgia",
"GHS" : "Ghana",
"GIP" : "Gibraltar",
"GMD" : "Gambia",
"GNF" : "Guinea",
"GTQ" : "Guatemala",
"GYD" : "Guyana",
"HKD" : "Hong Kong Special Administrative Region",
"HNL" : "Honduras",
"HRK" : "Croatia",
"HTG" : "Haiti",
"HUF" : "Hungary",
"IDR" : "Indonesia",
"ILS" : "Israel",
"INR" : "Bhutan, India",
"IQD" : "Iraq",
"IRR" : "Iran",
"ISK" : "Iceland",
"JMD" : "Jamaica",
"JOD" : "Jordan",
"JPY" : "Japan",
"KES" : "Kenya",
"KGS" : "Kyrgyzstan",
"KHR" : "Cambodia",
"KMF" : "Comoros",
"KPW" : "North Korea",
"KRW" : "South Korea",
"KWD" : "Kuwait",
"KYD" : "Cayman Islands",
"KZT" : "Kazakhstan",
"LAK" : "Laos",
"LBP" : "Lebanon",
"LKR" : "Sri Lanka",
"LRD" : "Liberia",
"LSL" : "Lesotho",
"LTL" : "Lithuania",
"LVL" : "Latvia",
"LYD" : "Libya",
"MAD" : "Morocco, Western Sahara",
"MDL" : "Moldova",
"MGA" : "Madagascar",
"MKD" : "Former Yugoslav Republic of Macedonia",
"MMK" : "Myanmar",
"MNT" : "Mongolia",
"MOP" : "Macau Special Administrative Region",
"MRO" : "Mauritania",
"MTL" : "Malta",
"MUR" : "Mauritius",
"MVR" : "Maldives",
"MWK" : "Malawi",
"MXN" : "Mexico",
"MXV" : "Mexico",
"MYR" : "Malaysia",
"MZN" : "Mozambique",
"NAD" : "Namibia",
"NGN" : "Nigeria",
"NIO" : "Nicaragua",
"NOK" : "Norway",
"NPR" : "Nepal",
"NZD" : "Cook Islands, New Zealand, Niue, Pitcairn, Tokelau",
"OMR" : "Oman",
"PAB" : "Panama",
"PEN" : "Peru",
"PGK" : "Papua New Guinea",
"PHP" : "Philippines",
"PKR" : "Pakistan",
"PLN" : "Poland",
"PYG" : "Paraguay",
"QAR" : "Qatar",
"RON" : "Romania",
"RSD" : "Serbia",
"RUB" : "Russia, Abkhazia, South Ossetia",
"RWF" : "Rwanda",
"SAR" : "Saudi Arabia",
"SBD" : "Solomon Islands",
"SCR" : "Seychelles",
"SDG" : "Sudan",
"SEK" : "Sweden",
"SGD" : "Singapore",
"SHP" : "Saint Helena",
"SKK" : "Slovakia",
"SLL" : "Sierra Leone",
"SOS" : "Somalia",
"SRD" : "Suriname",
"STD" : "São Tomé and Príncipe",
"SYP" : "Syria",
"SZL" : "Swaziland",
"THB" : "Thailand",
"TJS" : "Tajikistan",
"TMM" : "Turkmenistan",
"TND" : "Tunisia",
"TOP" : "Tonga",
"TRY" : "Turkey",
"TTD" : "Trinidad and Tobago",
"TWD" : "Taiwan and other islands that are under the effective control of the Republic of China (ROC)",
"TZS" : "Tanzania",
"UAH" : "Ukraine",
"UGX" : "Uganda",
"USD" : "American Samoa, British Indian Ocean Territory, Ecuador, El Salvador, Guam, Haiti, Marshall Islands, Micronesia, Northern Mariana Islands, Palau, Panama, Puerto Rico, East Timor, Turks and Caicos Islands, United States, Virgin Islands",
"USN" : "United States",
"USS" : "United States",
"UYU" : "Uruguay",
"UZS" : "Uzbekistan",
"VEB" : "Venezuela",
"VND" : "Vietnam",
"VUV" : "Vanuatu",
"WST" : "Samoa",
"XAF" : "Cameroon, Central African Republic, Congo, Chad, Equatorial Guinea, Gabon",
"XAG" : "",
"XAU" : "",
"XBA" : "",
"XBB" : "",
"XBC" : "",
"XBD" : "",
"XCD" : "Anguilla, Antigua and Barbuda, Dominica, Grenada, Montserrat, Saint Kitts and Nevis, Saint Lucia, Saint Vincent and the Grenadines",
"XDR" : "International Monetary Fund",
"XFO" : "Bank for International Settlements",
"XFU" : "International Union of Railways",
"XOF" : "Benin, Burkina Faso, Côte d'Ivoire, Guinea-Bissau, Mali, Niger, Senegal, Togo",
"XPD" : "",
"XPF" : "French Polynesia, New Caledonia, Wallis and Futuna",
"XPT" : "",
"XTS" : "",
"XXX" : "",
"YER" : "Yemen",
"ZAR" : "South Africa",
"ZMK" : "Zambia",
"ZWD" : "Zimbabwe"]




