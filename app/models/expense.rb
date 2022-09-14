class Expense < ApplicationRecord
  belongs_to :incurred_by, class_name: "User", foreign_key: "incurred_by_id"
  belongs_to :paid_by, class_name: "User", foreign_key: "paid_by_id"
  belongs_to :user

  has_many :splits, dependent: :destroy

  validates :incurred_at, presence: true
  validates :description, presence: true
  validates :total_amount, presence: true

  attr_accessor :user_ids

  def calculate_split_amount(user_ids)
    total_amount / user_ids.length
  end

  def calculate_split_remainder_amount(split_amount)
    (total_amount % split_amount).round(2)
  end
end
