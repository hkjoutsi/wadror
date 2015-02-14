class StylesController < ApplicationController

  def index
    @styles = Style.all
  end

  def show
    set_style
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_style
      @style = Style.find_by_id(params[:id])
      if @style.nil? do redirect_to styles_path, notice:  "There is no style club with that id" end
    end

end
