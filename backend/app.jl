import JSON
using HTTP

# Include your main function from scrape.jl
include("scrape.jl")

const LAMBDA_RUNTIME_API = ENV["AWS_LAMBDA_RUNTIME_API"]
const NEXT_INVOCATION_URL = "http://$LAMBDA_RUNTIME_API/2018-06-01/runtime/invocation/next"
const INVOCATION_RESPONSE_URL = "http://$LAMBDA_RUNTIME_API/2018-06-01/runtime/invocation"

function handler(event::AbstractDict)
    number = event["number"]
    summary = main(string(number))
    headers = Dict(
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Headers" => "Content-Type",
        "Access-Control-Allow-Methods" => "OPTIONS, POST",
    )
    return Dict(
        "statusCode" => 200,
        "headers" => headers,
        "body" => Dict("number" => number, "summary" => summary),
    )
end

function process_event(event_data::String)
    event = JSON.parse(event_data)
    response = handler(event)
    response_json = JSON.json(response)
    return response_json
end

function main(args)
    while true
        try
            # Get the next event
            response = HTTP.request("GET", NEXT_INVOCATION_URL)

            # Convert headers to a dictionary
            headers_dict = Dict{String,String}(response.headers)

            # Get the request ID
            request_id = headers_dict["Lambda-Runtime-Aws-Request-Id"]

            # Process the event
            response_body = process_event(String(response.body))

            # Send the response
            response_url = "$INVOCATION_RESPONSE_URL/$request_id/response"
            HTTP.request("POST", response_url, [], response_body)

        catch e
            @error "Error processing event" exception = (e, catch_backtrace())
        end
    end
end

main(ARGS)
