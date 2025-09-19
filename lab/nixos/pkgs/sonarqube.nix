{
  stdenv,
  fetchzip,
  jdk17_headless,
}:
# https://docs.sonarsource.com/sonarqube-server/10.8/setup-and-upgrade/install-the-server/installing-sonarqube-from-zip-file/
stdenv.mkDerivation {
  pname = "sonarqube";
  version = "2025.4";

  src = fetchzip {
    url = "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.8.0.112029.zip";
    sha256 = "1d54c0414402f5fd7f296566ac1a8f9722e55ef46eaa526d494c5a795d48fbd0";
  };

  meta = with stdenv.lib; {
    description = "Continuous code quality inspection tool";
    homepage = "https://www.sonarsource.com/products/sonarqube/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ];
    sourceProvenance = sourceProvenance.binaryBytecode;
    platforms = platforms.linux;
  };

  buildInputs = [ jdk17_headless ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    cp -r * $out/

    runHook postInstall
  '';
}
