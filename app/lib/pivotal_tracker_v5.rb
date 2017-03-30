require 'net/https'
require 'uri'
require 'json'

class PivotalTrackerV5

  attr_accessor :api_token, :base_api_url

  def initialize(api_token)
    raise StandardError, 'API Token Must Be Supplied' if api_token.blank?
    @api_token = api_token
    @base_api_url = 'https://www.pivotaltracker.com/services/v5'
  end

  def get_projects
    https_request(:get, "#{@base_api_url}/projects")
  end

  def get_epics(project_id)
    https_request(:get, "#{@base_api_url}/projects/#{project_id}/epics")
  end

  def get_iterations(project_id, scope='current_backlog', limit=3)
    # Scope: done, current, backlog, current_backlog
    https_request(:get, "#{@base_api_url}/projects/#{project_id}/iterations?scope=#{scope}&limit=#{limit}")
  end

  def get_stories(project_id, query_options={})
    # Accepted Query Options:
    # :with_label, :with_state, :accepted_before, :accepted_after,
    # :created_before, :created_after, :updated_before, :updated_after,
    # :limit, :offset, :filter
    https_request(:get, "#{@base_api_url}/projects/#{project_id}/stories#{query_string_for(query_options)}")
  end

  def get_story(project_id, story_id)
    https_request(:get, "#{@base_api_url}/projects/#{project_id}/stories/#{story_id}")
  end

  def get_current_user
    https_request(:get, "#{@base_api_url}/me")
  end

  def get_notifications
    https_request(:get, "#{@base_api_url}/my/notifications")
  end

  def patch_story(project_id, story_id, params)
    if params[:owner_ids]
      params['owner_ids[]'.to_sym] = params[:owner_ids].map(&:to_i)
      params.delete(:owner_ids)
    end
    https_request(:put, "#{@base_api_url}/projects/#{project_id}/stories/#{story_id}", params)
  end


  private


  def https_request(method, url, params={})
    # Parse URL
    uri = URI.parse(url)

    # Configure HTTPS
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Build Request, Set Pivotal API Token Header
    case method
    when :get
      request = Net::HTTP::Get.new(uri.request_uri)
    when :put
      request = Net::HTTP::Put.new(uri.request_uri)
      request.set_form_data(params)
    end
    request["X-TrackerToken"] = @api_token

    # Perform Request
    response = http.request(request)
    raise if response.code.to_i != 200

    # Return JSON
    parsed_json = JSON.parse(response.body, symbolize_names: true)
  end

  def query_string_for(query_options)
    return '' if query_options.empty?
    URI.encode_www_form(query_options)
  end

end
