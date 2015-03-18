class NpiAdapter

  # - Class Methods -
  class << self

    def find_physician_by_npi( npi )
      # data = NpiWS.find_physician_by_npi npi
      # physician_from_json data
      # Not yet implemented.
    end

    def physician_from_json( json )
      # data            = OpenStruct.new JSON.parse( json )
      # physician_hash  = {
      #   :name => "#{ data.first_name } #{ data.last_name }",
      #   :npi  => data.npi
      # }
      # Physician.new physician_hash
      # Not yet implemented.
    end

  end

end
