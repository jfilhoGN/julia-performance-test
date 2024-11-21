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

# Configuração do teste
url = "https://httpbin.org/post"  # Endpoint de teste
payload = Dict("key1" => "value1", "key2" => "value2")  # Corpo da requisição
n_requests = 20  # Número de requisições a serem realizadas

println("Iniciando benchmark com $n_requests requisições paralelas...\n")

result = benchmark_parallel_post(url, payload, n_requests)

println("\nResultado do benchmark:")
display(result)
println("Tempo médio (μs): ", mean(result))
println("Tempo mínimo (μs): ", minimum(result))
println("Tempo máximo (μs): ", maximum(result))
