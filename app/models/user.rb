class User < ActiveRecord::Base
  include CohortArMixin
  # Many validations are handled by the redhill schema_validations plugin.
  has_many :notes
  before_destroy :forbid_delete_of_immutable_objects

  def self.get_import_user
    self.find_by_username('importer')
  end

  protected
  def self.authenticate(username,password)
    if COHORT_AUTH_CLASS.authenticate(username,password)
      # We've auth'd. Autocreate the user if they don't exist.
      u = self.find_by_username(username)
      if u.blank?
        user = User.create(:username => username)
        return user
      else
        return u
      end
    end
    #No auth! return nil.
    return nil
  end
end
