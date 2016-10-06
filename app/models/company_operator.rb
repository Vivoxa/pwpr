class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(owner admin user_r user_rw )

  attr_accessor :name

  belongs_to :scheme
end
