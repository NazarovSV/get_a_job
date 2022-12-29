# frozen_string_literal: true

class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.content_tag(:nav, 'aria-label' => 'breadcrumb') do
      @context.content_tag(:ol, class: 'breadcrumb') do
        @elements.collect do |element|
          render_element(element)
        end.join.html_safe
      end
    end
  end

  def render_element(element)
    current = @context.current_page?(compute_path(element))

    classes = ['breadcrumb-item']
    classes.push('active') if current

    @context.content_tag(:li, class: classes.join(' ')) do
      link_or_text = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
      link_or_text
    end
  end
end
