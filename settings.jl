
struct Settings
    url::String
    element::String
    title::String
    timeout::Int
    datadir::String
    chunksize::Int
end

(s::Settings)(id::String) = replace(s.url, "id" => id)

settings = Settings(
    "https://www.goodreads.com/book/show/id/reviews",
    ".Formatted",
    ".Text.H1Title",
    5,
    "data",
    2500,
)