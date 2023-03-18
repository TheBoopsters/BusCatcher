import asyncio, builtins, json, logging, time
import websockets, jwt
import redis.asyncio as redis_async

CLIENTS = set()
SETTINGS_FILENAME = 'settings.json'

# Setup logger
data_logger = logging.getLogger('data')
data_logger.setLevel(logging.DEBUG)

file_handler = logging.FileHandler('bus.log')
file_handler.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(message)s')
file_handler.setFormatter(formatter)

data_logger.addHandler(file_handler)

class Config(object):

    def __init__(self, filename):
        with open(filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        self.secret_key = data['SECRET_KEY']
        self.port = data['WEBSOCKET_PORT']
        self.redis_location = data['REDIS_LOCATION']

async def send_all_buses(websocket):
    """
    Send all currently available buses to the client.
    """
    # Request all bus data from the Redis backend
    cursor, keys = await redis.scan(match='bus:*')
    values = await redis.mget(keys)

    for value in values:
        # Convert the binary message to a string.
        try:
            value = value.decode('utf-8')
        except:
            continue

        await websocket.send(value)

async def handler(websocket):
    # Keep track of currently connected clients
    CLIENTS.add(websocket)

    # On first connection, send bus location data to client
    await send_all_buses(websocket)

    while True:
        # Await message from client
        try:
            message = await websocket.recv()
        except websockets.exceptions.ConnectionClosedError:
            # The connection has been closed.
            break

        # Binary messages (as per websocket protocol) are not supported
        if not isinstance(message, str):
            continue

        # Choose by message type        
        data = message.split(';')
        message_type = data[0]

        # Bus message: Authenticated
        if message_type == 'bus':
            if len(data) < 5:
                # Not enough data provided.
                continue

            # Parse the message
            message_type, token, bus_id, latitude, longitude = data[:5]

            # Confirm that the user is authenticated
            try:
                user = jwt.decode(token, config.secret_key, 'HS256')
            except jwt.exceptions.DecodeError:
                logging.warning('Invalid authentication.')
                continue
            
            # Validate the data
            try:
                bus_id = int(bus_id)
                latitude_f = float(latitude)
                longitude_f = float(longitude)
            except:
                logging.warning('Invalid data given.')
                continue
            
            # Update the current bus location in Redis
            current_time = int(time.time())
            bus_key = f'bus:{bus_id}'
            bus_value = f'{message_type};{bus_id};{latitude};{longitude};{current_time}'
            await redis.set(bus_key, bus_value)

            # Second, broadcast this change to all clients
            websockets.broadcast(CLIENTS, bus_value)

            # Third, save the change into the log
            data_logger.debug(bus_value)

    # The client has disconnected, clean up
    try:
        await websocket.wait_closed()
    finally:
        CLIENTS.remove(websocket)

async def main():
    # Connect to Redis
    builtins.redis = await redis_async.from_url(config.redis_location)

    # Serve WebSockets server
    async with websockets.serve(handler, '', config.port):
        await asyncio.Future()

if __name__ == "__main__":
    builtins.config = Config(SETTINGS_FILENAME)
    asyncio.run(main())
