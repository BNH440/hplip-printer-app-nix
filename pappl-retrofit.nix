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
    rev = "edca0c166920230f55f6c34553ee0d1c7a6319a8";
    hash = "sha256-3rSxlD3UjSVUhXuxgRu8J+we4VpXbhiqKP89zDW5kE0=";
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