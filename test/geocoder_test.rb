require 'test_helper'

class GeocoderTest < Test::Unit::TestCase

  def test_fetch_coordinates
    v = Venue.new(*venue_params(:msg))
    assert_equal [40.750354, -73.993371], v.fetch_coordinates
    assert_equal [40.750354, -73.993371], [v.latitude, v.longitude]
  end

  # sanity check
  def test_distance_between
    assert_equal 69, Geocoder.distance_between(0,0, 0,1).round
  end

  # sanity check
  def test_geographic_center
    assert_equal [0.0, 0.5],
      Geocoder.geographic_center([[0,0], [0,1]])
    assert_equal [0.0, 1.0],
      Geocoder.geographic_center([[0,0], [0,1], [0,2]])
  end

  def test_search_location_returns_location_objects
    results = Geocoder.search_location("Madison Square Garden")
    assert_equal 1, results.size
    location = results.first
    assert_equal Geocoder::Location, location.class
    assert_equal [40.750354, -73.993371], location.coordinates
    assert_equal "4 Penn Plaza, New York, NY 10001, USA", location.address
  end

  def test_search_location_extracts_address_components
    location = Geocoder.search_location("MSG").first
    assert_equal "New York", location.city
    assert_equal "New York", location.state
    assert_equal "NY", location.state_code
    assert_equal "United States", location.country
    assert_equal "US", location.country_code
    assert_equal "10001", location.postal_code
  end
end
