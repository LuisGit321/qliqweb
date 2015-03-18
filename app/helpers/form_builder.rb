class FormBuilder < ActionView::Helpers::FormBuilder

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
        arg_div_class = args.last[:div_class].to_s
      end


      unless arg_klass.nil?
        klass << arg_klass unless arg_klass.nil? #store custom class if it exists
      end

      arg_div_class << ' error_message' unless errors.blank?

      klass = klass.join(' ') #turn all the class selectors into a string      

      # Required Field Notations
      # all: add required notation for all form methods
      # new: only for 'create new' forms, using the form in 'edit' mode should disregard
      unless arg_label.blank?#Label text, titlize field name if a custom label isn't passed
        label = arg_label

        if errors
          label = @template.content_tag(:strong, @template.content_tag(:span, label.to_s, arg_required == "false" ? "no_backgorund" : ""), :class => "error")
        else
          label = @template.content_tag(:strong, @template.content_tag(:span, label.to_s, :class => arg_required == "false" ? "no_backgorund" : ""))
        end
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
        args.last[:div_class] = nil
      end

      if method_name == "date_select" || method_name == "check_box"
        field = super
      elsif !errors
        #field = super
        field =  label << @template.content_tag(:div, super , :class => "#{arg_div_class}")
      else
        if method_name == "select"
          field = label << @template.content_tag(:div, super, :class => "#{arg_div_class}")
        else
          field = label << @template.content_tag(:div, super(name, :class => klass) , :class => "#{arg_div_class}")
        end
      end
      field = field << @template.content_tag(:small, arg_help) unless arg_help.blank?
      field.to_s.html_safe
    end

  end

  helpers = %w{check_box text_field text_area password_field select date_select file_field}
  helpers.each do |name|
    create_tagged_field(name)
  end
end

