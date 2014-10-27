module PivotalTracker
  class APIV5
  
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
    
    def get_iterations(project_id, scope='current_backlog', limit=3)
      # Scope: done, current, backlog, current_backlog
      https_get_request("#{@base_api_url}/projects/#{project_id}/iterations?scope=#{scope}&limit=#{limit}")
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
    
    def get_my_work(project_id)
      my_id = get_me[:id]
      my_work = []
      current_backlog_stories = get_iterations(project_id, 'current_backlog', 1)[0][:stories]
      current_backlog_stories.each do |story|
        my_work << story if story[:owner_ids] && story[:owner_ids].include?(my_id)
      end
      my_work
    end
    
    def get_me
      https_get_request("#{@base_api_url}/me")
    end
  
    def get_my_notifications
      https_get_request("#{@base_api_url}/my/notifications")
    end
  
    def patch_story(project_id, story_id, params)
      https_put_request("#{@base_api_url}/projects/#{project_id}/stories/#{story_id}", params)
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
      parsed_json = JSON.parse(http.request(request).body, symbolize_names: true)
    end
  
    def https_put_request(url, params)
      # Parse URL
      uri = URI.parse(url)
    
      # Configure HTTPS Request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
      # Build Put Request, Set Pivotal API Token in Header
      request = Net::HTTP::Put.new(uri.request_uri)
      request.set_form_data(params)
      request["X-TrackerToken"] = @api_token

      # Perform Request, Return JSON
      parsed_json = JSON.parse(http.request(request).body, symbolize_names: true)
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
end
