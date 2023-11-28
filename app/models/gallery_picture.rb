class GalleryPicture < ApplicationRecord
  belongs_to :rooms, optional: true
  belongs_to :inns, optional: true
  has_one_attached :picture
  validates :picture, presence: true
  validate :picture_format
end

private

def picture_format
  if picture.attached? && !picture.content_type.in?(%w(image/jpeg image/png))
    errors.add(:picture, 'deve possuir extensão JPEG ou PNG')
  end
end
