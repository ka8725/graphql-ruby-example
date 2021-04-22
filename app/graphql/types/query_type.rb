module Types
  class QueryType < BaseObject
    field :links, [LinkType], null: false
    field :references, ReferencesType, null: true

    field :links2, LinksType, null: false

    def links2
      {
        nodes: Link.all
      }
    end

    def links
      RecordLoader.for(Link).load_many(Link.pluck(:id))
    end

    def references
      {
        users: links.then do |links|
                  RecordLoader.for(User).load_many(
                    links.map(&:user_id).uniq
                  )
               end,
        votes: links.then do |links|
                 RecordLoader.for(Vote).load_many(
                   Vote.where(link_id: links.map(&:id).uniq).pluck(:id)
                 )
               end
      }
    end
  end
end
