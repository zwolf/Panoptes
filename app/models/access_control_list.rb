class AccessControlList < ActiveRecord::Base
  belongs_to :user_group
  belongs_to :resource, polymorphic: true

  validates_presence_of :user_group
  validates_uniqueness_of :user_group, scope: [:resource_id, :resource_type], message: ". Roles have already been set for this user or group"

  after_update :send_collaborator_email, if: :roles_changed?

  def send_collaborator_email
    if resource.class == Project && check_new_roles.present?
      UserInfoChangedMailerWorker.perform_async(id, resource.id, check_new_roles)
    end
  end

  def check_new_roles
    diff = changes[:roles] ? changes[:roles][1].sort - changes[:roles][0].sort : []
    ["collaborator", "expert"] & diff
  end

  def self.scope_for(action, groups, resource_type: nil)
    case action
    when :show, :index
      where(resource: resource_type.scope_for(:show, groups))
    when :update, :destroy
      where(resource: resource_type.scope_for(:update, groups))
    end
  end
end
