class SearchesController < ApplicationController

  def npi
    npi     = params[ :npi ].strip
    @result = NpiWS.find_npi_info npi
    respond_to do |format|
      format.json { render :json => @result }
    end
  end

end
