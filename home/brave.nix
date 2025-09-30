{pkgs, ...}:

{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Darkreader
      { id = "acacmjcicejlmjcheoklfdchempahoag"; } # JSON Lite
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Dev Tools
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylix
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
      { id = "cigimgkncpailblodniinggablglmebn"; } # Stylix-generated Theme
    ];
    commandLineArgs = [
      "--force-dark-mode"
      "--enable-features=WebUIDarkMode"
      "--disable-features=AutofillSavePaymentMethods,AutofillCreditCardAuthentication,AutofillCreditCardUpload"
      "--disable-features=AutofillSaveCardDialog,AutofillEnableAccountWalletStorage,AutofillCreditCardDownstream"
      "--password-store=basic"
      "--disable-save-password-bubble"
      "--disable-autofill-keyboard-accessory-view"
      "--wallet-service-use-sandbox"
    ];
  };
}
