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
    version="0.3.0"
  fi
  # https://github.com/ggml-org/llama.cpp/archive/refs/tags/v${version}.tar.gz
  local URL="${URL-https://github.com/ggml-org/llama.cpp.git}"

  # download
  mkdir -p "${HOME}/.local/src"
  git -C "${HOME}/.local/src" clone "${URL}"
  git -C "${HOME}/.local/src/llama.cpp" checkout "v${version}"

  # pick backend
  flags=""
  if lspci | grep -qiE "amd|radeon"; then
    echo "AMD GPU detected."
    
    # https://rocm.docs.amd.com/en/latest/install/rocm.html?fam=all&w=graphics&os=rhel&rhel-ver=10.2
    if grep -qi 'fedora' /etc/os-release; then
      declare -a PKGS_DNF
      PKGS_DNF+=(rocm-devel)
      PKGS_DNF+=(rocwmma-devel)
      util::dnf_install "${PKGS_DNF[@]}"
      HIPCXX="$(hipconfig -l)/clang"
      HIP_PATH="$(hipconfig -R)"
      export HIPCXX
      export HIP_PATH
      flags="-DGGML_HIP=ON -DGPU_TARGETS=$(rocminfo | grep -o 'gfx[0-9a-z]*' | head -1) -DGGML_HIP_ROCWMMA_FATTN=ON"
    fi
    flags=""
  fi

  # build (https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md)
  # shellcheck disable=SC2086
  cmake -S "${HOME}/.local/src/llama.cpp" -B "${HOME}/.local/src/llama.cpp/build" -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS=-march=native \
    -DCMAKE_CXX_FLAGS=-march=native \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    ${flags}
  cmake --build "${HOME}/.local/src/llama.cpp/build" --config Release

  echo "Check https://huggingface.co/models?other=code-generation for e.g. Qwen2.5-Coder-14B-Instruct-GGUF (https://huggingface.co/Qwen/Qwen2.5-Coder-14B-Instruct-GGUF?show_file_info=qwen2.5-coder-14b-instruct-q4_k_m.gguf)"
  # llama serve -hf bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF:Q4_K_M
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/src/llama.cpp"
}

main "$@"

