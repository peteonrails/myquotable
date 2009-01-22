require File.dirname(__FILE__) + '/test_helper.rb'
require 'rubygems'
require 'flexmock/test_unit'

class UserTest < Test::Unit::TestCase
  
  def setup
    @session = Facebooker::Session.create('apikey', 'secretkey')
    @user = Facebooker::User.new(1234, @session)
    @other_user = Facebooker::User.new(4321, @session)
    ENV['FACEBOOK_CANVAS_PATH'] ='facebook_app_name'
    ENV['FACEBOOK_API_KEY'] = '1234567'
    ENV['FACEBOOK_SECRET_KEY'] = '7654321'
    
    @user.friends = [@other_user]
  end
  
  def test_has_permission
    expect_http_posts_with_responses(has_app_permission_response_xml)
    assert @user.has_permission?("status_update")
  end
  
  def test_can_ask_user_if_he_or_she_is_friends_with_another_user
    assert(@user.friends_with?(@other_user))
  end
  
  def test_can_ask_user_if_he_or_she_is_friends_with_another_user_by_user_id
    assert(@user.friends_with?(@other_user.id))
  end

  def test_does_not_query_facebook_for_uid
    @session.expects(:post).never
    assert_equal 1234, Facebooker::User.new(1234, @session).uid
  end

  def test_uid_is_always_an_integer
    assert_equal 1234, Facebooker::User.new(:uid => "1234").uid
    assert_equal 1234, Facebooker::User.new(:id  => "1234").uid
    
    assert_equal 1234, Facebooker::User.new(:uid => "1234").id
    assert_equal 1234, Facebooker::User.new(:id  => "1234").id
    
    assert_equal 1234, Facebooker::User.new(:uid => "1234").facebook_id
    assert_equal 1234, Facebooker::User.new(:id  => "1234").facebook_id
  end
  
  def test_cast_to_friend_list_id_with_nil
    assert_nil @user.cast_to_friend_list_id(nil)
  end
  def test_cast_to_friend_list_id_with_integer
    assert_equal 14,@user.cast_to_friend_list_id(14)
  end
  def test_cast_to_friend_list_id_with_string
    @user.expects(:friend_lists).returns([Facebooker::FriendList.new(:flid=>199,:name=>"Work")])
    assert_equal 199,@user.cast_to_friend_list_id("Work")
  end
  def test_cast_to_friend_list_id_with_friend_list
    assert_equal 199,@user.cast_to_friend_list_id(Facebooker::FriendList.new(:flid=>199,:name=>"Work"))
  end
  
  def test_cast_to_friend_list_id_with_invalid_string_raises
    @user.expects(:friend_lists).returns([Facebooker::FriendList.new(:flid=>1,:name=>"Not Picked")])
    assert_nil @user.cast_to_friend_list_id("Something")
    fail("No exception raised, Expected Facebooker::Session::InvalidFriendList")
  rescue   Facebooker::Session::InvalidFriendList
    nil
  end
  
  def test_can_create_from_current_session
    Facebooker::Session.expects(:current).returns("current")
    user=Facebooker::User.new(1)
    assert_equal("current",user.session)
  end
  
  def test_can_set_mobile_fbml
    @user.expects(:set_profile_fbml).with(nil,"test",nil)
    @user.mobile_fbml="test"
  end
  def test_can_set_profile_action
    @user.expects(:set_profile_fbml).with(nil,nil,"test")
    @user.profile_action="test"
  end
  def test_can_set_profile_fbml
    @user.expects(:set_profile_fbml).with("test",nil,nil)
    @user.profile_fbml="test"
  end
  
  def test_can_set_profile_main
    @user.expects(:set_profile_fbml).with(nil,nil,nil,"test")
    @user.profile_main="test"
  end
  
  def test_can_call_set_profile_fbml
    @session.expects(:post).with('facebook.profile.setFBML', {:uid=>1234,:profile=>"profile",:profile_action=>"action",:mobile_profile=>"mobile"},false)
    @user.set_profile_fbml("profile","mobile","action")
  end
  
  def test_can_call_set_profile_fbml_with_profile_main
    @session.expects(:post).with('facebook.profile.setFBML', {:uid=>1234,:profile=>"profile",:profile_action=>"action",:mobile_profile=>"mobile", :profile_main => 'profile_main'},false)
    @user.set_profile_fbml("profile","mobile","action",'profile_main')
  end
  
  def test_can_get_profile_photos
    @user.expects(:profile_photos)
    @user.profile_photos
  end
  
  def test_can_set_cookie
    @user.expects(:set_cookie).with('name', 'value')
    @user.set_cookie('name', 'value')
  end
  
  def test_can_get_cookies
    @user.expects(:get_cookies).with('name')
    @user.get_cookies('name')
  end
  
  def test_get_profile_photos
    @user = Facebooker::User.new(548871286, @session)
    expect_http_posts_with_responses(example_profile_photos_get_xml)    
    photos = @user.profile_photos
    assert_equal "2357384227378429949", photos.first.aid
  end
  
  def test_can_send_email
    @user.expects(:send_email).with("subject", "body text")
    @user.send_email("subject", "body text")
    
    @user.expects(:send_email).with("subject", nil, "body fbml")
    @user.send_email("subject", nil, "body fbml")
  end
  
  def test_doesnt_post_to_facebook_when_assigning_status
    @session.expects(:post).never
    @user.status="my status"
  end
  def test_can_set_status_with_string
    @session.expects(:post).with('facebook.users.setStatus', :status=>"my status",:status_includes_verb=>1)
    @user.set_status("my status")
  end
  
  def test_get_events
    @user = Facebooker::User.new(9507801, @session)
    expect_http_posts_with_responses(example_events_get_xml)
    events = @user.events
    assert_equal "29511517904", events.first.eid
  end

  def test_events_caching_honors_params
    @user = Facebooker::User.new(9507801, @session)
    @session.expects(:post).returns([{:eid=>1}])
    assert_equal 1,@user.events.first.eid
    @session.expects(:post).returns([{:eid=>2}])
    assert_equal 2,@user.events(:start_time=>1.day.ago).first.eid
    @session.expects(:post).never
    assert_equal 1,@user.events.first.eid
  end
  
  
  def test_to_s
    assert_equal("1234",@user.to_s)
  end
  
  def test_equality
    assert_equal @user, @user.dup
  end
  
  def test_hash_email
    assert_equal "4228600737_c96da02bba97aedfd26136e980ae3761", Facebooker::User.hash_email("mary@example.com")
  end
  def test_hash_email_not_normalized
    assert_equal "4228600737_c96da02bba97aedfd26136e980ae3761", Facebooker::User.hash_email(" MaRy@example.com  ")
  end
  
  def test_register_with_array
    expect_http_posts_with_responses(register_response_xml)
    assert_equal ["4228600737_c96da02bba97aedfd26136e980ae3761"],Facebooker::User.register([{:email=>"mary@example.com",:account_id=>1}])
  end
  
  def test_register_with_array_raises_if_not_all_success
    expect_http_posts_with_responses(register_response_xml)
    assert_equal ["4228600737_c96da02bba97aedfd26136e980ae3761"],Facebooker::User.register([{:email=>"mary@example.com",:account_id=>1},{:email=>"mike@example.com",:account_id=>2}])
    fail "Should have raised Facebooker::Session::UserRegistrationFailed"
  rescue Facebooker::Session::UserRegistrationFailed => e
    assert_equal({:email=>"mike@example.com",:account_id=>2},e.failed_users.first)
  end
  
  def test_get_locale
    @user = Facebooker::User.new(9507801, @session)
    expect_http_posts_with_responses(example_users_get_info_xml)
    assert_equal "en_US", @user.locale
  end
  
  def test_get_profile_url
    @user = Facebooker::User.new(8055, @session)
    expect_http_posts_with_responses(example_users_get_info_xml)
    assert_equal "http://www.facebook.com/profile.php?id=8055", @user.profile_url
  end
  
  private
  def example_profile_photos_get_xml
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <photos_get_response xmlns=\"http://api.facebook.com/1.0/\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd\" list=\"true\">
       <photo>
         <pid>34585991612804</pid>
         <aid>2357384227378429949</aid>
         <owner>1240077</owner>
         <src>http://ip002.facebook.com/v11/135/18/8055/s1240077_30043524_2020.jpg</src>
         <src_big>http://ip002.facebook.com/v11/135/18/8055/n1240077_30043524_2020.jpg</src_big>
         <src_small>http://ip002.facebook.com/v11/135/18/8055/t1240077_30043524_2020.jpg</src_small>
         <link>http://www.facebook.com/photo.php?pid=30043524&id=8055</link>
         <caption>From The Deathmatch (Trailer) (1999)</caption>
         <created>1132553361</created>
       </photo>
       <photo>
         <pid>34585991612805</pid>
         <aid>2357384227378429949</aid>
         <owner>1240077</owner>
         <src>http://ip002.facebook.com/v11/135/18/8055/s1240077_30043525_2184.jpg</src>
         <src_big>http://ip002.facebook.com/v11/135/18/8055/n1240077_30043525_2184.jpg</src_big>
         <src_small>http://ip002.facebook.com/v11/135/18/8055/t1240077_30043525_2184.jpg</src_small>
         <link>http://www.facebook.com/photo.php?pid=30043525&id=8055</link>
         <caption>Mexico City, back cover of the CYHS Student Underground 1999.</caption>
         <created>1132553362</created>
       </photo>
    </photos_get_response>"
  end
  
  def example_events_get_xml
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <events_get_response xmlns=\"http://api.facebook.com/1.0/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd\" list=\"true\">
      <event>
        <eid>29511517904</eid>
        <name>PUMA SALE</name>
        <tagline/>
        <nid>0</nid>
        <pic>http://profile.ak.facebook.com/object3/370/66/s29511517904_6952.jpg</pic>
        <pic_big>http://profile.ak.facebook.com/object3/370/66/n29511517904_6952.jpg</pic_big>
        <pic_small>http://profile.ak.facebook.com/object3/370/66/t29511517904_6952.jpg</pic_small>
        <host>PUMA</host>
        <description>PUMA SALE</description>
        <event_type>Education</event_type>
        <event_subtype>Study Group</event_subtype>
        <start_time>1212166800</start_time>
        <end_time>1212364800</end_time>
        <creator>1234261165</creator>
        <update_time>1209768148</update_time>
        <location>PUMA LOT</location>
        <venue>
          <street>5 LYBERTY WAY</street>
          <city>Westford</city>
          <state>Massachusetts</state>
          <country>United States</country>
          <latitude>42.5792</latitude>
          <longitude>-71.4383</longitude>
        </venue>
      </event>
    </events_get_response>"
  end
  
  def example_users_get_info_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?> <users_getInfo_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true"> <user> <uid>8055</uid> <about_me>This field perpetuates the glorification of the ego. Also, it has a character limit.</about_me> <activities>Here: facebook, etc. There: Glee Club, a capella, teaching.</activities> <affiliations list="true"> <affiliation> <nid>50453093</nid> <name>Facebook Developers</name> <type>work</type> <status/> <year/> </affiliation> </affiliations> <birthday>November 3</birthday> <books>The Brothers K, GEB, Ken Wilber, Zen and the Art, Fitzgerald, The Emporer's New Mind, The Wonderful Story of Henry Sugar</books> <current_location> <city>Palo Alto</city> <state>CA</state> <country>United States</country> <zip>94303</zip> </current_location> <education_history list="true"> <education_info> <name>Harvard</name> <year>2003</year> <concentrations list="true"> <concentration>Applied Mathematics</concentration> <concentration>Computer Science</concentration> </concentrations> </education_info> </education_history> <first_name>Dave</first_name> <hometown_location> <city>York</city> <state>PA</state> <country>United States</country> </hometown_location> <hs_info> <hs1_name>Central York High School</hs1_name> <hs2_name/> <grad_year>1999</grad_year> <hs1_id>21846</hs1_id> <hs2_id>0</hs2_id> </hs_info> <is_app_user>1</is_app_user> <has_added_app>1</has_added_app> <interests>coffee, computers, the funny, architecture, code breaking,snowboarding, philosophy, soccer, talking to strangers</interests> <last_name>Fetterman</last_name> <locale>en_US</locale> <meeting_for list="true"> <seeking>Friendship</seeking> </meeting_for> <meeting_sex list="true"> <sex>female</sex> </meeting_sex> <movies>Tommy Boy, Billy Madison, Fight Club, Dirty Work, Meet the Parents, My Blue Heaven, Office Space </movies> <music>New Found Glory, Daft Punk, Weezer, The Crystal Method, Rage, the KLF, Green Day, Live, Coldplay, Panic at the Disco, Family Force 5</music> <name>Dave Fetterman</name> <notes_count>0</notes_count> <pic>http://photos-055.facebook.com/ip007/profile3/1271/65/s8055_39735.jpg</pic> <pic_big>http://photos-055.facebook.com/ip007/profile3/1271/65/n8055_39735.jpg</pic_big> <pic_small>http://photos-055.facebook.com/ip007/profile3/1271/65/t8055_39735.jpg</pic_small> <pic_square>http://photos-055.facebook.com/ip007/profile3/1271/65/q8055_39735.jpg</pic_square> <political>Moderate</political> <profile_update_time>1170414620</profile_update_time> <profile_url>http://www.facebook.com/profile.php?id=8055</profile_url> <quotes/> <relationship_status>In a Relationship</relationship_status> <religion/> <sex>male</sex> <significant_other_id xsi:nil="true"/> <status> <message>Fast Company, November issue, page 84</message> <time>1193075616</time> </status> <timezone>-8</timezone> <tv>cf. Bob Trahan</tv> <wall_count>121</wall_count> <work_history list="true"> <work_info> <location> <city>Palo Alto</city> <state>CA</state> <country>United States</country> </location> <company_name>Facebook</company_name> <position>Software Engineer</position> <description>Tech Lead, Facebook Platform</description> <start_date>2006-01</start_date> <end_date/> </work_info> </work_history> </user> </users_getInfo_response>
    XML
  end
  
  def register_response_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?> 
    <connect_registerUsers_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/facebook.xsd" list="true"> 
      <connect_registerUsers_response_elt>4228600737_c96da02bba97aedfd26136e980ae3761</connect_registerUsers_response_elt> 
    </connect_registerUsers_response>
    XML
  end
  
  def has_app_permission_response_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <users_hasAppPermission_response xmlns="http://api.facebook.com/1.0/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">1</users_hasAppPermission_response>
    XML
  end
end
