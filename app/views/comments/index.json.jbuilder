json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :post, :user
  json.url comment_url(comment, format: :json)
end
