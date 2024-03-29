require 'open-uri'
require "httparty"

class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(params[:id])
    @air_quality_data = get_air_quality_data(@ward.latitude, @ward.longitude)
    @weather_data = get_weather_data(@ward.latitude, @ward.longitude)
    @weather_main = @weather_data["weather"][0]["main"]
    @weather_description = @weather_data["weather"][0]["description"]
    @weather_humidity = @weather_data["main"]["humidity"]
    @weather_temperature = @weather_data["main"]["temp"]
    @weather_wind = @weather_data["wind"]["speed"]
    @weather_image = get_weather_image(@weather_main)
    @air_quality_description = get_air_quality_description(@air_quality_data["list"][0]["main"]["aqi"])
    @point_of_interest_image1 = get_point_of_interest_image1
    @point_of_interest_image2 = get_point_of_interest_image2
    @point_of_interest_image3 = get_point_of_interest_image3
    @ward_banner = get_ward_banner
    # Cant change area to singular or it breaks the whole map_show_controller
    @areas = {
      name: @ward.name,
      id: @ward.id,
      code: @ward.ward_code,
      one_ldk: @ward.one_ldk_avg_rent,
      two_ldk: @ward.two_ldk_avg_rent,
      three_ldk: @ward.three_ldk_avg_rent,
      latitude: @ward.latitude,
      longitude: @ward.longitude
    }
    @review = Review.new
    @message = Message.new
    scraper
  end

  private

  def get_air_quality_data(latitude, longitude)
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{@ward.latitude}&lon=#{@ward.longitude}&appid=d0a9c6891581954c7fe9d124e4c405a2")
    if response.success?
      @air_quality_data = response.parsed_response
    else
      @air_quality_data = nil
    end
  end

  def get_weather_data(latitude, longitude)
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{@ward.latitude}&lon=#{@ward.longitude}&units=metric&appid=d0a9c6891581954c7fe9d124e4c405a2")
    if response.success?
      @weather_data = response.parsed_response
    else
      @weather_data = nil
    end
  end

  def get_weather_image(weather)
    case @weather_main
    when "Clouds"
      "cloudy.png"
    when "Clear"
      "sunny.png"
    when "Rain"
      "rainy.png"
    when "Drizzle"
      "rainy.png"
    when "Thunderstorm"
      "rainy.png"
    when "Snow"
      "snow.png"
    else
      "cloudy.png"
    end
  end

  def get_air_quality_description(aqi)
    case aqi
    when 1
      "Good"
    when 2
      "Fair"
    when 3
      "Moderate"
    when 4
      "Poor"
    when 5
      "Very poor"
    else
      "Not available"
    end
  end

  def get_point_of_interest_image1
    case @ward.name
    when "shibuya ku"
      "https://images.unsplash.com/photo-1609942225969-3f3109a13eb8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1748&q=80"
    when "koto ku"
      "https://www.gotokyo.org/en/spot/141/images/4423_1_1400x1100.jpg"
    when "shinjuku ku"
      "https://upload.wikimedia.org/wikipedia/commons/9/9d/Shinjuku_Gyoen_National_Garden_-_sakura_3.JPG"
    when "minato ku"
      "https://www.japanrailpass.com.au/wp-content/uploads/2016/09/Tokyo-Tower.jpg"
    end
  end

  def get_point_of_interest_image2
    case @ward.name
    when "shibuya ku"
      "https://s3-ap-northeast-1.amazonaws.com/thegate/2021/04/20/20/19/02/Hachiko-Statue.jpg"
    when "koto ku"
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/de/8b/6a/sky-tree-from-afar.jpg?w=1200&h=-1&s=1"
    when "shinjuku ku"
      "https://media.cntraveler.com/photos/5e6b90cb3639d3000809382d/16:9/w_2560,c_limit/GoldenGai-Tokyo-TTD-2020-TRRK68.jpg"
    when "minato ku"
      "https://res-3.cloudinary.com/jnto/image/upload/w_2064,h_1300,c_fill,f_auto,fl_lossy,q_auto/v1645756607/tokyo/M_00534_001"
    end
  end

  def get_point_of_interest_image3
    case @ward.name
    when "shibuya ku"
      "http://www.exploreshaw.com/wp-content/uploads/2016/05/IMG_9024.jpg"
    when "koto ku"
      "https://media.timeout.com/images/102579347/image.jpg"
    when "shinjuku ku"
      "https://blog.japanwondertravel.com/wp-content/uploads/2022/03/kabukicho.jpg"
    when "minato ku"
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/0f/28/8c/roppongi-hills.jpg?w=1200&h=-1&s=1"
    end
  end

  def get_ward_banner
    case @ward.name
    when "shibuya ku"
      "shibuyaflag.jpg"
    when "koto ku"
      "kotobanner.jpg"
    when "shinjuku ku"
      "shinjukubanner.jpg"
    when "minato ku"
      "minatobanner.jpg"
    end
  end

  def scraper
    rent_url = "https://www.japan-property.jp/apartment-for-rent/Tokyo?cities=#{@ward.rent_url}&property_types[]=apartment&bedrooms[]=-1&bedrooms[]=1&bedrooms[]=2&bedrooms[]=3"
    html = URI.open(rent_url)
    doc = Nokogiri::HTML.parse(html)
    items = doc.search('.item')
    @houses = []
    items.first(4).each do |listing|
      house = {}
      house[:name] = listing.search('.info h3').text.strip
      house[:price] = listing.search('.info p').text.strip
      house[:address] = listing.search('.location span').text.strip.match(/(.+Tokyo)(\w.+)/)[1]
      house[:directions] = listing.search('.location span').text.strip.match(/(.+Tokyo)(\w.+)/)[2]
      house[:image] = listing.search('.photo_label img').first[:src]
      house[:url] = listing.search('a').first['href']
      @houses << house
    end
    return @houses
  end
end
