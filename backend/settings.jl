
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
    1500,
)

struct Model
    gptmodel::String
    prompt::String
end

modelsettings = Model(
    "gpt-3.5-turbo",
    "CHUNK \n can you summarize these reviews into a single review of the book? What is the general sentiment, and for which group of readers is this advised?",
)

@info "Loaded settings..."
