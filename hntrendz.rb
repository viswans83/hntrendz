require "bundler/setup"
require "json"
require "sequel"
require "sinatra"

DB = Sequel.connect("sqlite://db/hntrendz.db")

def latest_trend_ids
  DB[:posts]
    .select(:id)
    .exclude(:track_end => nil)
    .order(Sequel.desc(:track_end))
    .limit(10)
    .all.map { |p| p[:id] }
end

def fetch_post post_id
  DB[:posts].where(:id => post_id).first
end

def fetch_trend post_id
  DB[:post_trend].select(:time_stamp,:position,:points,:comments).where(:post_id => post_id.to_i).order(:time_stamp).all
end

def prepare_post post_id
  post = fetch_post post_id
  @post_id = post[:id]
  @title = post[:title]
  @url = post[:url]
  
  plot_info = fetch_trend post_id
  
  time_stamps = plot_info.map { |p| p[:time_stamp] }.map do |ts|
    ts.strftime("%I:%M %p")
  end
  points = plot_info.map { |p| p[:points] }
  comments = plot_info.map { |p| p[:comments] }
  positions = plot_info.map { |p| p[:position] }

  data_size = time_stamps.size
  step_size = data_size > 10 ? data_size / 10 : 1

  @time_stamps = []
  @points = []
  @comments = []
  @positions = []
  0.step(data_size - 1, step_size) do |i|
    @time_stamps << time_stamps[i]
    @points << points[i]
    @comments << comments[i]
    @positions << (31 - positions[i])
  end
end

get '/' do
  erb :index, :layout => false do
    erb :each_post, :layout => false  do |post_id|
      prepare_post post_id
      erb :trend
    end
  end  
end

get '/:post_id' do |post_id|
  erb :index, :layout => false do
    prepare_post post_id
    erb :trend
  end
end
