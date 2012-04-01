class LeadsController < ApplicationController
  include Databasedotcom::Rails::Controller
  # GET /leads
  # GET /leads.json
  def index
    @leads = Lead.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leads }
    end
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
    @lead = Lead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lead }
    end
  end

  # GET /leads/new
  # GET /leads/new.json
  def new
    @lead = Lead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lead }
    end
  end

  # GET /leads/1/edit
  def edit
    @lead = Lead.find(params[:id])
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(params[:lead])
    # require field can not be null
    @lead['OwnerId'] = '00590000000pQOL'    #ownerId here is the Id of the User you want the Lead associated with
    @lead['IsConverted'] = false
    @lead['IsUnreadByOwner'] = false
    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.json { render json: @lead, status: :created, location: @lead }
      else
        format.html { render action: "new" }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leads/1
  # PUT /leads/1.json
  def update
    @lead = Lead.find(params[:id])

    respond_to do |format|
      if @lead.update_attributes(params[:lead])
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead = Lead.find(params[:id])
    @lead.delete

    respond_to do |format|
      format.html { redirect_to leads_url }
      format.json { head :no_content }
    end
  end
  
  def dbdc_client
    unless @dbdc_client
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      config = config.has_key?(::Rails.env) ? config[::Rails.env] : config
      username = config["username"]
      password = config["password"]
      @dbdc_client = Databasedotcom::Client.new(config)
      @dbdc_client.authenticate(:username => username, :password => password)
      @client.list_sobjects
    end

    @dbdc_client
  end
=begin
  def search
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)          
    client.authenticate :username => config[:username], :password => config[:password]
    @leads = client.query("select id, name from Lead limit 1000")
  end
=end

end
