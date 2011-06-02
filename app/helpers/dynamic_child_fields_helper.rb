module DynamicChildFieldsHelper


  def add_child_link(name, form_builder, association, as)
    object = form_builder.object.class.reflect_on_association(association).klass.new
    partial = "/generic/" + as.to_s + "_fields"
    template = content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, object, :child_index => "new_#{association}") do |f|
        render(:partial => partial, :locals => { :f => f })
      end
    end
    template + link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end


  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end
  
end