json.extract! email_content, :id, :scheme_id, :email_content_type_id, :email_name_id, :intro, :title, :body, :footer, :created_at, :updated_at
json.url email_content_url(email_content, format: :json)
