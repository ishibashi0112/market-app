class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]


  has_one :identification
  has_one :deliver_address
  has_many :cards
  has_many :items,foreign_key: :seller_id, dependent: :destroy
  has_many :sns_credentials


  accepts_nested_attributes_for :identification
  accepts_nested_attributes_for :deliver_address

  validates :nickname, presence: true, uniqueness: true

  VALID_EMAIL_REGEX = /\A([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6})*\z/
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
        email: auth.info.email
      )
    if user.persisted?
      sns.user = user
      sns.save
    end
      { user: user, sns: sns }
  end

end
