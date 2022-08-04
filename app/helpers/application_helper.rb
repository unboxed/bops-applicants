module ApplicationHelper
  def formatted_phone_number
    number_to_phone(
      contact_details[:phone_number],
      delimiter: " ",
      pattern: /(\d{5})(\d{3})(\d{3})$/,
    )
  end

  def contact_details
    @contact_details ||= all_contact_details[current_local_authority].with_indifferent_access
  end

  def all_contact_details
    YAML.load_file(Rails.root.join("config/contact_details.yml"))
  end
end
