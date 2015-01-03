class Post < ActiveRecord::Base
  # self.per_pag  e = 20
	belongs_to :user
  has_many   :comments, dependent: :destroy
	validates_presence_of :text, :user_id

	def date
		updated_at.strftime("%A, %B %e, %Y")
	end
end
