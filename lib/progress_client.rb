class ProgressClient
  include HTTParty

  def self.client
    @client ||= self.new(CONFIG[:user], CONFIG[:pass])
  end

  if ENV.fetch("RAILS_ENV", "") == "PRODUCTION"
    base_uri "comingsoon"
  else
    base_uri "http://rocksmith.dev/api"
  end

  DEFAULT_HEADERS = {
    'Content-Type' => 'application/json',
    'Accept'       => 'application/json'
  }

  attr_accessor :user, :pass

  def initialize(user, pass)
    @user, @pass = user, pass
  end

  def get_arrangement(id)
    response = self.class.get "/arrangements/#{id}", headers: defaults_with_auth
    parsed(response)
  end

  def profile
    response = self.class.get "/profile", headers: defaults_with_auth
    parsed(response)
  end

  def show_progress(id)
    response = self.class.get "/game_progresses/#{id}", headers: defaults_with_auth
    parsed(response)[:body].split("\n").each { |line| puts line }
  end

  def post_progress(params)
    response = self.class.post "/game_progresses", body: {game_progress: params}.to_json, headers: defaults_with_auth
    parsed(response)[:id]
  end

  def post_arrangement(type:, file:)
    request_body = {arrangement: {raw_json: JSON.parse(File.read file), dlc_type: type} }
    response = self.class.post "/arrangements", body: request_body.to_json, headers: defaults_with_auth
  end

  def update_arrangement(type:, file:)
    raw_json     = JSON.parse(File.read file)
    id           = raw_json["Entries"].keys.first
    request_body = { arrangement: {raw_json: raw_json} }
    response     = self.class.put "/arrangements/#{id}", body: request_body.to_json, headers: defaults_with_auth
  end

  def get_flags
    response = self.class.get "/flags", headers: defaults_with_auth
    parsed(response)
  end

  def post_flag(arrangement_id, happened_at)
    request_body = {
      personal_flag: {happened_at: happened_at}
    }
    response = self.class.post "/arrangements/#{arrangement_id}/flags", body: request_body.to_json, headers: defaults_with_auth
    parsed(response)
  end

  def get_notes
    response = self.class.get "/notes", headers: defaults_with_auth
    parsed(response)
  end

  def post_note(arrangement_id, body)
    request_body = {
      arrangement_note: {body: body}
    }
    response = self.class.post "/arrangements/#{arrangement_id}/notes", body: request_body.to_json, headers: defaults_with_auth
    parsed(response)
  end


  def token
    @token = begin
      request_body = {user: { email: user, password: pass }}
      response     = self.class.post "/users/sign_in", body: request_body.to_json, headers: DEFAULT_HEADERS
      parsed(response)[:token]
    end
  end

private

  def defaults_with_auth
    DEFAULT_HEADERS.merge auth_hash
  end

  def auth_hash
    {"Authorization" => "Bearer #{token}"}
  end

  def parsed(response)
    json = JSON.parse(response.body)
    json.is_a?(Array) ? json.map(&:with_indifferent_access) : json.with_indifferent_access
  end
end
