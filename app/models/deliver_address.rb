class DeliverAddress < ApplicationRecord
  belongs_to :user, optional: true
  validates :family_name_kanji, :first_name_kanji, :family_name_kana, :first_name_kana, :postal_code, :prefecture, :city, :address1,
              presence: true

  validates :family_name_kanji, :first_name_kanji, format: {with: /\A[ぁ-んァ-ン一-龥]/}
  validates :family_name_kana, :first_name_kana, format: {with: /\A[ァ-ヶー－]+\z/}

end