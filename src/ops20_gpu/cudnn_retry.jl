import cuDNN, CUDA

# Repeat cudnn calls that fail due to memory issues
macro cudnn_retry(ex)
    quote
        res = CUDA.retry_reclaim(()->($ex), x->(x ∈ (cuDNN.CUDNN_STATUS_ALLOC_FAILED, cuDNN.CUDNN_STATUS_EXECUTION_FAILED)))
        if res != cuDNN.CUDNN_STATUS_SUCCESS
            cuDNN.throw_api_error(res)
        end
    end |> esc
end
