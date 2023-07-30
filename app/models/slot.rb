class Slot < ApplicationRecord
  validates :start, :end, presence: true
  validate :end_after_start

  private

  def end_after_start
    return if self[:end].blank? || self[:start].blank?

    if self[:end] <= self[:start]
      errors.add(:end, "must be after the start time")
    end
  end
end

