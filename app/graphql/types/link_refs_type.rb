module Types
  class LinkRefsType < BaseObject
    field :users, [UserType], null: false

    def users
      User.find(object[:records].map(&:user_id))
    end
  end
end
