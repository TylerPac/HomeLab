# AIStack

Local AI and private search stack.

## Why This Exists

This stack lets me run AI tools locally on my own hardware so I can learn, iterate fast, and keep control over my data.

## Services

### llama-cpp

- Image: `ghcr.io/ggml-org/llama.cpp:server-cuda12`
- Purpose: CUDA-accelerated local LLM inference server
- Host port: `8091` -> container `8080`
- Model mount: `/mnt/HDDStorage/DockerVolumes/AIStack/Models` (read-only)
- Config mount: `/opt/HomeLab/configs/AIStack/llama-cpp/config` (read-only)

### searxng

- Image: `searxng/searxng:latest`
- Purpose: private metasearch engine
- Host port: `8082` -> container `8080`
- Config mount: `/opt/HomeLab/configs/AIStack/searxng`

## Notes

- `llama-cpp` is configured to autoload models via `/config/models.ini`
- NVIDIA devices are exposed for acceleration
