{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, cups
, pappl
, libcupsfilters
, libppd
}:

stdenv.mkDerivation rec {
  pname = "pappl-retrofit";
  version = "1.0b2";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "pappl-retrofit";
    rev = "1.0b2";
    hash = "sha256-YBU1uFleyDsseHnEnbEd4XFL/4NF2WTMK3kNDZjyBaY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    cups
    pappl
    libcupsfilters
    libppd
  ];

  meta = with lib; {
    description = "Retrofit classic CUPS drivers for pappl";
    homepage = "https://github.com/OpenPrinting/pappl-retrofit";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}