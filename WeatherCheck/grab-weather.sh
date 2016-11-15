#!/opt/local/bin/bash

IFS=$'\n'
SCORE=0
TODAY=`date +%Y-%m-%d`
MORNING=0
EVENING=0
CHATID=
TELEGRAMAPI=
OPENWEATHERAPI=

# Retrieve Weather Forecast data from OpenWeatherMap
WeatherData=`curl -s "http://api.openweathermap.org/data/2.5/forecast?lat=3.1773444&lon=101.6646153&appid=${OPENWEATHERAPI}"`
#WeatherData=`cat testdata.txt`

# Filter only today data using jq command
TodayWeather=`echo ${WeatherData} | jq -r ".list[] | select (.dt_txt | contains(\"${TODAY}\"))"`

# Start to loop for weather forecast at 6am, 9am, 12pm, 3pm, 6pm, 9pm

for d in `echo ${TodayWeather} | jq -r '.dt_txt'`; do

	# Get the Weather status for respective time from the forecast result.
	RAINING=`echo ${TodayWeather} | jq -r ". | select (.dt_txt | contains (\"${d}\")) | .weather[].main"`
	RAINDROP=`echo ${TodayWeather} | jq -r ". | select (.dt_txt | contains (\"${d}\")) | .weather[].description"`

	# Building simple scoring engine
	# Assume user leaving home at 915 am
	# If rain at 6am and 9am getting a score of 3. > 5 will trigger umbrella drop
	# Afternoon rain, the user may not require the bring the umbrella.
	# An evening rain will get a score of 6, meaning user require to bring umbrella to work.

	if [ $d == "2016-11-15 06:00:00" ] && [ $RAINING == "Rain" ]; then
			(( SCORE += 3 ))
			MORNING=1
	elif [ $d == "2016-11-15 09:00:00" ] && [ $RAINING == "Rain" ]; then
			(( SCORE += 3 ))
			MORNING=1
	elif [ $d == "2016-11-15 12:00:00" ] && [ $RAINING == "Rain" ]; then
			(( SCORE += 1 ))
	elif [ $d == "2016-11-15 18:00:00" ] && [ $RAINING == "Rain" ]; then
			EVENING=1
			(( SCORE += 6 ))
	fi
done

# This is for Telegram message usage
if [ ${MORNING} -eq 1 ]; then
		WHENRAIN="Morning"
fi


if [ ${MORNING} -eq 1 ] && [ ${EVENING} -eq 1 ] ; then
		WHENRAIN="Morning and Evening"
fi

# Trigger message to drop umbrella and Telegram
if [ ${SCORE} > 5 ]; then
		echo 'Send the command to trigger umbrella drop!'
		echo -e

		# Send a text to Telegram!
 		curl -s -X POST "https://api.telegram.org/bot${TEELGRAMAPI}/sendMessage" -F chat_id=${CHATID} -F text="Your umbrella is ready, it will rain in ${WHENRAIN}"

fi
