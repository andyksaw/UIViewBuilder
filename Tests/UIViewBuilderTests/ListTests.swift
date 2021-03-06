//
//  ListTests.swift
//  
//
//  Created by tarunon on 2020/01/02.
//

import XCTest
import UIViewBuilder

fileprivate extension HostingController {
    func visibleViews() -> [UIView] {
        (children.first as! UITableViewController).tableView.visibleCells.flatMap { $0.contentView.subviews.first?.subviews ?? [] }
    }
}

class ListTests: XCTestCase {
    func testPair() {
        struct TestComponent: Component, Equatable {
            var text0: String
            var text1: String
            var text2: String
            var text3: String
            var text4: String
            var text5: String
            var text6: String
            var text7: String
            var text8: String
            var text9: String

            var body: AnyComponent {
                AnyComponent {
                    List {
                        Label(text: text0)
                        Label(text: text1)
                        Label(text: text2)
                        Label(text: text3)
                        Label(text: text4)
                        Label(text: text5)
                        Label(text: text6)
                        Label(text: text7)
                        Label(text: text8)
                        Label(text: text9)
                    }
                }
            }
        }

        testComponent(
            fixtureType: [String].self,
            creation: {
                TestComponent(
                    text0: $0[0],
                    text1: $0[1],
                    text2: $0[2],
                    text3: $0[3],
                    text4: $0[4],
                    text5: $0[5],
                    text6: $0[6],
                    text7: $0[7],
                    text8: $0[8],
                    text9: $0[9]
                )
            },
            tests: [
                Assert(
                    fixture: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture
                        )
                }),
                Assert(
                    fixture: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture
                        )
                })
        ])
    }

    func testEither() {
        struct TestComponent: Component, Equatable {
            var condition0: Bool
            var condition1: Bool
            var condition2: Bool
            var condition3: Bool
            var condition4: Bool
            var condition5: Bool
            var condition6: Bool
            var condition7: Bool
            var condition8: Bool
            var condition9: Bool

            var body: AnyComponent {
                AnyComponent {
                    List {
                        if condition0 {
                            Label(text: "0")
                        }
                        if condition1 {
                            Label(text: "1")
                        }
                        if condition2 {
                            Label(text: "2")
                        }
                        if condition3 {
                            Label(text: "3")
                        }
                        if condition4 {
                            Label(text: "4")
                        }
                        if condition5 {
                            Label(text: "5")
                        } else {
                            Label(text: "a")
                        }
                        if condition6 {
                            Label(text: "6")
                        } else {
                            Label(text: "b")
                        }
                        if condition7 {
                            Label(text: "7")
                        } else {
                            Label(text: "c")
                        }
                        if condition8 {
                            Label(text: "8")
                        } else {
                            Label(text: "d")
                        }
                        if condition9 {
                            Label(text: "9")
                        } else {
                            Label(text: "e")
                        }
                    }
                }
            }
        }

        testComponent(
           fixtureType: [Bool].self,
           creation: {
               TestComponent(
                   condition0: $0[0],
                   condition1: $0[1],
                   condition2: $0[2],
                   condition3: $0[3],
                   condition4: $0[4],
                   condition5: $0[5],
                   condition6: $0[6],
                   condition7: $0[7],
                   condition8: $0[8],
                   condition9: $0[9]
               )
           },
           tests: [
               Assert(
                   fixture: [true, false, true, false, true, false, true, false, true, false],
                   assert: { _, vc in
                       XCTAssertEqual(
                           vc.visibleViews().map { ($0 as! UILabel).text },
                           ["0", "2", "4", "a", "6", "c", "8", "e"]
                       )
               }),
               Assert(
                   fixture: [false, true, false, true, false, true, false, true, false, true],
                   assert: { _, vc in
                       XCTAssertEqual(
                           vc.visibleViews().map { ($0 as! UILabel).text },
                           ["1", "3", "5", "b", "7", "d", "9"]
                       )
               })
       ])
    }

    func testForEach() {
        struct TestComponent: Component, Equatable {
            var array0: [String]
            var array1: [String]
            var array2: [String]

            var body: AnyComponent {
                AnyComponent {
                    List {
                        ForEach(data: array0) {
                            Label(text: $0)
                        }
                        ForEach(data: array1) {
                            Label(text: $0)
                        }
                        ForEach(data: array2) {
                            Label(text: $0)
                        }
                    }
                }
            }
        }

        testComponent(
            fixtureType: [[String]].self,
            creation: {
                TestComponent(
                    array0: $0[0],
                    array1: $0[1],
                    array2: $0[2]
                )
            },
            tests: [
                Assert(
                    fixture: [["1", "2", "3"], ["a", "b", "c"], ["!", "@", "#"]],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.flatMap { $0 }
                        )
                }),
                Assert(
                    fixture: [["1", "2", "3", "4", "5", "6", "7"], ["a", "b", "c"], []],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.flatMap { $0 }
                        )
                }),
                Assert(
                    fixture: [[], ["a", "b", "c", "d", "e", "f", "g"], ["!", "@", "#"]],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.flatMap { $0 }
                        )
                })
        ])
    }

    func testForEachMapId() {
        guard #available(iOS 13, *) else {
            return
        }
        struct TestComponent: Component, Equatable {
            struct Identified: Equatable, Identifiable {
                var id: Int
                var text: String
            }

            var array0: [Identified]

            var body: AnyComponent {
                AnyComponent {
                    List {
                        ForEach(data: array0) {
                            Label(text: $0.text)
                        }
                    }
                }
            }
        }

        var expectedNativeIds = [ObjectIdentifier]()

        testComponent(
            fixtureType: [TestComponent.Identified].self,
            creation: {
                TestComponent(
                    array0: $0
                )
            },
            tests: [
                Assert(
                    fixture: [
                        TestComponent.Identified(id: 1, text: "1"),
                        TestComponent.Identified(id: 2, text: "2"),
                        TestComponent.Identified(id: 3, text: "3")
                    ],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.map { $0.text }
                        )
                        expectedNativeIds = vc.visibleViews().map { ObjectIdentifier($0) }
                }),
                Assert(
                    fixture: [
                        TestComponent.Identified(id: 4, text: "1"),
                        TestComponent.Identified(id: 5, text: "2"),
                        TestComponent.Identified(id: 6, text: "3"),
                        TestComponent.Identified(id: 7, text: "4"),
                        TestComponent.Identified(id: 1, text: "1"),
                        TestComponent.Identified(id: 2, text: "2"),
                        TestComponent.Identified(id: 3, text: "3")
                    ],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.map { $0.text }
                        )
                        XCTAssertEqual(
                            expectedNativeIds,
                            vc.visibleViews()[4..<7].map { ObjectIdentifier($0) }
                        )
                }),
                Assert(
                    fixture: [
                        TestComponent.Identified(id: 1, text: "1"),
                        TestComponent.Identified(id: 2, text: "2"),
                        TestComponent.Identified(id: 3, text: "3")
                    ],
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.map { $0.text }
                        )

                        XCTAssertEqual(
                            expectedNativeIds,
                            vc.visibleViews().map { ObjectIdentifier($0) }
                        )
                })
        ])
    }

    func testForEachReuseInEither() {
        struct TestComponent: Component, Equatable {
            var condition0: Bool
            var array0: [String]

            var body: AnyComponent {
                AnyComponent {
                    List {
                        if condition0 {
                            ForEach(data: array0) {
                                Label(text: $0)
                            }
                        }
                    }
                }
            }
        }

        testComponent(
            fixtureType: (Bool, [String]).self,
            creation: {
                TestComponent(
                    condition0: $0.0,
                    array0: $0.1
                )
            },
            tests: [
                Assert(
                    fixture: (true, ["1", "2", "3"]),
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.1
                        )
                }),
                Assert(
                    fixture: (false, ["1", "2", "3", "4"]),
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            []
                        )
                }),
                Assert(
                    fixture: (true, ["1", "2", "3", "4", "5"]),
                    assert: { fixture, vc in
                        XCTAssertEqual(
                            vc.visibleViews().map { ($0 as! UILabel).text },
                            fixture.1
                        )
                })
        ])
    }
}

