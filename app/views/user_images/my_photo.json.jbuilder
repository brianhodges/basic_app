json.status @status
if @image && @image != 1
    json.id @image.id
    json.filename @image.filename
    json.content_type @image.content_type
    json.data Base64.encode64(@image.data)
end
json.deleted @image == 1 ? 1 : 0
