require 'prawn'

class PdfReport
  def self.generate_activity_log_report(physician, patients, hash, start_date, end_date)
    pdf=Prawn::Document.new( :page_size => "A4" ) do
      self.font_size = 9
      widths = [90, 90, 125, 60, 50, 100]
      header = ["PATIENT NAME", "DOB", "Email", "DATE", "CODE", "DESCRIPTION" ]
      text "Date - #{Date.today.strftime("%Y/%m/%d")}", :align => :right, :size => 10
      text "Physician Name - Dr. #{physician.name} ", :align => :center, :size => 14, :style => :bold  
      self.move_down(5)
      text "Report Start Date - #{start_date}  End Date - #{end_date}", :align => :left, :size => 8, :style => :bold
      head = make_table([header], :column_widths => widths)
      data = []
      def row(name, dob, email, date, code, desc, widths)
        rows = name.map { |c| ["", "", "", "", "", ""] }
        rows[0][0] = name 
        rows[0][1] = dob
        rows[0][2] = email
        rows[0][3] = date
        rows[0][4] = code
        rows[0][5] = desc
        make_table(rows) do |t|
          t.column_widths = widths
          t.cells.style :borders => [:top, :bottom, :left, :right], :padding => 2
          t.columns(0..5).align = :left
        end
      end
      def get_patient_name(patient)
        name = "#{patient.first_name} #{patient.middle_name} #{patient.last_name} "
      end
      patients.each do |patient|
        if hash[patient.id]
          name = get_patient_name(patient)
          dob =  patient.date_of_birth.strftime("%Y/%m/%d")
          email =  patient.email.empty? ?  "" :  patient.email
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
                if date_flag == 0#next encounter for same patient
                  data << row("#{name}", "#{dob}", "#{email}","#{encounter_date}", "#{code}","#{desc}",widths)
                else
                  data << row(" ", "", "","#{encounter_date}", "#{code}","#{desc}",widths) 
                end
              else
                #next code for same encounter
                code = hash[patient.id][date][id][:code]
                desc = hash[patient.id][date][id][:description] 
                data << row(" ", "", "","", "#{code}","#{desc}",widths)
              end 
              cnt2+=1
            end 
          end #hash[patinet.id]
        end#if hash[patient.id]
      end# patient.each

      table( [[head] ,*(data.map{|d| [d]}) ] , :header => true )  do
        row(0).style :background_color => '#FFFFFF'
        cells.style :borders => []
      end
    end #pdf do
    return pdf
  end


  def self.generate_referral_volume_report(records, flag, start_date, end_date)
    pdf=Prawn::Document.new( :page_size => "A4" ) do
      self.font_size = 9
      widths = [90, 70, 120]
      header = ["PATIENT NAME", "MONTH", "REFERRAL COUNT"]
      text "Date - #{Date.today.strftime("%Y/%m/%d")}", :align => :right, :size => 10
      text "Referral Volume Report", :align => :center, :size => 14, :style => :bold
      self.move_down(10)
      text "Report Start Date - #{start_date}  End Date - #{end_date}", :align => :left, :size => 8, :style => :bold
      self.move_down(20)
      head = make_table([header], :column_widths => widths)
      data = []
      def row(name, month, count, widths)
        rows = name.map { |c| ["", "", ""] }
        rows[0][0] = name 
        rows[0][1] = month 
        rows[0][2] = count
        make_table(rows) do |t|
          t.column_widths = widths
          t.cells.style :borders => [:top, :bottom, :left, :right], :padding => 2
          t.columns(0..2).align = :left
        end
      end
      if flag == 1
        cnt = 0
        name = records.first.name
        records.each do |r|
          if cnt == 0
            month = Date::ABBR_MONTHNAMES[r.month.to_i]
            count = r.ref_count  
            cnt = cnt + 1
            data << row("#{name}", "#{month}", "#{count}", widths)
          else
            month = Date::ABBR_MONTHNAMES[r.month.to_i]
            count = r.ref_count  
            data << row(" ", "#{month}", "#{count}", widths)
          end 
        end 
      else
        records.each do |r|
          name = r.name
          month = Date::ABBR_MONTHNAMES[r.month.to_i]
          count = r.ref_count  
          data << row("#{name}", "#{month}", "#{count}", widths)
        end
      end
      table( [[head] ,*(data.map{|d| [d]}) ] , :header => true )  do
        row(0).style :background_color => '#FFFFFF'
        cells.style :borders => []
      end
    end
    return pdf
  end

  def self.generate_average_length_of_stay_report(result, start_date, end_date)
    pdf=Prawn::Document.new( :page_size => "A4" ) do
      self.font_size = 9
      widths = [90, 125]
      header = ["MONTH", "AVERAGE LENGTH OF STAY" ]
      text "Date - #{Date.today.strftime("%Y/%m/%d")}", :align => :right, :size => 10
      text "Average Length Of Stay Report", :align => :center, :size => 14, :style => :bold
      self.move_down(25)
      text "Report Start Date - #{start_date}  End Date - #{end_date}", :align => :left, :size => 8, :style => :bold
      head = make_table([header], :column_widths => widths)
      data = []
      self.move_down(50)
      def row(month, days, widths)
        rows = month.map { |c| ["", ""] }
        rows[0][0] = month 
        rows[0][1] = days 
        make_table(rows) do |t|
          t.column_widths = widths
          t.cells.style :borders => [:top, :bottom, :left, :right], :padding => 2
          t.columns(0..1).align = :left
        end
      end
      result.each do |key, val|  
        month = key     
        data << row("#{month}", "#{val} days",widths)
      end
      table( [[head] ,*(data.map{|d| [d]}) ] , :header => true )  do
        row(0).style :background_color => '#FFFFFF'
        cells.style :borders => []
      end
      require 'open-uri'
      chart = Gchart.line(:title => 'Avg length of stay', :data => result.values, :axis_with_labels => 'x,y', :axis_labels => [result.keys.join('|'), "0|" + result.values.sort.join('|')]) 
      image open(URI.escape(chart)), :at => [275, 700], :scale => 0.8 
    end
    return pdf
  end

  def self.generate_billing_agency_report(patients, billing_agency_id, billing_agency_name, patients_list)
    pdf=Prawn::Document.new( :page_size => "A4" ) do
      self.font_size = 9
      widths = [ 50, 50, 50, 50, 50, 200]
      text "Date - #{Date.today.strftime("%Y/%m/%d")}", :align => :right, :size => 10
      text "Billing Agency Report", :align => :center, :size => 14, :style => :bold
      self.move_down(15)
      text "Billing Agency Name - #{billing_agency_name}", :align => :left, :size => 8, :style => :bold
      header = ["DOS", "ICD9(p)", "ICD9", "ICD9", "ICD9", "CPT"]
      data = []
      self.move_down(20)
      def get_patient_name(patient)
        name = "#{patient.first_name} #{patient.middle_name} #{patient.last_name} "
      end
      def get_cpts_codes(cpt_ids)
        cpts = Cpt.find(cpt_ids)
        cpts.collect(&:code).join(', ')
      end
      def row(date, primary, general_icds_first,general_icds_second, general_icds_third, cpts, widths)
        rows = date.map { |c| ["", "", "", "", ""] }
        rows[0][0] = date 
        rows[0][1] = primary
        rows[0][2] = general_icds_first
        rows[0][3] = general_icds_second
        rows[0][4] = general_icds_third
        rows[0][5] = cpts
        make_table(rows) do |t|
          t.column_widths = widths
          t.cells.style :borders => [:top, :bottom, :left, :right], :padding => 2
          t.columns(0..5).align = :left
        end
      end
      patients.each do |patient|   
        flag = 0
        patients_list.each do |p|
          if p == patient.id
            flag = 1
          end
        end
        if flag == 1
          data = []
          self.move_down(15)
          text "Patient Name- #{get_patient_name(patient)} DOB-#{patient.date_of_birth.strftime("%Y/%m/%d")}", :align => :left ,:size => 8, :style => :bold
          self.move_down(5)
          head = make_table([header], :column_widths => widths) 
          patient.encounters.unbilled.uniq.each do |encounter|   
            date = encounter.date_of_service.strftime('%m/%d') 
            primary =  encounter.encounter_icds.primary.empty? ? "" : encounter.encounter_icds.primary.first.icd.code
            general_icds = encounter.encounter_icds.general   
            general_icds_first = general_icds[0].nil? ? "" : general_icds[0].icd.code
            general_icds_second =  general_icds[1].nil? ? "" : general_icds[1].icd.code
            general_icds_third =  general_icds[2].nil? ? "" :  general_icds[2].icd.code 
            cpts = get_cpts_codes(encounter.cpts.collect(&:cpt_id)) 
            data << row("#{date}", "#{primary}", "#{general_icds_first}","#{general_icds_second}", "#{general_icds_third}", cpts,widths)
          end   
          table( [[head] ,*(data.map{|d| [d]}) ] , :header => true )  do
            row(0).style :background_color => '#FFFFFF'
            cells.style :borders => []
          end
        end
      end   
    end
    filename = "#{Date.today.strftime("%Y-%m-%d")}.pdf"
    pdf.render_file RAILS_ROOT + "/public/system/reports/#{filename}"
    return filename
  end
end
