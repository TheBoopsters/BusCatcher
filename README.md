# Bus Catcher - Catch me if you can!

Welcome to Bus Catcher, the ultimate solution for real-time bus tracking in Targu Mures!

With Bus Catcher, you can easily see the location of all buses in the city, in real-time.

Whether you're commuting to work or traveling to new destinations, Bus Catcher can help you catch your bus on time and avoid unnecessary delays.

# Key features

* Real-time bus tracking
* Live bus locations and estimated arrival times
* Interactive maps showing bus routes and stops
* User-friendly interface and intuitive design

# Key components

* `mobileapp` - The cross-platform mobile application, written in Flutter.
* `backend` - A Django web server, communicating with a MariaDB database and keeping track of all infrequently changed data.
* `mockdriver` - A realtime test application, generating mock data for the demo scenario. As it is not possible to provide much real life data at this moment, creating mock data is essential.
* `realtime` - A realtime websocket server providing Open Data realtime bus information.
