class Solution < ActiveRecord::Base
	belongs_to :user
	belongs_to :error_message
end
