using HTTP
using Gumbo
using AbstractTrees
import JSON
using Oxygen


function scrape_reviews(req, id::String)::Vector{String}
    url = "https://www.goodreads.com/book/show/$(id)/reviews"
    @info "start get request for $url"
    response = HTTP.get(url)
    @info "finished response"
    reviews = []
    tags = r"<[^>]+>"
    if response.status == 200
        @info "response status ok, start parsing"
        body = String(response.body)
        doc = Gumbo.parsehtml(body)
        elements = PreOrderDFS(doc.root)
        txt = [e for e in elements if typeof(e) == HTMLText]
        apolloState = [JSON.parse(state.text) for state in txt if occursin("apolloState", state.text)]
        states = [state["props"]["pageProps"]["apolloState"] for state in apolloState]
        for d in states
            review = [key for key in keys(d) if occursin("Review", key)]
            texts = [d[rev]["text"] for rev in review]
            clean = [replace(text, tags => "") for text in texts]
            append!(reviews, clean)
        end
    end
    reviews
end

@get "/scrape/{id}" scrape_reviews
@get "/health" () -> "running!"
serve(host="0.0.0.0")
