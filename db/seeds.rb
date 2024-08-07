require "json"

geoFile = File.read('public/tokyo.geojson')
parsed_geojson = JSON.parse(geoFile)
wards = parsed_geojson["features"]

p "Destroying Wards"
Ward.destroy_all

wards.map do |ward_props|
  ward = ward_props["properties"]
  p "Creating #{ward["ward_en"]}"
  temp_ward = Ward.new(name:ward["ward_en"])
  temp_ward.one_ldk_avg_rent = ward["one_ldk"]
  temp_ward.two_ldk_avg_rent = ward["two_ldk"]
  temp_ward.three_ldk_avg_rent = ward["three_ldk"]
  temp_ward.safety_rating = ward["safety"]
  temp_ward.pet_percentage = ward["pet"]
  temp_ward.international_schools = ward["international_schools"]
  temp_ward.save
end
