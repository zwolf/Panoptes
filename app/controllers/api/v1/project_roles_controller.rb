class Api::V1::ProjectRolesController < Api::ApiController
  include RolesController
  require_authentication :create, :update, :destroy, scopes: [:project]

  allowed_params :create, roles: [], links: [:user, :project]
  allowed_params :update, roles: []

  def resource_name
    "project_role"
  end

  def update
    user_added_to_project(user.id, id, params[:roles])
  end

  def user_added_to_project(user_id, project_id, roles)
    operation.run!(user_id, project_id, roles)
  end
end
