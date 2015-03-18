module HomeHelper

  def main_nav_tag
    result    = '<ul>'
    css_class = ( action_name == 'index' && controller_name == 'home' ) ? 'active' : ''
    result    += content_tag( :li, content_tag( :a, content_tag( :span, 'Overview' ), :href => root_path ), :class => css_class )
    css_class = ( action_name == 'iphone' && controller_name == 'home' ) ? 'active' : ''
    result    += content_tag( :li, content_tag( :a, content_tag( :span, 'iPhone' ), :href => '#' ), :class => css_class )
    css_class = ( action_name == 'desktop' && controller_name == 'home' ) ? 'active' : ''
    result    += content_tag( :li, content_tag( :a, content_tag( :span, 'Desktop' ), :href => '#' ), :class => css_class )
    result    += '</ul>'
    result.html_safe
  end

end
