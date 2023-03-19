from urllib.parse import urljoin
from pyproj import Geod
import asyncio, builtins, json, math, logging
import websockets, googlemaps, requests

logger = logging.getLogger('mockdriver')
logger.setLevel(logging.DEBUG)

UPDATE_FREQUENCY = 2
SETTINGS_FILENAME = 'settings.json'

class Config(object):

    def __init__(self, filename):
        with open(filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        self.google_maps_key = data['GOOGLE_MAPS_KEY']
        self.buscatcher_endpoint = data['BUSCATCHER_ENDPOINT']
        self.realtime_endpoint = data['REALTIME_ENDPOINT']
        self.websocket_token = data['WEBSOCKET_TOKEN']

def format_latitude(stop):
    lat = stop['latitude']
    lng = stop['longitude']

    return f'{lat},{lng}'

class Bus(object):

    def __init__(self, bus_id, stops):
        self.bus_id = bus_id
        self.stops = stops
    
    def compute_route(self):
        first_stop = self.stops[0]
        last_stop = self.stops[-1]
        intermediate_stops = self.stops[1:-1]
        directions = main.maps.directions(
            origin=format_latitude(first_stop),
            destination=format_latitude(last_stop),
            mode='driving',
            waypoints=[format_latitude(stop) for stop in intermediate_stops],
            alternatives=False
        )
        route = directions[0]

        legs = route['legs']

        self.legs = []
        self.points = []

        for leg in legs:
            start_location = leg['start_location']
            end_location = leg['end_location']
            distance = self.compute_distance_leg(start_location, end_location)
            speed = 0.03 # km/h
            duration = distance / speed
            updates = int(math.ceil(duration / UPDATE_FREQUENCY))
            extra_points = geoid.npts(start_location['lng'], start_location['lat'], end_location['lng'], end_location['lat'], updates)

            self.legs.append([start_location, end_location, distance, duration, extra_points])
            self.points.extend(extra_points)
        
        self.points = list(dict.fromkeys(self.points))
        self.current_point = 0
        self.direction = True

    def compute_distance(self, lat1, lng1, lat2, lng2):
        """
        Taken from:
        https://stackoverflow.com/questions/19412462/getting-distance-between-two-points-based-on-latitude-longitude
        """
        R = 6373.0

        lat1 = math.radians(lat1)
        lng1 = math.radians(lng1)
        lat2 = math.radians(lat2)
        lng2 = math.radians(lng2)

        dlon = lng2 - lng2
        dlat = lat2 - lat1

        a = math.sin(dlat / 2) ** 2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2) ** 2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

        distance = R * c
        return distance

    def compute_distance_leg(self, leg1, leg2):
        return self.compute_distance(leg1['lat'], leg1['lng'], leg2['lat'], leg2['lng'])

    async def update(self, ws):
        point = self.points[self.current_point]

        if self.direction:
            self.current_point += 1

            if self.current_point == len(self.points):
                self.current_point = len(self.points) - 1
                self.direction = False
        else:
            self.current_point -= 1

            if self.current_point == -1:
                self.current_point = 0
                self.direction = True
        
        lng, lat = point
        bus_update = f'bus;{config.websocket_token};{self.bus_id};{lat};{lng}'
        await ws.send(bus_update)

class Main(object):

    def __init__(self):
        self.maps = googlemaps.Client(key=config.google_maps_key)
        self.headers = {'User-Agent': 'Mozilla/5.0'}

    def request_buses(self):
        logger.info('Requesting buses...')

        buses_endpoint = urljoin(config.buscatcher_endpoint, 'api/buses')
        buses = requests.get(buses_endpoint, headers=self.headers)
        buses = buses.json()

        self.buses = []

        for bus in buses:
            bus_id = bus['id']
            route_id = bus['route']['id']

            logger.info(f'Requesting bus {bus_id}...')

            route_link = urljoin(config.buscatcher_endpoint, f'api/routes/{route_id}')
            route = requests.get(route_link, headers=self.headers)
            route = route.json()
            stops = route['stops']

            if len(stops) < 2:
                # Not enough stops available for this.
                continue

            bus = Bus(bus_id, stops)
            bus.compute_route()
            self.buses.append(bus)

    async def update_buses(self, ws):
        while True:
            promises = [bus.update(ws) for bus in self.buses]

            try:
                await asyncio.gather(*promises)
            except websockets.exceptions.ConnectionClosedError:
                # Connection has been closed, time to quit
                break

            await asyncio.sleep(UPDATE_FREQUENCY)

    async def websocket_loop(self):
        while True:
            logger.info('Connecting to websocket...')

            async with websockets.connect(config.realtime_endpoint) as websocket:
                await self.update_buses(websocket)
            
            logger.info('Disconnected, reconnecting in a second...')
            await asyncio.sleep(1)

if __name__ == '__main__':
    builtins.config = Config(SETTINGS_FILENAME)
    builtins.geoid = Geod(ellps='WGS84')
    builtins.main = Main()
    main.request_buses()
    asyncio.run(main.websocket_loop())
