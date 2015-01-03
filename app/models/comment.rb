class Comment < ActiveRecord::Base
  self.per_page = 20
  belongs_to :user
  belongs_to :post
  validates_presence_of :text, :post_id, :user_id

  def date
    updated_at.strftime("%A, %B %e, %Y")
  end

end
