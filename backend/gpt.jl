using OpenAI
include("settings.jl")

function query_gpt(query::String, modelsettings::Model)::String
    OPENAI_KEY = ENV["OPENAI_KEY"]
    model = modelsettings.gptmodel

    try
        r = create_chat(OPENAI_KEY, model, [Dict("role" => "user", "content" => query)])

        return r.response[:choices][begin][:message][:content]
    catch e
        @info "An error occured: $e"
        return ""
    end

end

function loop_chunks(chunks::Vector{String}, modelsettings::Model)::String
    summary = ""
    max_iterations = 3
    completed = 0
    chunk_index = 1
    while completed < max_iterations && chunk_index <= length(chunks)
        @info "Querying chunk #$chunk_index / $(length(chunks))"
        chunk = chunks[chunk_index]
        q = replace(modelsettings.prompt, "CHUNK" => chunk)
        r = query_gpt(q, modelsettings)
        if !isempty(r)
            summary = summary * "\n" * r
            completed += 1
        end
        chunk_index += 1
    end

    if completed > 1
        q = replace(modelsettings.prompt, "CHUNK" => summary)
        summary = query_gpt(q, modelsettings)
    end

    return summary
end
