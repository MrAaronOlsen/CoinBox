class Profile < ApplicationRecord
  belongs_to :user, optional: true

  validates :first_name, :last_name, presence: true

  def new?
    first_name == 'first name' || last_name == 'last name'
  end

end
