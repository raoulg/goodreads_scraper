using HTTP
using Gumbo
using Cascadia
using Oxygen
include("settings.jl")

function scrape_reviews(id::String, settings::Settings)
    url = settings(id)
    @info "start get request for $url"

    response = HTTP.get(url)
    @info "finished response"
    reviews = String[]
    if response.status == 200
        @info "response status ok, start parsing"
        body = String(response.body)
        doc = Gumbo.parsehtml(body)
        selector = Selector(settings.element)
        matched_elements = eachmatch(selector, doc.root)
        titles = eachmatch(Selector(settings.title), doc.root)
        isempty(titles) ? t = "0" : t = replace(nodeText(titles[1]), r" |:" => "")
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
        sleep(2)
        res, t = f(args...; kwargs...)
    end
    return res, t
end


function save_reviews_to_file(id, reviews, settings)
    chunk_size = settings.chunksize
    chunks = []
    current_chunk = []
    current_word_count = 0

    for review in reviews
        review_word_count = length(split(review))
        if current_word_count + review_word_count <= chunk_size
            push!(current_chunk, review)
            current_word_count += review_word_count
        else
            push!(chunks, current_chunk)
            current_chunk = [review]
            current_word_count = review_word_count
        end
    end
    push!(chunks, current_chunk)

    for (index, chunk) in enumerate(chunks)
        fname = settings.datadir * "/review_$(id)_$(index).txt"
        @info "Writing $fname to disk"
        open(fname, "w") do io
            write(io, join(chunk, "\n\n"))
        end
    end
end

# id = "44767248"
# reviews, title = retry_if_empty(scrape_reviews, id, settings)
# reviews[1]
# length(reviews)

function main(req, id)
    reviews, title = retry_if_empty(scrape_reviews, id, settings)
    save_reviews_to_file(title, reviews, settings)
    println("Reviews saved to disk!")
end


@get "/scrape/{id}" main
@get "/health" () -> "running!"
serve(host="0.0.0.0")
