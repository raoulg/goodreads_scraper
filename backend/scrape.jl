using HTTP
using Gumbo
using Cascadia
include("settings.jl")
include("gpt.jl")

function scrape_reviews(id::String, settings::Settings)::Tuple{Vector{String}, String}
    url = settings(id)
    @info "start get request for $url"

    response = HTTP.get(url; readtimeout=10)
    @info "finished response"
    reviews = String[]
    if response.status == 200
        @info "response status ok, start parsing"
        body = String(response.body)
        doc = Gumbo.parsehtml(body)
        selector = Selector(settings.element)
        matched_elements = eachmatch(selector, doc.root)
        titles = eachmatch(Selector(settings.title), doc.root)
        isempty(titles) ? t = "0" : t = replace(nodeText(titles[1]), r" |:|'" => "")
        for el in matched_elements
            txt = nodeText(el)
            push!(reviews, txt)
        end
    end
    @info "finished scraping $id with $(length(reviews)) reviews"
    reviews, t
end


function retry_if_empty(f::Function, args...; kwargs...)
    res, t = f(args...; kwargs...)
    while isempty(res)
        @info "Empty result, retrying..."
        sleep(3)
        res, t = f(args...; kwargs...)
    end
    return res, t
end

function chunk_reviews(reviews::Vector{String}, settings::Settings)::Vector{String}
    chunk_size = settings.chunksize
    chunks = String[]
    current_chunk = ""
    current_word_count = 0
    SMALLER = true

    for review in reviews
        review_word_count = length(split(review))
        if current_word_count + review_word_count <= chunk_size
            current_chunk = current_chunk * "\n next review: " * review
            current_word_count += review_word_count
            SMALLER = true
        else
            push!(chunks, current_chunk)
            current_chunk = review
            current_word_count = review_word_count
            SMALLER = false
        end
    end
    SMALLER ? push!(chunks, current_chunk) : nothing
    return chunks
end

function save_reviews_to_file(id, chunks, settings)
    for (index, chunk) in enumerate(chunks)
        fname = settings.datadir * "/review_$(id)_$(index).txt"
        @info "Writing $fname to disk"
        open(fname, "w") do io
            write(io, join(chunk, "\n\n"))
        end
    end
end

function save_summary_to_file(summary, title, settings)
    if !isdir(settings.datadir)
        @info "$(settings.datadir) does not exist in $pwd(), creating..."
        mkdir(settings.datadir)
    end
    fname = joinpath(settings.datadir, "summary_$(title).txt")
    @info "Writing $fname to disk"
    
    open(fname, "w") do io
        write(io, summary)
    end
end


function main(id)
    reviews, title = retry_if_empty(scrape_reviews, String(id), settings)
    chunks = chunk_reviews(reviews, settings)
    summary = loop_chunks(chunks, modelsettings)
    "--save" in ARGS ? save_summary_to_file(summary, title, settings) : @info "Add --save to save summary to disk"
    return summary
end


# @get "/scrape/{id}" main
# @get "/health" () -> "running!"
# serve(host="0.0.0.0")
