<?php

/***********************************
  Exemple utilisant un fichier FDF
************************************/

require('fpdm.php');

$pdf = new FPDM('template.pdf', 'fields.fdf');
$pdf->Merge();
$pdf->Output();
?>
