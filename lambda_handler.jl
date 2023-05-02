import JSON

# Include your main function from scrape.jl
include("scrape.jl")

function handler(event, context)
    # Parse the event JSON string
    event_dict = JSON.parse(event)

    # Extract the path and path parameters
    path = event_dict["path"]
    id = match(r"/scrape/(\w+)", path).captures[1]

    # Call your main function with the required arguments
    summary = main(nothing, id)

    # Create the response
    response = Dict(
        "statusCode" => 200,
        "headers" => Dict("Content-Type" => "application/json"),
        "body" => JSON.json(Dict("summary" => summary))
    )

    # Return the response as a JSON string
    return JSON.json(response)
end