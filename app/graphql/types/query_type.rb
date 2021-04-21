module Types
  class ReferencesType < BaseNode
    field :users, [UserType], null: true
    field :votes, [VoteType], null: true
  end

  class QueryType < BaseObject
    field :all_links, resolver: Resolvers::LinksSearch

    field :links, [LinkType], null: false
    field :references, ReferencesType, null: true

    def links
      RecordLoader.for(Link).load_many(Link.pluck(:id))
    end

    def references
      {
        users: links.then do |links|
                  RecordLoader.for(User).load_many(
                    links.map(&:user_id)
                  )
               end,
        votes: links.then do |links|
                 RecordLoader.for(Vote).load_many(
                   Vote.where(link_id: links.map(&:id)).pluck(:id)
                 )
               end
      }
    end
  end
end
