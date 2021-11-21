class TorrentsController < ApplicationController
  before_action :set_torrent, only: %i[ show edit update destroy ]

  # GET /torrents or /torrents.json
  def index
    @torrents = Torrent.all
  end

  # GET /torrents/1 or /torrents/1.json
  def show
  end

  # GET /torrents/new
  def new
    @torrent = Torrent.new
  end

  # GET /torrents/1/edit
  def edit
  end

  # POST /torrents or /torrents.json
  def create
    @torrent = Torrent.new(torrent_params)

    respond_to do |format|
      if @torrent.save
        format.html { redirect_to @torrent, notice: "Torrent was successfully created." }
        format.json { render :show, status: :created, location: @torrent }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @torrent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /torrents/1 or /torrents/1.json
  def update
    respond_to do |format|
      if @torrent.update(torrent_params)
        format.html { redirect_to @torrent, notice: "Torrent was successfully updated." }
        format.json { render :show, status: :ok, location: @torrent }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @torrent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /torrents/1 or /torrents/1.json
  def destroy
    @torrent.destroy
    respond_to do |format|
      format.html { redirect_to torrents_url, notice: "Torrent was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_torrent
      @torrent = Torrent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def torrent_params
      params.require(:torrent).permit(:title, :release_year, :url, :main)
    end
end
