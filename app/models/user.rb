class User < ApplicationRecord
  validates :image, {presence: true}
  validates :user_name, {length: {maximum:15},presence: true}
  validate :name_valid?
#   validate :size
  
  def name_valid?
    pp = user_name.to_s =~/^[^ -~｡-ﾟ]*$/
    errors.add("カード名", 'は全角で入力してください') if pp == nil
  end
  
#   def size
#     image = params[:image]
#     errors.add(:image, "1MBまでアップロードできます") if image.size > 1.kilobytes
#   end

end
