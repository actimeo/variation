<?php

/***********************************
  Exemple utilisant un tableau PHP
************************************/

require('fpdm.php');

$fields = array(
	'name'    => 'My name',
	'address' => 'My address',
	'city'    => 'My city',
	'phone'   => 'My phone number'
);

$pdf = new FPDM('template.pdf');
$pdf->Load($fields, false); // second paramètre : false si les valeurs des champs sont en ISO-8859-1, true si UTF-8
$pdf->Merge();
$pdf->Output();
?>
