using HTTP              
using BenchmarkTools    
using Base.Threads      
using JSON   

# export JULIA_NUM_THREADS=4

function perform_post(url, payload)
    headers = ["Content-Type" => "application/json"]
    body = JSON.json(payload)  

    response = HTTP.post(url, headers; body=body)

    return response.status
end

function parallel_post_requests(url, payload, n_requests)
    @threads for _ in 1:n_requests
        status = perform_post(url, payload)
        println("Thread $(threadid()): Status $(status)")
    end
end

function benchmark_parallel_post(url, payload, n_requests)
    @benchmark parallel_post_requests($url, $payload, $n_requests)
end

url = "https://httpbin.org/post"  
payload = Dict("key1" => "value1", "key2" => "value2")  
n_requests = 20  

println("Inicialized benchmark with $n_requests parallell requests...\n")

result = benchmark_parallel_post(url, payload, n_requests)

println("\Result of Requests:")
display(result)
println("Avg. Time (μs): ", mean(result))
println("Min. time (μs): ", minimum(result))
println("Max. time (μs): ", maximum(result))
