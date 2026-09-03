# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, equate package compatibility.

See [example](tests/example/test.typ) and [equate example](tests/compatibility-equate/test.typ) for usage.

## Development

```bash
cargo install --locked typst-cli
cargo install --locked tytanic
cargo install --locked typstyle
cargo install --git https://github.com/typst/package-check.git
cargo install --git https://github.com/sjfhsjfh/typship.git

typship login universe # Currently Personal access tokens (classic) required

export TYPST_PACKAGE_PATH=$PWD/packages
typst-package-check check
typstyle --inplace .
typstyle --check .
tt run
typship publish universe
```

## AI setup

```
https://llama.app/
curl -LsSf https://llama.app/install.sh | sh
llama serve -hf ggml-org/Qwen3.8-27B-GGUF:Q4_K_M -c 0 --reasoning-preserve

[agents]
recent = "agent"

[models]
recent = "llamacpp:qwen3.8-27b"

[models.providers.llamacpp]
display_name = "llama.cpp"
base_url = "http://127.0.0.1:8080"
class_path = "langchain_openai.chat_models.base:ChatOpenAI"
api_key = "empty"

[models.providers.llamacpp.params]
stream_chunk_timeout = 3600

OPENAI_API_KEY=empty dcode
```
