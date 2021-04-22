module Types
  class LinksType < BaseObject
    field :nodes, [LinkType], null: false
    field :edges, LinkEdgesType, null: false

    def edges
      object
    end
  end
end
