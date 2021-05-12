module Types
  class LinksType < BaseObject
    field :records, [LinkType], null: false
    field :refs, LinkRefsType, null: false

    def refs
      object
    end
  end
end
