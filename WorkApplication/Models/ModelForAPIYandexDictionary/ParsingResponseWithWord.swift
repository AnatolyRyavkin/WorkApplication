//
//  ParsingResponseWithWord.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 30.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
import RealmSwift


// structure of the api Yandex.Dictionary response
/*



{
 "head":{},
 "def":[
        {"text":"time",
         "pos":"noun",
         "ts":"taɪm",
         "tr":
              [
                {"text":"время",
                 "pos":"noun",
                 "gen":"ср",
                 "syn":
                            [
                             {"text":"раз",
                              "pos":"noun",
                              "gen":"м"},
                             {"text":"момент",
                              "pos":"noun",
                              "gen":"м"},
                             {"text":"срок",
                              "pos":"noun",
                              "gen":"м"},
                             {"text":"пора",
                              "pos":"noun",
                              "gen":"ж"},
                             {"text":"период",
                              "pos":"noun",
                              "gen":"м"},
                             {"text":"момент времени",
                              "pos":"noun"}
                            ],
                  "mean":
                            [
                             {"text":"period"},
                             {"text":"once"},
                             {"text":"moment"},
                             {"text":"now"}
                            ],
                   "ex":
                            [
                             {"text":"daylight saving time",
                                "tr":
                                     [
                                      {"text":"летнее время"}
                                     ]
                             },
                             {"text":"take some time",
                                "tr":
                                     [
                                      {"text":"занять некоторое время"}
                                     ]
                             },
                             {"text":"real time mode",
                                "tr":
                                     [
                                      {"text":"режим реального времени"}
                                     ]
                             },
                             {"text":"expected arrival time",
                                "tr":
                                     [
                                      {"text":"ожидаемое время прибытия"}
                                     ]
                             },
                             {"text":"external time source",
                                "tr":
                                     [
                                      {"text":"внешний источник времени"}
                                     ]
                             },
                             {"text":"next time",
                                "tr":
                                     [
                                      {"text":"следующий раз"}
                                     ]
                             },
                             {"text":"initial time",
                                "tr":
                                     [
                                      {"text":"начальный момент"}
                                     ]
                             },
                             {"text":"reasonable time frame",
                                "tr":
                                     [
                                      {"text":"разумный срок"}
                                     ]
                             },
                             {"text":"winter time",
                                "tr":
                                     [
                                      {"text":"зимняя пора"}
                                     ]
                             },
                             {"text":"incubation time",
                                "tr":
                                     [
                                      {"text":"инкубационный период"}
                                     ]
                             }
                            ]
                },
                {"text":"час",
                 "pos":"noun",
                 "gen":"м",
                 "mean":
                        [
                         {"text":"hour"}
                        ],
                 "ex":
                        [
                         {"text":"checkout time",
                            "tr":
                                 [
                                  {"text":"расчетный час"}
                                 ]
                         }
                        ]
                 },
                {"text":"эпоха",
                 "pos":"noun",
                 "gen":"ж",
                 "mean":
                        [
                         {"text":"era"}
                        ]
                },
                {"text":"период времени",
                 "pos":"noun",
                 "syn":
                       [
                        {"text":"промежуток времени",
                         "pos":"noun"
                        }
                       ],
                 "mean":
                       [
                        {"text":"period of time"}
                       ]
                },
                {"text":"тайм",
                 "pos":"noun",
                 "gen":"м",
                 "mean":
                        [
                         {"text":"half"}
                        ]
                },
                {"text":"продолжительность",
                 "pos":"noun",
                 "gen":"ж",
                 "mean":
                        [
                         {"text":"duration"}
                        ]
                }
              ]
        },
        {"text":"time",
         "pos":"verb",
         "ts":"taɪm",
         "tr":
              [
                {"text":"приурочивать",
                 "pos":"verb",
                 "asp":"несов",
                 "syn":
                       [
                        {"text":"приурочить",
                         "pos":"verb",
                         "asp":"сов"
                        }
                       ],
                 "mean":
                       [
                        {"text":"date"}
                       ]
                }
              ]
        },
        {"text":"time",
         "pos":"adjective",
         "ts":"taɪm",
         "tr":
              [
               {"text":"временной",
                "pos":"adjective",
                "mean":
                       [
                        {"text":"temporary"}
                       ],
                "ex":
                       [
                        {"text":"time code",
                         "tr":
                              [
                               {"text":"временной код"}
                              ]
                        }
                       ]
               }
              ]
        },
        {"text":"time",
         "pos":"adverb",
         "ts":"taɪm",
         "tr":
              [
               {"text":"своевременно",
                "pos":"adverb",
                "mean":
                       [
                        {"text":"in time"}
                       ]
               }
              ]
        }
       ]
}


Элемент                Описание

head                      Заголовок результата (не используется).
def                       Массив словарных статей. В атрибуте ts может указываться транскрипция искомого слова.
tr                        Массив переводов.
syn                       Массив синонимов.
mean                      Массив значений.
ex                        Массив примеров.

Атрибуты, используемые в элементах def, tr, syn, mean и ex

Атрибут                      Описание

text                       Текст статьи, перевода или синонима (обязательный).
num                        Число (для имен существительных). Возможные значения:

            pl - указывается для существительных во множественном числе.
            pos    Часть речи (может отсутствовать).
            gen    Род существительного для тех языков, где это актуально (может отсутствовать).

*/

//MARK- Codable


//MARK- Realm




class ModelRealmWordCodable{

    var realmWordYAPI: Realm!

    static let Shared = ModelRealmWordCodable()

    private init() {
        var url: URL! = nil
        #if DEBUG
            url = URL.init(fileURLWithPath: "Users/ryavkinto/Documents/MyApplication/WorkApplication/WorkApplication/BaseWordCodable.realm")
        #else
            url = Bundle.main.url(forResource: "BaseWordCodable", withExtension: "realm")
        #endif
        let config = Realm.Configuration.init(fileURL: url, readOnly: false)
        do{
            self.realmWordYAPI = try Realm(configuration: config)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("error = ", error)
            return
        }
        print("init ModelRealmWordCodable",self)
    }
    deinit {
        print("deinit ModelRealmWordCodable",self)
    }

    func appendWordRealmYAPI(wordCodable: WordCodableJSON) throws {
        try self.realmWordYAPI.write {
            self.realmWordYAPI.add(WordObjectRealm.init(wordCodable: wordCodable))
        }
    }

    func getArrayWordRealmYAPI() -> Array<WordObjectRealm>? {
        let arrayReault = Array<WordObjectRealm>(self.realmWordYAPI.objects(WordObjectRealm.self))
        print("count = ", arrayReault.count)
        print(arrayReault.last?.def.last?.text ?? "empty")
        return arrayReault
    }



    


        

//    func deleteDictionary(numberDictionary: Int) {
//        do{
//            try self.realmUser.write {
//                self.userObject.listDictionary.remove(at: numberDictionary)
//                self.behaviorSubject.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
//            }
//        }catch{
//            print("remove dictionary failed")
//        }
//    }
//
//    func changeNameDictionary(dictionaryObject: DictionaryObject, newName: String) throws{
//        do{
//            try self.realmUser.write {
//                dictionaryObject.name = newName
//                self.behaviorSubject.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
//            }
//        }catch{
//            print("remove dictionary failed")
//        }
//
//    }
//
//    func getDictionariesForUserWithInsertFirstEmpty()-> Array<DictionaryObject>{
//        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObject.self)
//        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
//        var result: Array<DictionaryObject> = Array<DictionaryObject>(resultDictionaries.filter(predicate))
//        result.insert(DictionaryObject.init(name: "-", typeDictionary: "-"), at: 0) // filling first line
//        return result
//    }
//
//    func getDictionariesForUser()-> Array<DictionaryObject>{
//        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObject.self)
//        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
//        let result: Array<DictionaryObject> = Array<DictionaryObject>(resultDictionaries.filter(predicate))
//        return result
//    }
//
//    func getLastDictionaryForUser() -> DictionaryObject? {
//        return (self.modelRealmUser.realmUser.objects(DictionaryObject.self)).last
//    }
//
//
//
//

}








