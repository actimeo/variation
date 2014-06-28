<?php
require '../inc/config.inc.php';
require '../inc/enums.inc.php';
require '../inc/localise.inc.php';
require '../inc/pgprocedures.class.php';
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

include 'SabreDAV/vendor/autoload.php';
use Sabre\DAV;
use Sabre\Accueil;

$authBackend = new Accueil\AccueilDigestAuth ($base);

//$authBackend = new Accueil\AccueilBasicAuth ($base);
// The object tree needs in turn to be passed to the server class
$subusagers = new Dav\SimpleCollection ('Usagers', array (new Accueil\UsagersDossiersIndividuels ($authBackend, $base),
							  new Accueil\ListesPersonnes($authBackend, $base, 'usager'),
							  new Accueil\EventsPersonnes($authBackend, $base)
							  ));
$root = new Dav\SimpleCollection ('Accueil', array (
						    $subusagers,
						    new Dav\SimpleCollection ('Personnels'),
						    new Dav\SimpleCollection ('Contacts'),
						    new Dav\SimpleCollection ('Famille')));

$server = new DAV\Server($root);

// We're required to set the base uri, it is recommended to put your webdav server on a root of a domain
$server->setBaseUri('/webdav/index.php/');

// And off we go!
$authPlugin = new Dav\Auth\Plugin($authBackend, 'Accueil');
$server->addPlugin ($authPlugin);

$server->exec();
?>
