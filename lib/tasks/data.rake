namespace :db do
  namespace :migrate do
    desc "Load Cpt data"
    task :dump_cpt => :environment do
      file = File.open('cpt.csv')
      collection = file.readlines
      collection.each do |cpt|
        fields = cpt.split('|')
        Cpt.create(:id => fields[0].to_i, :code => fields[1], :description => fields[2], :short_key => fields[3])
      end
      file.close
    end

    desc "Load Icd data"
    task :dump_icd => :environment do
      file = File.open('icd.csv')
      collection = file.readlines
      collection.each do |icd|
        fields = icd.split('|')
        Icd.create(:id => fields[0].to_i, :code => fields[1], :description => fields[2])
      end
      file.close
    end

    desc "Load specialty data"
    task :dump_specialty => :environment do
      file = File.open('speciality.csv')
      collection = file.readlines
      collection.each do |s|
        fields = s.split('|')
        Specialty.create(:id => fields[0].to_i, :name => fields[1])
      end
      file.close
    end

    desc "Load Superbill data"
    task :dump_superbill => :environment do
      file = File.open('superbill.csv')
      collection = file.readlines
      collection.each do |s|
        fields = s.split('|')
        Superbill.create(:id => fields[0].to_i, :name => fields[1], :specialty_id => fields[3])
      end
      file.close
    end

    desc "Load SuperbillCpts data"
    task :dump_superbill_cpts => :environment do
      file = File.open('superbill_cpt.csv')
      collection = file.readlines
      collection.each do |s|
        fields = s.split('|')
        SuperbillCpt.create(:id => fields[0].to_i, :superbill_id => fields[1], :cpt_group_id => fields[2], :group_display_order => nil, :cpt_id => fields[4])
      end
      file.close
    end

    desc "Load Cpt Group data"
    task :dump_cpt_group => :environment do
      file = File.open('cpt_group.csv')
      collection = file.readlines
      collection.each do |cpt|
        fields = cpt.split('|')
        CptGroup.create(:id => fields[0].to_i, :name => fields[1])
      end
      file.close
    end

    desc "Load Note types"
    task :dump_note_types => :environment do
      file = File.open('note_types.csv')
      collection = file.readlines
      collection.each do |note|
        fields = note.split('|')
        NoteType.create(:id => fields[0].to_i, :description => fields[1])
      end
      file.close
    end

    desc "Update Note Types"
    task :update_note_types => :environment do
      NoteType.find(3).destroy
      NoteType.create(:description => "Hospital Course")
      NoteType.create(:description => "Medications")
      NoteType.create(:description => "Followup Instructions")
    end

    desc "Update Facilities"
    task :update_facilities => :environment do
      data = Spreadsheet.open "#{RAILS_ROOT}/db/xls/Demo_Data.xls"
      sheet1 = data.worksheet 0
      i = 0
      sheet1.each do |row|
        i+=1
        next if i == 1
        n_name = row[0]
        n_facility_type = row[1]
        facility_type = FacilityType.find_or_create_by_name(row[1])
        facility = Facility.new(:name => n_name, :facility_type_id => facility_type.id)
        facility.save(:validate => false)
      end
    end

  end
end
