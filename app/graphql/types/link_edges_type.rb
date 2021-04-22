module Types
  class LinkEdgesType < BaseObject
    field :users, [UserType], null: false

    def users
      User.where(id: object[:nodes].map(&:user_id))
    end
  end
end
