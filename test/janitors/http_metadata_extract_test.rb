require 'test_helper'

require File::join(LT.environment.janitor_path,'http_metadata_extract.rb')

class HttpMetadataExtractTest < LT::Test::DBTestBase

  def test_metadata_grab_youtube
    video = Video.new
    video.service_id = 'youtube'
    video.url = 'https://www.youtube.com/watch?v=9bZkp7q19f0' # Test with YouTube's most viewed video
    video.external_id = '9bZkp7q19f0'
    video.save

    assert_equal 'https://www.youtube.com/watch?v=9bZkp7q19f0', video.url

    Analytics::Janitors::HttpMetadataExtractor.fill_youtube_info

    processed_video = Video.find_by(url: 'https://www.youtube.com/watch?v=9bZkp7q19f0')
    assert processed_video
    assert_equal "00:04:13", processed_video.video_length
    assert_equal 'PSY - GANGNAM STYLE (강남스타일) M/V', processed_video.title
    assert processed_video.description.size > 10
    assert_equal 'officialpsy', processed_video.publisher
    assert_equal 'Music', processed_video.category
    assert processed_video.rating > 4.0, 'Rating must be higher than 4.0'
    assert processed_video.raters > 200000, 'Raters must be higher than 200000'
    assert_equal DateTime.parse('2012-07-15T07:46:32.000Z'), processed_video.published_on
    assert processed_video.updated_on, 'Updated_on date should not be null'
  end

end
