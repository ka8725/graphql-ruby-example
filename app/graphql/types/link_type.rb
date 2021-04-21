module Types
  class LinkType < BaseObject
    field :id, Integer, null: false
    field :created_at, DateTimeType, null: false
    field :url, String, null: false
    field :description, String, null: false
    field :userId, Integer, null: false
    field :voteIds, [Integer], null: false
  end
end
