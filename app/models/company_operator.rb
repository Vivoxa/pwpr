class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ROLES = %w(co_director co_contact co_user).freeze
  PERMISSIONS = %w(co_user_r co_user_rw co_user_rwe).freeze
  royce_roles ROLES + PERMISSIONS

  validates_presence_of :business

  belongs_to :business
  # this scope is no longer relevant due to the change in relationship to schemes
  # scope :scheme_operators, -> (scheme) { scheme.scheme_operators }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super && 'Use whatever other message'
    end
  end
end
