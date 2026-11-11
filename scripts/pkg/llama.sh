#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/installer.sh
. "${SCRIPT_DIR}/../detail/installer.sh"

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Installs the package.
## @param $version requested version to install, "latest" by default.
# --------------------------------------------------------------------------------------
local::do_install() {
  if [ "${version}" == "latest" ]; then
    version="0.9.0"
  fi
  # https://github.com/ggml-org/llama.cpp/archive/refs/tags/v${version}.tar.gz
  local URL="${URL-https://github.com/ggml-org/llama.cpp.git}"

  # download
  mkdir -p "${HOME}/.local/src"
  git -C "${HOME}/.local/src" clone "${URL}"
  git -C "${HOME}/.local/src/llama.cpp" checkout "v${version}"

  # configure
  cat <<'EOF' >"${HOME}/.local/src/llama.cpp/CMakeUserPresets.json"
{
  "$schema": "https://cmake.org/cmake/help/latest/_downloads/3e2d73bff478d88a7de0de736ba5e361/schema.json",
  "version": 8,
  "configurePresets": [
    {
      "name": "native",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build",
      "installDir": "$env{HOME}/.local",
      "environment": {
      },
      "cacheVariables": {
        "BUILD_TESTING": "OFF",
        "CMAKE_BUILD_TYPE": "Release",
        "CMAKE_C_FLAGS": "-march=native",
        "CMAKE_CXX_FLAGS": "-march=native",
        "CMAKE_INSTALL_RPATH": "$ORIGIN/../lib64:$ORIGIN/../lib",
        "CMAKE_INSTALL_RPATH_USE_LINK_PATH": true,
        "CMAKE_INTERPROCEDURAL_OPTIMIZATION": "ON",
        "LLAMA_BUILD_TESTS": "OFF",
        "LLAMA_BUILD_EXAMPLES": "OFF",
        "LLAMA_TESTS_INSTALL": "OFF"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "native",
      "configurePreset": "native",
      "configuration": "Release"
    }
  ]
}
EOF

  jq --arg GGML_AVX "$(lscpu | grep -qow avx && echo "ON" || echo "OFF")" '.configurePresets[0].cacheVariables += {"GGML_AVX": $GGML_AVX}' CMakeUserPresets.json \
    >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

  jq --arg GGML_AVX2 "$(lscpu | grep -qow avx2 && echo "ON" || echo "OFF")" '.configurePresets[0].cacheVariables += {"GGML_AVX2": $GGML_AVX2}' CMakeUserPresets.json \
    >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

  jq --arg GGML_AVX512 "$(lscpu | grep -qow avx512 && echo "ON" || echo "OFF")" '.configurePresets[0].cacheVariables += {"GGML_AVX512": $GGML_AVX512}' CMakeUserPresets.json \
    >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

  # configure: pick backend
  if lspci | grep -qiE "amd|radeon"; then
    echo "AMD GPU detected."

    # https://rocm.docs.amd.com/en/latest/install/rocm.html?fam=all&w=graphics&os=rhel&rhel-ver=10.2
    if grep -qi 'fedora' /etc/os-release; then
      declare -a PKGS_DNF
      PKGS_DNF+=(rocm-devel)
      PKGS_DNF+=(rocwmma-devel)
      util::dnf_install "${PKGS_DNF[@]}"

      jq --arg HIPCXX "$(hipconfig -l)/clang" '.configurePresets[0].environment += {"HIPCXX": $HIPCXX}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

      jq --arg HIP_PATH "$(hipconfig -R)" '.configurePresets[0].environment += {"HIP_PATH": $HIP_PATH}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

      jq --arg GPU_TARGETS "$(rocminfo | grep -o 'gfx[0-9a-z]*' | head -1)" '.configurePresets[0].cacheVariables += {"GPU_TARGETS": $GPU_TARGETS}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

      jq --arg GGML_HIP "ON" '.configurePresets[0].cacheVariables += {"GGML_HIP": $GGML_HIP}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

      jq --arg GGML_HIP_ROCWMMA_FATTN "ON" '.configurePresets[0].cacheVariables += {"GGML_HIP_ROCWMMA_FATTN": $GGML_HIP_ROCWMMA_FATTN}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

      jq --arg GGML_CUDA_FA "OFF" '.configurePresets[0].cacheVariables += {"GGML_CUDA_FA": $GGML_CUDA_FA}' CMakeUserPresets.json \
        >.CMakeUserPresets.json && mv .CMakeUserPresets.json CMakeUserPresets.json

    fi
  fi

  # build (https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md)
  cmake -S "${HOME}/.local/src/llama.cpp" -B "${HOME}/.local/src/llama.cpp/build" --preset "native"
  cmake --build "${HOME}/.local/src/llama.cpp/build" --preset "native" --target install

  # install
  cat <<EOF >"${HOME}/.local/bin/ai-chat-server"
#!/bin/bash
${HOME}/.local/bin/llama serve -hf bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF:Q3_K_L --ctx-size 16384 --gpu-layers 99 --cache-type-k q8_0 --cache-type-v q8_0 --flash-attn on
EOF
  chmod +x "${HOME}/.local/bin/ai-chat-server"

  cat <<EOF >"${HOME}/.local/bin/ai-autocomplete-server"
#!/bin/bash
${HOME}/.local/bin/llama serve -hf bartowski/deepseek-coder-1.3B-kexer-GGUF:Q8_0 --ctx-size 16384 --gpu-layers 99 --flash-attn on
EOF
  chmod +x "${HOME}/.local/bin/ai-autocomplete-server"

  echo "ai-chat-server and ai-autocomplete-server installed"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/ai-autocomplete-server"
  rm -rf "${HOME}/.local/bin/ai-chat-server"
  xargs rm -f < "${HOME}/.local/src/llama.cpp/build/install_manifest.txt"
  rm -rf "${HOME}/.local/src/llama.cpp"
  rm -rf "${HOME}/.cache/huggingface"
}

main "$@"
