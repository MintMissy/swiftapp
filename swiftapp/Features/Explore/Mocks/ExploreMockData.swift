import Foundation

struct ExploreMockData {
    static let hotels: [Hotel] = [
        Hotel(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Grand Poznań Hotel & Spa",
            description: "Luksusowy hotel położony w samym sercu Poznania, zaledwie kilka kroków od Starego Rynku. Oferuje nowoczesną strefę SPA, basen olimpijski oraz wykwintną restaurację serwującą dania kuchni lokalnej i międzynarodowej.",
            location: "Poznań, Stare Miasto",
            rating: 4.8,
            reviewCount: 342,
            basePrice: 350.0,
            imageName: "hotel_poznan",
            amenities: [.wifi, .pool, .spa, .gym, .parking, .breakfast, .ac],
            rooms: [
                Room(
                    id: UUID(uuidString: "11111111-1111-1111-2222-111111111111")!,
                    name: "Pokój Standard Double",
                    description: "Komfortowy pokój dwuosobowy z dużym łóżkiem małżeńskim, nowoczesną łazienką oraz widokiem na panoramę miasta.",
                    capacity: 2,
                    pricePerNight: 350.0,
                    imageName: "bed.double.fill",
                    bedType: "1x Double Bed",
                    isAvailable: true
                ),
                Room(
                    id: UUID(uuidString: "11111111-1111-1111-2222-222222222222")!,
                    name: "Apartament Prezydencki",
                    description: "Ekskluzywny apartament z salonem, prywatnym jacuzzi, aneksem kuchennym i tarasem widokowym na Stare Miasto.",
                    capacity: 4,
                    pricePerNight: 850.0,
                    imageName: "crown.fill",
                    bedType: "2x King Bed",
                    isAvailable: true
                )
            ]
        ),
        Hotel(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            name: "Boutique Hotel Kolegiacki",
            description: "Kameralny, zabytkowy hotel w cichej części Poznania. Wyjątkowe, indywidualnie zaprojektowane wnętrza łączą historyczny urok z nowoczesnymi udogodnieniami. Doskonały wybór na romantyczny weekend.",
            location: "Poznań, Plac Kolegiacki",
            rating: 4.6,
            reviewCount: 198,
            basePrice: 280.0,
            imageName: "hotel_kolegiacki",
            amenities: [.wifi, .breakfast, .parking, .petFriendly, .ac],
            rooms: [
                Room(
                    id: UUID(uuidString: "22222222-2222-2222-3333-111111111111")!,
                    name: "Pokój Retro Single",
                    description: "Stylowo urządzony pokój dla jednej osoby, wyposażony w biurko do pracy, minibar oraz szybkie łącze internetowe.",
                    capacity: 1,
                    pricePerNight: 280.0,
                    imageName: "bed.double.fill",
                    bedType: "1x Single Bed",
                    isAvailable: true
                ),
                Room(
                    id: UUID(uuidString: "22222222-2222-2222-3333-222222222222")!,
                    name: "Pokój Classic Twin",
                    description: "Przestronny pokój z dwoma osobnymi łóżkami jednoosobowymi, idealny dla przyjaciół lub współpracowników.",
                    capacity: 2,
                    pricePerNight: 390.0,
                    imageName: "bed.double.fill",
                    bedType: "2x Single Bed",
                    isAvailable: true
                )
            ]
        ),
        Hotel(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            name: "Baltic Wave Sopot Resort",
            description: "Nowoczesny kurort położony zaledwie 50 metrów od plaży w Sopocie. Posiada prywatne wyjście na plażę, zewnętrzny basen z podgrzewaną wodą oraz restaurację z tarasem widokowym na Morze Bałtyckie.",
            location: "Sopot, Nadmorska",
            rating: 4.9,
            reviewCount: 512,
            basePrice: 600.0,
            imageName: "hotel_sopot",
            amenities: [.wifi, .pool, .spa, .gym, .breakfast, .parking, .ac],
            rooms: [
                Room(
                    id: UUID(uuidString: "33333333-3333-3333-4444-111111111111")!,
                    name: "Pokój Superior z Widokiem na Morze",
                    description: "Jasny, przestronny pokój z bezpośrednim widokiem na Zatokę Gdańską, dużym balkonem i luksusowym wyposażeniem.",
                    capacity: 2,
                    pricePerNight: 600.0,
                    imageName: "bed.double.fill",
                    bedType: "1x King Bed",
                    isAvailable: true
                )
            ]
        ),
        Hotel(
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            name: "Górska Oaza Zakopane",
            description: "Tradycyjny hotel w stylu zakopiańskim, wybudowany z drewna i kamienia, położony w otoczeniu Tatrzańskiego Parku Narodowego. Doskonała baza wypadowa na szlaki turystyczne i stoki narciarskie.",
            location: "Zakopane, Krupówki",
            rating: 4.7,
            reviewCount: 276,
            basePrice: 420.0,
            imageName: "hotel_zakopane",
            amenities: [.wifi, .spa, .parking, .breakfast, .petFriendly],
            rooms: [
                Room(
                    id: UUID(uuidString: "44444444-4444-4444-5555-111111111111")!,
                    name: "Pokój Rodzinny z Kominkiem",
                    description: "Duży pokój rodzinny z łóżkiem małżeńskim oraz rozkładaną sofą. Wyposażony w klimatyczny kominek opalany drewnem.",
                    capacity: 4,
                    pricePerNight: 420.0,
                    imageName: "bed.double.fill",
                    bedType: "1x Double, 1x Sofa Bed",
                    isAvailable: true
                )
            ]
        )
    ]
}
