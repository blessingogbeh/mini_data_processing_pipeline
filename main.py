# Understanding of the problem section

# 2b (i)
# Correlate the bus location and weather data => I have combined them on location and sort by timestamps
# Identify delays caused by adverse weather => I have defined adverse weather as snow or rain with temperature < 0


# 2b (ii)
# Correlate van service with bus location and number of waiting passenger
# Used random to generate both average passenger count from history and waiting passenger
# Check weather conditions are met if van is required or not

# TODO:
# Load and parse json data for bus and van location and weather --Done
# Correlate bus locations with weather data --Done
# Identify conditions like "snow" or "rain" combined with freezing temperatures to flag delays. --Done
# Correlate van services with bus locations and the number of waiting passengers. --Done


import pandas as pd
import json as js
import numpy as np
from tabulate import tabulate

# Function to load data from file
def load_json_file(file_path):
    try:
        with open(file_path) as file:
            data = js.load(file)
        return pd.DataFrame(data)
    except FileNotFoundError:
        print(f"Error: File not found - {file_path}")
        return None
    except js.JSONDecodeError:
        print(f"Error: Invalid JSON syntax in {file_path}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred while loading {file_path}: {str(e)}")
        return None

# Load data
bus_location_data = load_json_file('datas/bus_location_data.json')
weather_data = load_json_file('datas/weather_update.json')
van_services_data = load_json_file('datas/van_location_data.json')

# Checking dataframe data types for merging compatibility
# print(bus_location_data.dtypes)
# print(weather_data.dtypes)

# Convert timestamp to datetime
bus_location_data['timestamp'] = pd.to_datetime(bus_location_data['timestamp'])
weather_data['timestamp'] = pd.to_datetime(weather_data['timestamp'], errors='coerce')

# Randomly generate average passengers for each stop
bus_location_data["average_passenger_count"] = np.random.randint(10, 50, size=len(bus_location_data))
# Randomly generate current passengers for each stop
bus_location_data["passengers_waiting"] = np.random.randint(10, 100, size=len(bus_location_data))


# Correlate bus locations with weather data
bus_weather_correlated_data = pd.merge_asof(bus_location_data.sort_values("timestamp"), weather_data.sort_values("timestamp"), on="timestamp", by=["lat", "lon"])
#print(bus_weather_correlated_data)


# Next we need to identify delays caused by adverse weather
# We  an use lamba and define adverse weather as snow and rain in precipitation column AND temp < 0 in temp column
# For example, we can filter for snow or rain and freezing temperatures
bus_weather_correlated_data['delay_reason'] = bus_weather_correlated_data.apply(
    lambda row: 'adverse weather' if row['precipitation'] in ['snow', 'rain'] and row['temp'] < 0 else 'normal weather',
    axis=1
)

# Randomly generate delay times (in minutes)
# using seed ensure we get same random number everytime we ran the code
np.random.seed(42)

bus_weather_correlated_data['delay_time'] = np.random.randint(0, 10, len(bus_weather_correlated_data))

#print(bus_weather_correlated_data)

# Next we need to correlate van services with bus locations and the number of waiting passengers.
# Check whether a van is needed depending on the condition

def calculate_van_needed(row):
    condition1 = row["delay_time"] > 5  # Delay time > 5 minutes
    condition2 = row["passengers_waiting"] > 0.5 * row["average_passenger_count"]  # Passengers > 50% of average
    return condition1 and condition2


bus_weather_correlated_data["van_required"] = bus_weather_correlated_data.apply(calculate_van_needed, axis=1)


print("\n=== Full Data with Van Requirements ===")
print(tabulate(bus_weather_correlated_data, headers="keys", tablefmt="pretty"))