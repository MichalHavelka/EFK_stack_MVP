function append_tag(tag, timestamp, record)
    record["_original_tag"] = tag
    return 1, timestamp, record
end
