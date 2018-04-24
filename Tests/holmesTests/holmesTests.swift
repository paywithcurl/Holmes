import XCTest
@testable import Holmes

struct LollerRoller {
    let brand: String?
    let speed: Float
}

extension LollerRoller: Serialize, Deserialize {
    func toJSON() throws -> AnyObject {
        return [
            "brand": try brand.toJSON(),
            "speed": try speed.toJSON(),
        ] as AnyObject
    }

    static func from(json: AnyObject) throws -> LollerRoller {
        return LollerRoller(
            brand: try deserialize(from: json, key: "brand"),
            speed: try deserialize(from: json, key: "speed")
        )
    }
}

struct RollerStore {
    let address: String
    let rollers: [LollerRoller]
}

extension RollerStore: Serialize {
    func toJSON() throws -> AnyObject {
        return [
            "address": try address.toJSON(),
            "rollers": try rollers.toJSON(),
        ] as AnyObject
    }
}

class holmesTests: XCTestCase {
    func testSerialize() {
        do {
            let store = RollerStore(
                address: "41 Luke St",
                rollers: [
                    LollerRoller(brand: "Lolly", speed: 13),
                    LollerRoller(brand: nil,     speed: 37),
                ]
            )
            let random = [
                "values": [
                    [1, 2],
                    [
                        3,
                        [
                            "answer": 42,
                            "misc": [
                                "foo": "baz",
                                "qux": [1337, nil]
                            ] as Any
                        ],
                        store
                    ]
                ]
            ]
            let serialized = try random.toJSON()
            let data = try JSONSerialization.data(withJSONObject: serialized, options: .prettyPrinted)
            let s = String(data: data, encoding: .utf8)!
            print(s)
        } catch {
            print("Exception: \(error)")
        }
    }

    func testDeserialize() {
        do {
            let rollers = [
                "rollers": [
                    [
                        "brand": "new",
                        "speed": 12345678,
                    ] as AnyObject,
                    [
                        "brand": "old",
                        "speed": 4224,
                    ] as AnyObject,
                ]
            ] as AnyObject
            let x: [String: [LollerRoller]] = try deserializer()(rollers)
            print("x = \(x)")
        } catch {
            print("Exception: \(error)")
        }
    }

    static var allTests = [
        ("Serialize", testSerialize),
        ("Deserialize", testDeserialize),
    ]
}
