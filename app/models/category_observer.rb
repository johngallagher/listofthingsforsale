class CategoryObserver < ActiveRecord::Observer
  def after_create(category)
    update_css_name(category)
  end
  
  def after_update(category)
    update_css_name(category)
  end
  
  def update_css_name(category)
    category.css_name = CategoryNameSanitizer.new(category.name).sanitize
  end
end