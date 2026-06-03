{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, cups
, pappl
, libppd
, libcupsfilters
, pappl-retrofit
, curl
, openssl
, systemd
, hplip
, perl
, avahi
, gnupg
, python3
, bind
}:

stdenv.mkDerivation rec {
  pname = "hplip-printer-app";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "hplip-printer-app";
    rev = "b3fc7f3a83dd6f78641c45c7da4be0b662ece818";
    hash = "sha256-QZe7aPOeTBd0tSpNULnx//8B+UQxXX7c+TyxzfCjU2c=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper perl ];

  buildInputs = [
    cups
    pappl
    libppd
    libcupsfilters
    pappl-retrofit
    curl
    openssl
    systemd
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "sysconfdir=/etc"
    "localstatedir=/var"
    "cupsserverbin="
    "unitdir=${placeholder "out"}/lib/systemd/system"
  ];

  installFlags = [
    "statedir=${placeholder "out"}/var/lib/hplip-printer-app"
    "spooldir=${placeholder "out"}/var/spool/hplip-printer-app"
  ];

  postInstall = ''
    wrapProgram $out/bin/hplip-printer-app \
      --prefix PATH : ${lib.makeBinPath [ hplip perl avahi gnupg python3 bind.dnsutils ]}
  '';

  meta = with lib; {
    description = "HPLIP Printer Application";
    homepage = "https://github.com/OpenPrinting/hplip-printer-app";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}