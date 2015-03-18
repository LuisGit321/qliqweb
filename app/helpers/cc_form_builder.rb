class CCFormBuilder < ActionView::Helpers::FormBuilder  

  def self.create_tagged_field(method_name)
    define_method(method_name) do |name, *args|      
      errors = object.errors[name.to_sym].first

      # initialize some local variables
      klass = []
      label = ''      
      help = ''
      is_long = false
      if args.last.is_a?(Hash)
        arg_label = args.last[:label].to_s
        arg_klass = args.last[:class].to_s
        arg_required = args.last[:required].to_s
        arg_help = args.last[:help].to_s #add help information 
        arg_is_header = args.last[:header]
      end

      label = arg_label unless arg_label.blank?#Label text, titlize field name if a custom label isn't passed

      klass << arg_klass unless arg_klass.nil? #store custom class if it exists
      klass << 'fl field' if method_name == 'check_box'
      klass << 'fl field' if method_name == 'text_area'
      klass << 'fl field' if method_name == 'password_field'
      klass << 'fl field' if method_name == 'select'
      klass << 'fl field' if method_name == 'date_select'
      klass << 'fl field' if method_name == 'file_field'
      klass << 'fl field' if method_name.blank? #A default selector to indicate the contents are a form field
      klass << 'error' unless errors.blank?      

      klass = klass.join(' ') #turn all the class selectors into a string      

      # Required Field Notations
      # all: add required notation for all form methods
      # new: only for 'create new' forms, using the form in 'edit' mode should disregard
=begin
      if arg_required == true || (arg_required == 'new' && object.new_record?)
        label << @template.content_tag("span", "*", :class => 'required')
      end
=end
      if arg_is_header.blank?
        label = @template.content_tag(:label, label.to_s, :for => "#{@object_name}_#{name}")
      else
        label = @template.content_tag(:label, label.to_s, :for => "#{@object_name}_#{name}")
      end

      unless arg_help.blank?
        help << @template.content_tag(:div, arg_help)
      end

      reverse = true if method_name == 'check_box'

      # CLEAN UP
      # cleanup arbitrary html_options used to pass information to this form builder
      if args.last.is_a?(Hash)
        args.last[:label] = nil
        args.last[:required] = nil
        args.last[:help] = nil
        args.last[:is_long] = nil
      end    

      if errors
        error_message = errors.to_s
        alert = @template.content_tag(:div, error_message , :class => 'errMsg') 
      else
        alert = "" 
      end	


      if method_name == "date_select" || method_name == "check_box"
        field = super<<alert<<help
      else
        field = "#{label}"<<super<<alert<<help
        field = @template.content_tag(:div, field.to_s.html_safe, :class => "fields") 
      end
      field.to_s.html_safe
    end
  end

  helpers = %w{check_box text_field text_area password_field select date_select file_field}
  helpers.each do |name|
    create_tagged_field(name)
  end
end

