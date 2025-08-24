class Posting < ApplicationRecord
  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'

  # code moved to presenter. So, now we have clear model and the code for views in appropriate place for it
end
