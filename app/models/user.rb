# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)
#  username               :string(255)
#  location               :string(255)
#  contact                :string(255)
#  gender                 :string(255)
#  bk_role                :string(255)
#  login_approval         :string(255)
#  lang                   :string(255)
#  role_id                :integer
#  tsv_data               :tsvector
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  authentication_token   :string
#

class User < ActiveRecord::Base
  include PgSearch
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  default_scope -> { order('created_at DESC') }
  validates_uniqueness_of :username
  validates_confirmation_of :password, length: { in: 6..20 }
  validates_presence_of :username, :role, :login_approval, :first_name, :last_name

  before_save :ensure_authentication_token

  default_value_for :role_id, 5

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :token_authenticatable

  # Search 
  pg_search_scope :user_search,
    against: :tsv_data,
    using: {
      tsearch: {
        dictionary: 'english',
        any_word: true,
        prefix: true,
        tsvector_column: 'tsv_data'
      }
    }

  def role
    @role ||= Role.new(self.role_id).name
  end

end
