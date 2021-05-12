module Types
  class QueryType < BaseObject
    class DescriptionSortEnum < BaseEnum
      value 'description_ASC'
      value 'description_DESC'
    end

    class FilterArgument < BaseInputObject
      argument :sort, DescriptionSortEnum, required: false, default_value: 'description_ASC'
    end

    class PaginateArgument < BaseInputObject
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 10
    end

    field :links2, [LinkType], null: false
    field :references, ReferencesType, null: true

    field :links, LinksType, null: false do
      argument :first, Integer, required: false, default_value: 10
      argument :after, Integer, required: false, default_value: 0
    end

    field :links_sort_and_pagination, LinksType, null: false do
      argument :filter, FilterArgument, required: false, default_value: {sort: 'description_ASC'}
      argument :paginate, PaginateArgument, required: false, default_value: {page: 1, perPage: 10}
    end

    def links_sort_and_pagination(**params)
      {
        records: apply_offset_paginate(apply_sort(Link.all, **params[:filter]), **params[:paginate])
      }
    end

    def links(**params)
      {
        records: apply_pagination(Link.all, **params.slice(:first, :after))
      }
    end

    def links2
      context[:links_loader] ||= RecordLoader.for(Link).load_many([1,2,3])
    end


    def deeper
      RecordLoader.for(Link).load(10)
    end

    def references
      {
        users: context[:links_loader].then do |links|
                  RecordLoader.for(User).load_many(
                    links.map(&:user_id).uniq
                  )
               end,
        votes: context[:links_loader].then do |links|
                 RecordLoader.for(Vote).load_many(
                   Vote.where(link_id: links.map(&:id).uniq).pluck(:id)
                 )
               end
      }
    end

    def apply_pagination(scope, first:, after:)
      scope = scope.limit(first) if first
      scope = scope.where('id > ?', after) if after
      scope
    end

    def apply_sort(scope, sort:)
      case sort
      when 'description_ASC'
        scope.order('description asc')
      when 'description_DESC'
        scope.order('description desc')
      else
        fail ArgumentError
      end
    end

    def apply_offset_paginate(scope, page:, per_page:)
      scope.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
