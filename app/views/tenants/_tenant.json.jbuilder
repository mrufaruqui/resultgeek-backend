json.extract! tenant, :id, :exam, :exam_uuid, :login_time, :logout_time, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
