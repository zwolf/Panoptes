module Recents
  def recents
    ps = params.dup
    ps.delete "#{resource_name}_id"
    render json_api: RecentSerializer.page(ps, recent_scope, { type: resource_sym.to_s, owner_id: resource_ids })
  end

  def recent_scope
    Recent.eager_load(:classification, :subject, :locations, :workflow, :project)
      .where(classifications: classification_query)
  end

  def classification_query
    query = { :"#{resource_name}_id" => resource_ids }
    query['project_id'] = params[:project_id] if params.has_key?(:project_id)
    query['workflow_id'] = params[:workflow_id] if params.has_key?(:workflow_id)
    query
  end
end
