using AWSLambdaRuntime

function handler(event::AbstractDict)
    try
        number = parse(Int, event["body"])
        message = "Hello world $(number)"
        return AWSLambdaRuntime.Client.Response(200, "{\"message\":\"$(message)\"}")
    catch ex
        @error "Error processing request" exception=ex
        return AWSLambdaRuntime.Client.Response(500, "{\"message\":\"An error occurred\"}")
    end
end

AWSLambdaRuntime.run(handler)
