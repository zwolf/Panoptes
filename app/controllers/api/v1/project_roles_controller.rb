class Api::V1::ProjectRolesController < Api::ApiController
  include RolesController
  require_authentication :create, :update, :destroy, scopes: [:project]

  allowed_params :create, roles: [], links: [:user, :project]
  allowed_params :update, roles: []

  def resource_name
    "project_role"
  end

  def update
    super do
      Mailers::UserAddedToProject.run!(api_user: api_user, resource_id: params[:id], roles: roles) if new_roles_present?(roles)
    end
  end

  private

  def roles
    params[:project_roles][:roles]
  end

  def new_roles_present?(roles)
    (["collaborator", "expert"] & roles).present?
  end
end
