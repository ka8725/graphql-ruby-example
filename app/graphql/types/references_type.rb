module Types
  class ReferencesType < BaseObject
    field :users, [UserType], null: true
    field :votes, [VoteType], null: true
  end
end
