class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy

  def author_of?(item)
    item.try(:user_id) == id
  end
end
