require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
require 'news-api'
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "f1a2aea7e88a73ac70215f2b871e02cd"

# Initialize News API
newsapi = News.new("48b7f2a840a24b23bea55b7ffd3f3f41")      

get "/" do
  # show a view that asks for the location
    view "ask"
   

end

get "/news" do
  # do everything else

  puts "This is the related news"
    results = Geocoder.search(params["location"])
    @location = params["location"]
    lat_lng = results.first.coordinates
    puts results
    @lat = lat_lng[0]
    @lng = lat_lng[1]
    puts @lat
    puts @lng

    forecast = ForecastIO.forecast(@lat,@lng).to_hash
    @current_temp = forecast["currently"]["temperature"]
    @current_summary = forecast["currently"]["summary"]

    forecast_array= forecast["daily"]["data"]
    for forecasted_weather in  forecast_array
        puts "A high temperature of #{forecasted_weather["temperatureHigh"]} and #{forecasted_weather["summary"]}"
    end 

    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=48b7f2a840a24b23bea55b7ffd3f3f41"
    news = HTTParty.get(url).parsed_response.to_hash
    @articles = news["articles"]
    #puts @news["articles"][3]

    # news is now a Hash you can pretty print (pp) and parse for your output
    view "news"
end