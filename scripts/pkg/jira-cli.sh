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
    version="1.6.0"
  fi
  local URL="${URL-https://github.com/ankitpokhrel/jira-cli/releases/download/v${version}/jira_${version}_linux_$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/jira.tar.gz" "${URL}"
  mkdir -p "/tmp/jira"
  tar -xf "/tmp/jira.tar.gz" --strip-components=1 -C "/tmp/jira"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/jira/bin/jira" "${HOME}/.local/bin/jira"
  chmod +x "${HOME}/.local/bin/jira"

  # cleanup
  rm -f /tmp/jira.tar.gz
  rm -rf /tmp/jira
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/jira"
}

main "$@"
