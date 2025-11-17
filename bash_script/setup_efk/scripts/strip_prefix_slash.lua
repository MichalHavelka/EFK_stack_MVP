function strip_prefix_slash(tag, timestamp, record)
    local name = record["container_name"]
    if name ~= nil and type(name) == "string" then
        record["container_name"] = name:gsub("^/", "")
    end
    return 1, timestamp, record
end
