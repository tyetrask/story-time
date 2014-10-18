class PivotalTrackerAccess
  
  attr_accessor :api_token
  
  def initialize(api_token)
    raise StandardError, 'API Token Must Be Supplied' if !api_token
    @api_token = api_token
    @base_api_url = 'https://www.pivotaltracker.com/services/v5'
  end
  
  def get_projects
    https_get_request("#{@base_api_url}/projects")
  end
  
  def get_epics(project_id)
    https_get_request("#{@base_api_url}/projects/#{project_id}/epics")
  end
  
  def get_stories(project_id, query_options={})
    # Accepted Query Options:
    # :with_label, :with_state, :accepted_before, :accepted_after,
    # :created_before, :created_after, :updated_before, :updated_after,
    # :limit, :offset, :filter
    https_get_request("#{@base_api_url}/projects/#{project_id}/stories#{generate_query_string_from_hash(query_options)}")
  end
  
  def get_story(project_id, story_id)
    https_get_request("#{@base_api_url}/projects/#{project_id}/stories/#{story_id}")
  end
  
  def get_my_notifications
    https_get_request("#{@base_api_url}/my/notifications")
  end
  
  def put_story(project_id)
    # Parameters:
    # name
    # description
    # story_type [feature, bug, chore, release]
    # current_state [accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled]
    # estimate
    # requested_by_id
    # owner_ids []
    # label_ids []
    https_post_request("#{@base_api_url}/projects/#{project_id}/stories")
  end
  
  
  private
  
  
  def https_get_request(url)
    # Parse URL
    uri = URI.parse(url)
    
    # Configure HTTPS Request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    # Build Get Request, Set Pivotal API Token in Header
    request = Net::HTTP::Get.new(uri.request_uri)
    request["X-TrackerToken"] = @api_token

    # Perform Request, Return JSON
    JSON.parse(http.request(request).body)
  end
  
  def https_post_request(url)
    # TODO: Implement POST
    return false
  end
  
  def generate_query_string_from_hash(query_options)
    return '' if query_options.empty?
    query_array = {}
    
    query_array.push("?")
    
    query_options.keys.each do |query_key|
      sub_query_string = "#{query_key}=#{query_options[query_key]}&"
      query_array.push(sub_query_string)
    end
    
    query_string = query_array.join('')
    query_string[0..-1] # Removes extra ampersand.
  end
  
end
