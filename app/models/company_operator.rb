class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ROLES = %w(co_director co_contact co_user).freeze
  PERMISSIONS = %w(co_users_r co_users_w co_users_d co_users_e).freeze
  royce_roles ROLES + PERMISSIONS

  belongs_to :business

  validates_presence_of :business

  # scope :active, -> { where(approved: true) }
  # scope :pending, -> { where(approved: false) }

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
