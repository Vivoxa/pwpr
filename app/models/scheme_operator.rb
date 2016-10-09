class SchemeOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(scheme_owner scheme_full_access scheme_user_r scheme_user_rw)

  attr_accessor :name
  has_and_belongs_to_many :schemes
  validates_presence_of :schemes

  scope :company_operators, -> (scheme) { scheme.company_operators }
  scope :pending_scheme_operators, -> { where('confirmed_at <= NOW()') }
end
