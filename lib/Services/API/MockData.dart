class MockData {
  static const List<Map<String, dynamic>> flights = [
    {
      'id': 'mock-flight-1',
      'airline': 'EK',
      'flightNumber': '623',
      'departure': {'airport': 'LHE', 'time': '2024-12-25T03:30:00'},
      'arrival': {'airport': 'DXB', 'time': '2024-12-25T06:10:00'},
      'duration': 'PT3H40M',
      'stops': 0,
      'price': {'total': '450.00', 'currency': 'USD'},
      'numberOfBookableSeats': 9,
    },
    {
      'id': 'mock-flight-2',
      'airline': 'PK',
      'flightNumber': '757',
      'departure': {'airport': 'LHE', 'time': '2024-12-26T10:00:00'},
      'arrival': {'airport': 'LHR', 'time': '2024-12-26T14:30:00'},
      'duration': 'PT9H30M',
      'stops': 0,
      'price': {'total': '850.00', 'currency': 'USD'},
      'numberOfBookableSeats': 5,
    },
    {
      'id': 'mock-flight-3',
      'airline': 'QR',
      'flightNumber': '621',
      'departure': {'airport': 'ISB', 'time': '2024-12-27T08:15:00'},
      'arrival': {'airport': 'DOH', 'time': '2024-12-27T10:30:00'},
      'duration': 'PT3H15M',
      'stops': 1,
      'price': {'total': '520.00', 'currency': 'USD'},
      'numberOfBookableSeats': 7,
    },
    {
      'id': 'mock-flight-4',
      'airline': 'BA',
      'flightNumber': '123',
      'departure': {'airport': 'LHR', 'time': '2024-12-28T09:00:00'},
      'arrival': {'airport': 'JFK', 'time': '2024-12-28T12:00:00'},
      'duration': 'PT8H00M',
      'stops': 0,
      'price': {'total': '650.00', 'currency': 'USD'},
      'numberOfBookableSeats': 4,
    },
  ];

  static const List<Map<String, dynamic>> hotels = [
    {
      'hotelId': 'mock-hotel-1',
      'name': 'Grand Plaza Hotel',
      'rating': '4.5',
      'latitude': 33.6844,
      'longitude': 73.0479,
      'offers': [
        {
          'price': {'total': '120.00', 'currency': 'USD'},
          'room': {'type': 'DELUXE_KING'},
        },
      ],
      'amenities': ['WIFI', 'POOL', 'SPA'],
    },
    {
      'hotelId': 'mock-hotel-2',
      'name': 'Seaside Resort',
      'rating': '5.0',
      'latitude': 24.8607,
      'longitude': 67.0011,
      'offers': [
        {
          'price': {'total': '250.00', 'currency': 'USD'},
          'room': {'type': 'OCEAN_SUITE'},
        },
      ],
      'amenities': ['BEACH_ACCESS', 'GYM', 'BAR'],
    },
    {
      'hotelId': 'mock-hotel-3',
      'name': 'City Centre Inn',
      'rating': '3.8',
      'latitude': 31.5204,
      'longitude': 74.3587,
      'offers': [
        {
          'price': {'total': '80.00', 'currency': 'USD'},
          'room': {'type': 'STANDARD_TWIN'},
        },
      ],
      'amenities': ['WIFI', 'PARKING'],
    },
  ];

  static const List<Map<String, dynamic>> activities = [
    {
      'id': 'mock-activity-1',
      'name': 'City Walking Tour',
      'shortDescription': 'Explore the historic landmarks of the city.',
      'type': 'TOUR',
      'geoCode': {'latitude': 33.6844, 'longitude': 73.0479},
      'price': {'amount': '25.00', 'currencyCode': 'USD'},
      'rating': '4.8',
      'pictures': ['https://example.com/tour.jpg'],
    },
    {
      'id': 'mock-activity-2',
      'name': 'Desert Safari',
      'shortDescription': 'Experience the thrill of dune bashing.',
      'type': 'ADVENTURE',
      'geoCode': {'latitude': 25.2048, 'longitude': 55.2708},
      'price': {'amount': '150.00', 'currencyCode': 'USD'},
      'rating': '4.9',
      'pictures': ['https://example.com/safari.jpg'],
    },
    {
      'id': 'mock-activity-3',
      'name': 'Cooking Class',
      'shortDescription': 'Learn to cook local delicacies.',
      'type': 'CULTURE',
      'geoCode': {'latitude': 48.8566, 'longitude': 2.3522},
      'price': {'amount': '80.00', 'currencyCode': 'USD'},
      'rating': '4.7',
      'pictures': ['https://example.com/cooking.jpg'],
    },
  ];

  static const List<Map<String, dynamic>> locations = [
    {
      'iataCode': 'LHE',
      'name': 'Lahore',
      'address': {'cityName': 'Lahore', 'countryName': 'Pakistan'},
      'subType': 'CITY',
    },
    {
      'iataCode': 'KHI',
      'name': 'Karachi',
      'address': {'cityName': 'Karachi', 'countryName': 'Pakistan'},
      'subType': 'CITY',
    },
    {
      'iataCode': 'ISB',
      'name': 'Islamabad',
      'address': {'cityName': 'Islamabad', 'countryName': 'Pakistan'},
      'subType': 'CITY',
    },
    {
      'iataCode': 'DXB',
      'name': 'Dubai International',
      'address': {'cityName': 'Dubai', 'countryName': 'United Arab Emirates'},
      'subType': 'AIRPORT',
    },
    {
      'iataCode': 'JFK',
      'name': 'John F Kennedy Intl',
      'address': {'cityName': 'New York', 'countryName': 'United States'},
      'subType': 'AIRPORT',
    },
    {
      'iataCode': 'LHR',
      'name': 'Heathrow',
      'address': {'cityName': 'London', 'countryName': 'United Kingdom'},
      'subType': 'AIRPORT',
    },
    {
      'iataCode': 'PAR',
      'name': 'Paris',
      'address': {'cityName': 'Paris', 'countryName': 'France'},
      'subType': 'CITY',
    },
  ];
}
