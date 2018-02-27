class ContentModelTest < Mariposta::ContentModel
  variables :first_name, :last_name, :full_name, :occupation, :tags

  attr_accessor :compute_full_name

  def full_name
    if compute_full_name
      first_name + " " + last_name
    else
      nil
    end
  end
end
