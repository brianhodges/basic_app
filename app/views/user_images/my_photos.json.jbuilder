json.status @status
json.array! @images.each do |image|
    json.id image.id
    json.filename image.filename
    json.content_type = image.content_type
    json.data Base64.encode64(image.data)
end