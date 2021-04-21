module Types
  class VoteType < BaseObject
    field :id, Integer, null: false
    field :created_at, DateTimeType, null: false
    field :user, UserType, null: false
    field :link, LinkType, null: false
  end
end
