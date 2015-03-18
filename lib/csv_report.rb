class CsvReport

  def self.generate_activity_log_report(physician, patients, hash, start_date, end_date)
    csv_string = FasterCSV.generate do |csv|
      name_label = "NAME:"
      dob_label = "DOB:"
      date_label = "DATE:"
      email_label = "EMAIL:"
      code_label = "CODE:"
      description_label = "DESCRIPTION:"
      patients.each do |patient|
       if hash[patient.id]
          data = []
          name = "#{patient.first_name} #{patient.middle_name} #{patient.last_name} "
          dob =  patient.date_of_birth.strftime("%Y/%m/%d")
          unless patient.email.empty?
            email = patient.email
          else
            email = ""
          end 
          cnt1=0 
          hash[patient.id].each do |date , id|
            date_flag = 0
            if cnt1==0 
              encounter_date = date 
            else 
              date_flag = 1 # to show 3 columns blank and then date i.e same patient with next encounter
              encounter_date = date 
            end
            cnt1+=1 
            cnt2=0 
            hash[patient.id][date].each do |id, val| 
              if cnt2==0
                code = hash[patient.id][date][id][:code] 
                desc = hash[patient.id][date][id][:description]
                if date_flag == 0
                  data << name_label
                  data << name
                  data << dob_label
                  data << dob
                  data << email_label
                  data << email
                  data << date_label
                  data << encounter_date
                  data << code_label
                  data << code
                  data << description_label
                  data << desc
                else#next encounter for same patient
                  data << date_label
                  data << encounter_date
                  data << code_label
                  data << code
                  data << description_label
                  data << desc
                end
              else
                #next code for same encounter
                code = hash[patient.id][date][id][:code]
                desc = hash[patient.id][date][id][:description] 
                data << code_label
                data << code
                data << description_label
                data << desc
              end 
              cnt2+=1
            end 
          end #hash[patinet.id]
         csv << data.flatten
        end  #hash[patient].empty? 
      end# patient.each
    end
    return csv_string
  end


  def self.generate_referral_volume_report(records, flag)
    csv_string = FasterCSV.generate do |csv|
      csv << ["PHYSICIAN","MONTH","REFERRAL COUNT"]
      if flag == 1
        cnt = 0
        data = []
        data << records.first.name
        records.each do |r|
          if cnt == 0
            data << Date::ABBR_MONTHNAMES[r.month.to_i]
            data << r.ref_count  
            cnt = cnt + 1
            csv << data.flatten
          else
            data = []
            data << ""
            data << Date::ABBR_MONTHNAMES[r.month.to_i]
            data << r.ref_count  
            csv << data.flatten
          end 
        end 
      else
        records.each do |r|
          data = []
          data << r.name  
          data << Date::ABBR_MONTHNAMES[r.month.to_i]
          data << r.ref_count  
          csv << data.flatten
        end
      end
    end
    return csv_string
  end


  def self.generate_average_length_of_stay_report(result)
    csv_string = FasterCSV.generate do |csv|
      csv << ["MONTH","AVERAGE LENGTH OF STAY"]
      result.each do |key, val|  
        data = []
        data << key     
        day = "#{val} days"
        data << day
        csv << data.flatten
      end
    end
    return csv_string
  end
end
